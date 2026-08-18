// lib/controllers/auth_controller.dart
import 'dart:async';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rexone_mobile/config/config.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/components/components.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../routes/app_routes.dart';
import '../services/services.dart';

class AuthController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final StorageService _storage = Get.find<StorageService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final PushNotiService _pushNotiService = Get.find<PushNotiService>();

  static const int maxAttempts = 3;
  // Attempts UI default — server is the source of truth, this is a display fallback.

  // Observables
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

  // Passcode attempt limiting
  var attemptsLeft = maxAttempts.obs;
  var hasFailureHistory = false.obs;
  var cooldownSecondsLeft = 0.obs;

  Timer? _cooldownTimer;

  // Resend countdowns
  var resendSecondsLeft = 0.obs;
  Timer? _resendTimer;

  // Google sign up challenge
  var googleChallengeToken = ''.obs;
  bool get isGooglePasscodeSetup => googleChallengeToken.value.isNotEmpty;

  // Pin controllers
  final signinPin = PinInputController();
  final signupPin = PinInputController();
  final signupConfirmPin = PinInputController();
  final confirmPin = PinInputController();

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

  // ---------------------------------------------------------------------
  // Auth Status
  // ---------------------------------------------------------------------

  Future<void> checkAuthStatus() async {
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      authToken.value = token;
      if (Get.isRegistered<SocketService>()) {
        Get.find<SocketService>().connect(token);
      }
      final storedUser = _storage.getUserData();
      if (storedUser != null) {
        currentUser.value = storedUser;
        isLoggedIn.value = true;
      }
      // Validate session with backend
      await getCurrentUser();
    } else {
      isLoggedIn.value = false;
    }
  }

  // ---------------------------------------------------------------------
  // Passcode Retry State
  // ---------------------------------------------------------------------

  void loadRetryState() {
    final state = _storage.getPasscodeRetry(email.value);
    final now = DateTime.now().millisecondsSinceEpoch;
    final cooldownUntil = (state?['cooldownUntilMs'] as num?)?.toInt() ?? 0;

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
    });
  }

  void _resetRetryState() {
    attemptsLeft.value = maxAttempts;
    hasFailureHistory.value = false;

    cooldownSecondsLeft.value = 0;
    _cooldownTimer?.cancel();
    _persistRetryState();
  }

  void _applySignInFailure({
    required int remainingAttempts,
    required int cooldownRemaining,
  }) {
    hasFailureHistory.value = true;

    // Use server values directly
    attemptsLeft.value = remainingAttempts;

    if (cooldownRemaining > 0) {
      attemptsLeft.value = 0;
      final until =
          DateTime.now().millisecondsSinceEpoch + cooldownRemaining * 1000;
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
  // Auth Flow
  // ---------------------------------------------------------------------

  bool validateEmail() {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email.value.trim())) {
      emailError.value = Constants.locale.invalidEmail.tr;
      return false;
    }
    emailError.value = null;
    return true;
  }

  // Handle continue from auth page
  Future<void> handleContinue() async {
    if (!validateEmail()) return;

    final status = await peekUser(email.value);

    switch (status) {
      case EPeekedUserStatus.error:
        AppSnackbar.error(Constants.locale.connectionFailed.tr);
        break;

      case EPeekedUserStatus.exists:
        passcode.value = '';
        signinPin.clear();
        loadRetryState();
        AppRoutes.toSignInPasscode();
        break;

      case EPeekedUserStatus.existsUnconfirmed:
        passcode.value = '';
        signupPin.clear();
        signupConfirmPin.clear();
        confirmPin.clear();
        await sendConfirmationOTPCode();
        AppRoutes.toConfirmEmail(email: email.value);
        break;

      case EPeekedUserStatus.notExists:
        passcode.value = '';
        confirmPasscode.value = '';
        signupPin.clear();
        signupConfirmPin.clear();
        AppRoutes.toSignUpPasscodeCreate();
        break;
    }
  }

  // Handle confirm passcode
  Future<void> handleConfirmPasscode() async {
    if (confirmPasscode.value.length != 6) {
      signupConfirmPin.triggerError();
      AppSnackbar.error(Constants.locale.passcode6Digits.tr);
      return;
    }

    if (passcode.value != confirmPasscode.value) {
      signupConfirmPin.triggerError();
      AppSnackbar.error(Constants.locale.passcodesDoNotMatch.tr);
      return;
    }

    if (isGooglePasscodeSetup) {
      await completeGoogleSignIn();
      return;
    }

    AppRoutes.toSignUpInfo(
      email: email.value,
      passcode: passcode.value,
      confirmPasscode: confirmPasscode.value,
    );
  }

  // Step 1: Check if user exists
  Future<EPeekedUserStatus> peekUser(String emailAddress) async {
    try {
      final response = await _auth.peekUser(emailAddress);
      if (!response.success || response.data == null) {
        return EPeekedUserStatus.error;
      }
      final data = response.data!;
      if (!data.userExists) return EPeekedUserStatus.notExists;
      return data.confirmed
          ? EPeekedUserStatus.exists
          : EPeekedUserStatus.existsUnconfirmed;
    } catch (_) {
      return EPeekedUserStatus.error;
    }
  }

  void _storeSession(AuthResponse response) {
    authToken.value = response.token;
    _storage.setToken(response.token);
    _storage.setUserEmail(response.user.email);
    currentUser.value = response.user;
    _storage.setUserData(response.user);
    isLoggedIn.value = true;

    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().connect(response.token);
    }
    if (Get.isRegistered<PushNotiService>()) {
      // Sync user data with OneSignal
      _pushNotiService.syncUser(response.user);
    }
    if (Get.isRegistered<AnalyticsService>()) {
      // Set user ID and properties
      _analytics.setUserId(response.user.id);
      _analytics.setUserProperty('email', response.user.email);
      _analytics.setUserProperty('provider', response.user.provider ?? 'email');
      _analytics.logSignIn(method: response.user.provider);
    }
  }

  // Step 2a: Sign in with email and passcode (existing user)
  Future<void> signIn() async {
    if (cooldownSecondsLeft.value > 0) return;
    if (passcode.value.length != 6) {
      signinPin.triggerError();
      AppSnackbar.error(Constants.locale.passcode6Digits.tr);
      return;
    }

    try {
      final response = await _auth.signIn(email.value, passcode.value);

      if (response.success && response.data != null) {
        final data = response.data!;

        // Check if user is confirmed (has user + token)
        if (data.user != null && data.token != null) {
          _resetRetryState();
          _analytics.logSignIn(method: 'email');
          // Sync noti user & Request permission after Email signin
          await _handleSuccessfulAuth(
            AuthResponse(user: data.user!, token: data.token!),
          );
        } else if (data.otpSent) {
          // Unconfirmed user - OTP sent
          AppSnackbar.success(response.message);
          _startResendCountdown(30);
          AppRoutes.toConfirmEmail(email: email.value);
        } else {
          AppSnackbar.error(response.message);
        }
      } else {
        signinPin.triggerError();

        final data = response.data;
        final remainingAttempts = data?.remainingAttempts ?? 0;
        final cooldownRemaining = data?.cooldownRemaining ?? 0;

        _applySignInFailure(
          remainingAttempts: remainingAttempts,
          cooldownRemaining: cooldownRemaining,
        );

        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.signInFailed.tr, e: e, stk: stk);
    }
  }

  // Step 2b: Send confirmation code (for new user registration)
  Future<void> sendConfirmationOTPCode() async {
    try {
      final response = await _auth.sendConfirmationOTPCode(email.value);
      if (response.success) {
        _startResendCountdown(30);
        if (Get.currentRoute != AppRoutes.confirmEmail) {
          AppRoutes.toConfirmEmail(email: email.value);
        }
      } else {
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.sendCodeFailed.tr, e: e, stk: stk);
    }
  }

  // Step 3: Confirm code (for new user)
  Future<void> confirmOTPCode(String code) async {
    try {
      final response = await _auth.confirmOTPCode(email.value, code);
      if (response.success && response.data != null) {
        _analytics.logEmailVerified();
        _analytics.logOnboardingCompleted();
        // Sync noti user & Request permission after Email signup
        await _handleSuccessfulAuth(response.data!);
      } else {
        confirmPin.triggerError();
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.verificationFailed.tr, e: e, stk: stk);
    }
  }

  // Register new user with full details
  Future<void> signUp() async {
    if (fullName.value.trim().length < 2) {
      AppSnackbar.error(Constants.locale.enterFullName.tr);
      return;
    }
    if (username.value.length < 3) {
      AppSnackbar.error(Constants.locale.usernameMinLength.tr);
      return;
    }
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(username.value)) {
      AppSnackbar.error(Constants.locale.usernameCharset.tr);
      return;
    }

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
        _analytics.logSignUp(method: 'email');
        _analytics.logOnboardingStarted();
        AppRoutes.toConfirmEmail(email: email.value);
      } else {
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.registrationFailed.tr, e: e, stk: stk);
    }
  }

  // Google Sign In (existing account signs straight in; a new account
  // gets a challenge token and must set a passcode to finish sign up).
  Future<void> signInWithGoogle() async {
    try {
      final signIn = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await signIn.initialize(serverClientId: AppConfig.googleServerClientId);
        _googleInitialized = true;
      }

      final user = await signIn.authenticate();
      const scopes = <String>['email'];
      final auth = await user.authorizationClient.authorizeScopes(scopes);
      final accessToken = auth.accessToken;

      final response = await _auth.signInWithGoogle(accessToken);

      if (response.success && response.data != null) {
        // New Google account: set a passcode to complete account creation.
        final data = response.data!;
        if (data.passwordRequired && data.challengeToken != null) {
          googleChallengeToken.value = data.challengeToken!;
          email.value = user.email;
          passcode.value = '';
          confirmPasscode.value = '';
          signupPin.clear();
          signupConfirmPin.clear();
          AppRoutes.toSignUpPasscodeCreate();
        } else if (data.user != null && data.token != null) {
          email.value = user.email;
          _analytics.logSignIn(method: 'google');
          _analytics.logOnboardingStarted();
          // Sync noti user & Request permission after Google signin
          await _handleSuccessfulAuth(
            AuthResponse(user: data.user!, token: data.token!),
          );
        }
      } else {
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(
        Constants.locale.signInGoogleFailure.tr,
        e: e,
        stk: stk,
      );
    }
  }

  // Complete Google sign up with the newly created passcode.
  Future<void> completeGoogleSignIn() async {
    if (passcode.value.length != 6) {
      signupPin.triggerError();
      AppSnackbar.error(Constants.locale.passcode6Digits.tr);
      return;
    }
    if (passcode.value != confirmPasscode.value) {
      signupConfirmPin.triggerError();
      AppSnackbar.error(Constants.locale.passcodesDoNotMatch.tr);
      return;
    }

    try {
      final response = await _auth.googleSignInComplete(
        passcode.value,
        googleChallengeToken.value,
      );

      if (response.success && response.data != null) {
        googleChallengeToken.value = '';
        _analytics.logSignUp(method: 'google');
        _analytics.logOnboardingCompleted();
        await _handleSuccessfulAuth(response.data!);
      } else if (response.statusCode == 429) {
        AppSnackbar.error(Constants.locale.googleTooManyAttempts.tr);
      } else {
        AppSnackbar.error(response.error ?? response.message);
        if (response.statusCode == 401) {
          googleChallengeToken.value = '';
          AppRoutes.toAuth();
        }
      }
    } catch (e, stk) {
      AppSnackbar.error(
        Constants.locale.signInGoogleFailure.tr,
        e: e,
        stk: stk,
      );
    }
  }

  // Get current user
  Future<void> getCurrentUser() async {
    try {
      final response = await _auth.getCurrentUser();
      if (response.success && response.data != null) {
        currentUser.value = response.data;
        _storage.setUserData(response.data!);
      }
    } catch (_) {}
  }

  // Forgot passcode: email a reset link (60s resend countdown).
  Future<void> forgotPassword() async {
    if (!validateEmail()) return;
    try {
      final response = await _auth.forgotPasscode(email.value);
      if (response.success) {
        _startResendCountdown(60);
        AppSnackbar.success(response.message);
      } else {
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.resetFailed.tr, e: e, stk: stk);
    }
  }

  /// TODO: Called by the API layer when the active session was replaced by a
  /// newer sign in on this platform (or session validation fails).
  void handleSessionExpired({bool replaced = false}) {
    if (!isLoggedIn.value) return;
    _clearLocalSession();
    AppRoutes.toAuth();
    if (replaced) {
      AppSnackbar.error(Constants.locale.sessionReplaced.tr);
    }
  }

  void _clearLocalSession() {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().disconnect();
    }
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
    confirmPin.clear();
    _cooldownTimer?.cancel();
    _resendTimer?.cancel();
    cooldownSecondsLeft.value = 0;
    resendSecondsLeft.value = 0;
    attemptsLeft.value = maxAttempts;
    hasFailureHistory.value = false;
    // Clear OneSignal user data
    if (Get.isRegistered<PushNotiService>()) {
      _pushNotiService.clearUser();
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {}

    if (currentUser.value?.provider == 'google') {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
    }

    _clearLocalSession();
    _storage.clearRouteStack();
    if (Get.isRegistered<AnalyticsService>()) {
      _analytics.clearUserId();
      _analytics.logSignOut();
    }
    AppRoutes.toAuth();
  }

  // handle push noti and redirect after successful auth
  Future<void> _handleSuccessfulAuth(AuthResponse response) async {
    // 1. Store session + sync user
    _storeSession(response);

    // 2. Request push permission
    await _pushNotiService.requestPermission();

    // 3. Navigate to home
    AppRoutes.toHome();
  }
}
