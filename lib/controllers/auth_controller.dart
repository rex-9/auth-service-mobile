// lib/controllers/auth_controller.dart
import 'dart:async';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meritbox_mobile/config/config.dart';
import 'package:meritbox_mobile/widgets/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final AuthService _auth = Get.find();
  final StorageService _storage = Get.find();

  static const int maxAttempts = 3;
  static const List<int> cooldownSecondsByLevel = [30, 60, 120];

  // Observables
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var authToken = ''.obs;
  var currentUser = Rxn<UserModel>();

  // Form data
  var email = ''.obs;
  var emailError = RxnString();
  var passcode = ''.obs;
  var confirmPasscode = ''.obs;
  var fullName = ''.obs;
  var username = ''.obs;

  // Passcode attempt limiting (mirrors the web: 3 attempts, then
  // escalating 30s/60s/120s cooldowns, persisted per email).
  var attemptsLeft = maxAttempts.obs;
  var hasFailureHistory = false.obs;
  var cooldownSecondsLeft = 0.obs;
  int _cooldownLevel = 0;
  Timer? _cooldownTimer;

  // Resend countdowns (30s verify email, 60s forgot passcode).
  var resendSecondsLeft = 0.obs;
  Timer? _resendTimer;

  // Google sign up challenge: non-empty means the new Google account
  // must set a passcode to finish account creation.
  var googleChallengeToken = ''.obs;
  bool get isGooglePasscodeSetup => googleChallengeToken.value.isNotEmpty;

  // Pin fields are owned here so GetView pages stay stateless and the
  // controller can clear/disable them (e.g. when a cooldown ends).
  final signinPin = PinInputController();
  final signupPin = PinInputController();
  final signupConfirmPin = PinInputController();
  final verifyPin = PinInputController();

  // init loading state while checking auth status
  var isCheckingAuth = true.obs;

  bool _googleInitialized = false;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  @override
  void onClose() {
    _cooldownTimer?.cancel();
    _resendTimer?.cancel();
    super.onClose();
  }

  Future<void> checkAuthStatus() async {
    isCheckingAuth.value = true;
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      authToken.value = token;
      isLoggedIn.value = true;
      final storedUser = _storage.getUserData();
      if (storedUser != null) {
        currentUser.value = UserModel.fromJson(storedUser);
      }
      await getCurrentUser();
    } else {
      isLoggedIn.value = false;
    }
    isCheckingAuth.value = false;
  }

  // ---------------------------------------------------------------------
  // Passcode retry state (persisted per email, like the web client)
  // ---------------------------------------------------------------------

  void loadRetryState() {
    final state = _storage.getPasscodeRetry(email.value);
    final now = DateTime.now().millisecondsSinceEpoch;
    final cooldownUntil = (state?['cooldownUntilMs'] as num?)?.toInt() ?? 0;
    _cooldownLevel = (state?['cooldownLevel'] as num?)?.toInt() ?? 0;
    hasFailureHistory.value = state?['hasFailureHistory'] == true;

    if (cooldownUntil > now) {
      attemptsLeft.value = 0;
      _startCooldownUntil(cooldownUntil);
    } else {
      final remaining = (state?['remainingAttempts'] as num?)?.toInt();
      attemptsLeft.value = (remaining == null || remaining <= 0)
          ? maxAttempts
          : remaining;
      cooldownSecondsLeft.value = 0;
      _cooldownTimer?.cancel();
    }
  }

  void _persistRetryState({int cooldownUntilMs = 0}) {
    _storage.setPasscodeRetry(email.value, {
      'remainingAttempts': attemptsLeft.value,
      'cooldownUntilMs': cooldownUntilMs,
      'hasFailureHistory': hasFailureHistory.value,
      'cooldownLevel': _cooldownLevel,
    });
  }

  void _resetRetryState() {
    attemptsLeft.value = maxAttempts;
    hasFailureHistory.value = false;
    _cooldownLevel = 0;
    cooldownSecondsLeft.value = 0;
    _cooldownTimer?.cancel();
    _persistRetryState();
  }

  /// Applies a failed sign-in. Prefers the server retry metadata
  /// (remaining_attempts / retry_after) and falls back to local counting.
  void _applySignInFailure(Map<String, dynamic>? data) {
    hasFailureHistory.value = true;

    final serverRemaining = (data?['remaining_attempts'] as num?)?.toInt();
    final serverRetryAfter =
        ((data?['retry_after'] ?? data?['cooldown_remaining']) as num?)
            ?.toInt();

    attemptsLeft.value = serverRemaining ?? (attemptsLeft.value - 1);
    if (attemptsLeft.value < 0) attemptsLeft.value = 0;

    var waitSeconds = serverRetryAfter ?? 0;
    if (waitSeconds <= 0 && attemptsLeft.value == 0) {
      // No server cooldown given: escalate locally 30s -> 60s -> 120s.
      _cooldownLevel = (_cooldownLevel + 1).clamp(1, 3);
      waitSeconds = cooldownSecondsByLevel[_cooldownLevel - 1];
    }

    if (waitSeconds > 0) {
      attemptsLeft.value = 0;
      final until = DateTime.now().millisecondsSinceEpoch + waitSeconds * 1000;
      _startCooldownUntil(until);
      _persistRetryState(cooldownUntilMs: until);
    } else {
      _persistRetryState();
    }
  }

  void _startCooldownUntil(int untilMs) {
    _cooldownTimer?.cancel();
    void tick() {
      final left = ((untilMs - DateTime.now().millisecondsSinceEpoch) / 1000)
          .ceil();
      if (left <= 0) {
        cooldownSecondsLeft.value = 0;
        _cooldownTimer?.cancel();
        // Cooldown over: restore attempts and clear the typed passcode.
        attemptsLeft.value = maxAttempts;
        passcode.value = '';
        signinPin.clear();
        _persistRetryState();
      } else {
        cooldownSecondsLeft.value = left;
      }
    }

    tick();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void _startResendCountdown(int seconds) {
    _resendTimer?.cancel();
    resendSecondsLeft.value = seconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (resendSecondsLeft.value <= 1) {
        resendSecondsLeft.value = 0;
        _resendTimer?.cancel();
      } else {
        resendSecondsLeft.value -= 1;
      }
    });
  }

  // ---------------------------------------------------------------------
  // Auth flow
  // ---------------------------------------------------------------------

  bool validateEmail() {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email.value.trim())) {
      emailError.value = 'invalid_email'.tr;
      return false;
    }
    emailError.value = null;
    return true;
  }

  // Step 1: Check if user exists
  Future<PeekedUserStatus> peekUser(String emailAddress) async {
    try {
      final response = await _auth.peekUser(emailAddress);

      if (!response.success) {
        // API call failed
        return PeekedUserStatus.error;
      }
      // API succeeded, check if user exists
      return response.data == true
          ? PeekedUserStatus.exists
          : PeekedUserStatus.notExists;
    } catch (e) {
      // Exception occurred
      return PeekedUserStatus.error;
    }
  }

  void _storeSession(Map<String, dynamic> data) {
    final token = data['token'];
    authToken.value = token;
    _storage.setToken(token);
    _storage.setUserEmail(email.value);
    final user = data['user'];
    if (user is Map) {
      currentUser.value = UserModel.fromJson(Map<String, dynamic>.from(user));
      _storage.setUserData(Map<String, dynamic>.from(user));
    }
    isLoggedIn.value = true;
  }

  // Step 2a: Sign in with email and passcode (existing user)
  Future<void> signIn() async {
    if (isLoading.value || cooldownSecondsLeft.value > 0) return;
    if (passcode.value.length != 6) {
      signinPin.triggerError();
      AppSnackbar.error('passcode_6_digits'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _auth.signIn(email.value, passcode.value);

      if (response.success && response.data?['token'] != null) {
        _resetRetryState();
        _storeSession(response.data!);
        AppRoutes.toHome();
      } else if (response.success) {
        // Signed in with an unconfirmed email: the server just sent a
        // fresh confirmation code, so continue to email verification.
        AppSnackbar.success(response.message);
        _startResendCountdown(30);
        AppRoutes.toVerifyEmail(arguments: {'email': email.value});
      } else {
        signinPin.triggerError();
        _applySignInFailure(response.data);
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error('sign_in_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Step 2b: Send confirmation code (for new user registration)
  Future<void> sendConfirmationCode() async {
    isLoading.value = true;

    try {
      final response = await _auth.sendConfirmationCode(email.value);

      if (response.success) {
        _startResendCountdown(30);
        if (Get.currentRoute != AppRoutes.verifyEmail) {
          AppRoutes.toVerifyEmail(arguments: {'email': email.value});
        }
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error('send_code_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Step 3: Verify code (for new user)
  Future<void> verifyCode(String code) async {
    isLoading.value = true;

    try {
      final response = await _auth.confirmCode(email.value, code);

      if (response.success && response.data?['token'] != null) {
        // User is confirmed and signed in
        _storeSession(response.data!);
        AppRoutes.toHome();
      } else {
        verifyPin.triggerError();
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error('verification_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Register new user with full details
  Future<void> signUp() async {
    if (fullName.value.trim().length < 2) {
      AppSnackbar.error('enter_full_name'.tr);
      return;
    }
    if (username.value.length < 3) {
      AppSnackbar.error('username_min_length'.tr);
      return;
    }
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(username.value)) {
      AppSnackbar.error('username_charset'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _auth.signUp(
        username: username.value,
        name: fullName.value,
        email: email.value,
        password: passcode.value,
        passwordConfirmation: confirmPasscode.value,
      );

      if (response.success) {
        _startResendCountdown(30);
        AppRoutes.toVerifyEmail(arguments: {'email': email.value});
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error('registration_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign In (existing account signs straight in; a new account
  // gets a challenge token and must set a passcode to finish sign up).
  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    try {
      final signIn = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await signIn.initialize(serverClientId: AppConfig.googleServerClientId);
        _googleInitialized = true;
      }

      // Step 1: authenticate user
      final user = await signIn.authenticate();

      // Step 2: request authorization (scopes)
      const scopes = <String>['email'];
      final auth = await user.authorizationClient.authorizeScopes(scopes);
      final accessToken = auth.accessToken;

      final response = await _auth.signInWithGoogle(accessToken);

      if (response.success && response.data?['passcode_required'] == true) {
        // New Google account: set a passcode to complete account creation.
        googleChallengeToken.value = response.data?['challenge_token'] ?? '';
        email.value = user.email;
        passcode.value = '';
        confirmPasscode.value = '';
        signupPin.clear();
        signupConfirmPin.clear();
        AppRoutes.toSignUpPasscode();
      } else if (response.success && response.data?['token'] != null) {
        email.value = user.email;
        _storeSession(response.data!);
        AppRoutes.toHome();
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error('sign_in_google_failure'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Complete Google sign up with the newly created passcode.
  Future<void> completeGoogleSignIn() async {
    if (passcode.value.length != 6) {
      signupPin.triggerError();
      AppSnackbar.error('passcode_6_digits'.tr);
      return;
    }
    if (passcode.value != confirmPasscode.value) {
      signupConfirmPin.triggerError();
      AppSnackbar.error('passcodes_do_not_match'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _auth.googleSignInComplete(
        passcode.value,
        googleChallengeToken.value,
      );

      if (response.success && response.data?['token'] != null) {
        googleChallengeToken.value = '';
        _storeSession(response.data!);
        AppRoutes.toHome();
      } else if (response.statusCode == 429) {
        final wait = (response.data?['retry_after'] as num?)?.toInt() ?? 30;
        AppSnackbar.error(
          'google_too_many_attempts'.trParams({'seconds': '$wait'}),
        );
      } else {
        AppSnackbar.error(response.message);
        if (response.statusCode == 401) {
          // Challenge expired: restart the Google flow.
          googleChallengeToken.value = '';
          AppRoutes.toAuth();
        }
      }
    } catch (e) {
      AppSnackbar.error('sign_in_google_failure'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Get current user
  Future<void> getCurrentUser() async {
    try {
      final response = await _auth.getCurrentUser();
      if (response.success && response.data != null) {
        currentUser.value = UserModel.fromJson(response.data!);
        _storage.setUserData(response.data!);
      }
    } catch (e) {
      // Error getting user; keep the cached one.
    }
  }

  // Forgot passcode: email a reset link (60s resend countdown).
  Future<void> forgotPassword() async {
    if (!validateEmail()) return;
    isLoading.value = true;

    try {
      final response = await _auth.forgotPassword(email.value);
      if (response.success) {
        _startResendCountdown(60);
        AppSnackbar.success(response.message);
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error('reset_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Called by the API layer when the active session was replaced by a
  /// newer sign in on this platform (or session validation fails).
  void handleSessionExpired({bool replaced = false}) {
    if (!isLoggedIn.value) return;
    _clearLocalSession();
    AppRoutes.toAuth();
    if (replaced) {
      AppSnackbar.error('session_replaced'.tr);
    }
  }

  void _clearLocalSession() {
    _storage.clearSession();
    authToken.value = '';
    isLoggedIn.value = false;
    currentUser.value = null;
    email.value = '';
    emailError.value = null;
    passcode.value = '';
    confirmPasscode.value = '';
    fullName.value = '';
    username.value = '';
    googleChallengeToken.value = '';
    signinPin.clear();
    signupPin.clear();
    signupConfirmPin.clear();
    verifyPin.clear();
    _cooldownTimer?.cancel();
    _resendTimer?.cancel();
    cooldownSecondsLeft.value = 0;
    resendSecondsLeft.value = 0;
    attemptsLeft.value = maxAttempts;
    hasFailureHistory.value = false;
  }

  // Sign out
  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Ignore network error on sign out
    }

    if (currentUser.value?.provider == 'google') {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        // Local sign out still proceeds
      }
    }

    _clearLocalSession();
    AppRoutes.toAuth();
  }
}
