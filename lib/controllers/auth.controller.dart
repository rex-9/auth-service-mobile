// lib/controllers/auth_controller.dart
import 'dart:async';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meritbox_mobile/config/config.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/components/components.dart';
import 'package:meritbox_mobile/models/enums.dart';
import 'package:meritbox_mobile/models/models.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../helpers/helpers.dart';
import '../routes/app_routes.dart';
import '../services/services.dart';

class AuthController extends GetxController {
  //if we have the mulitple implementations of the same service, we can use the tag to differentiate between them
  //we have to find by the type we pass // example: Get.find<AuthService>(tag: 'auth'); not with Get.find<AuthServiceImpl>();
  final AuthService _auth = Get.find<AuthService>();
  final StorageService _storage = Get.find();
  final AppConfig _config = AppConfig();
  final _emailValidator = EmailValidator();
  final _fullNameValidator = FullnameValidator();
  final _userNameValidator = UserNameValidator();

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
  var signUpInfoError = RxnString();


  // Passcode attempt limiting
  var attemptsLeft = maxAttempts.obs;
  var hasFailureHistory = false.obs;
  var cooldownSecondsLeft = 0.obs;
  int _cooldownLevel = 0;
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

  // ---------------------------------------------------------------------
  // Auth Status
  // ---------------------------------------------------------------------

  Future<void> checkAuthStatus() async {
    isCheckingAuth.value = true;

    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      authToken.value = token;
      final storedUser = _storage.getUserData();
      if (storedUser != null) {
        currentUser.value = storedUser;
        isLoggedIn.value = true;
        isCheckingAuth.value = false;
        return;
      }
      // Fallback: fetch from API
      await getCurrentUser();
    } else {
      isLoggedIn.value = false;
    }

    isCheckingAuth.value = false;
  }

  // ---------------------------------------------------------------------
  // Passcode Retry State
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
    emailError.value = _emailValidator.validate(email.value);
    return emailError.value == null;
  }

  // Step 1: Check if user exists
  Future<PeekedUserStatus> peekUser(String emailAddress) async {
    try {
      final response = await _auth.peekUser(emailAddress);
      if (!response.success || response.data == null) {
        return PeekedUserStatus.error;
      }
      final data = response.data!;
      if (!data.userExists) return PeekedUserStatus.notExists;
      return data.confirmed
          ? PeekedUserStatus.exists
          : PeekedUserStatus.existsUnconfirmed;
    } catch (_) {
      return PeekedUserStatus.error;
    }
  }

  void _storeSession(AuthResponse response) {
    authToken.value = response.token;
    _storage.setToken(response.token);
    _storage.setUserEmail(response.user.email);
    currentUser.value = response.user;
    _storage.setUserData(response.user);
    isLoggedIn.value = true;
  }

  // Step 2a: Sign in with email and passcode (existing user)
  Future<void> signIn() async {
    if (isLoading.value || cooldownSecondsLeft.value > 0) return;
    if (passcode.value.length != 6) {
      signinPin.triggerError();
      AppSnackbar.error(Constants.locale.passcode6Digits.tr);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _auth.signIn(email.value, passcode.value);

      if (response.success && response.data != null) {
        final data = response.data!;

        // Check if user is confirmed (has user + token)
        if (data.user != null && data.token != null) {
          _resetRetryState();
          _storeSession(AuthResponse(user: data.user!, token: data.token!));
          AppRoutes.toHome();
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
        if (Get.currentRoute != AppRoutes.confirmEmail) {
          AppRoutes.toConfirmEmail(email: email.value);
        }
      } else {
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.sendCodeFailed.tr, e: e, stk: stk);
    } finally {
      isLoading.value = false;
    }
  }

  // Step 3: Confirm code (for new user)
  Future<void> confirmCode(String code) async {
    isLoading.value = true;
    try {
      final response = await _auth.confirmCode(email.value, code);
      if (response.success && response.data != null) {
        _storeSession(response.data!);
        AppRoutes.toHome();
      } else {
        confirmPin.triggerError();
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.verificationFailed.tr, e: e, stk: stk);
    } finally {
      isLoading.value = false;
    }
  }


  //validate UserName

  bool validateFullName() {
    signUpInfoError.value = _fullNameValidator.validate(fullName.value);
    return signUpInfoError.value == null;
  }

  bool validateUserName(){
    signUpInfoError.value = _userNameValidator.validate(username.value);
    return signUpInfoError.value == null;
  }

  bool validateSignUpInfo() {
    final isFullNameValid = validateFullName();
    final isUsernameValid = validateUserName();
    return isFullNameValid && isUsernameValid;
  }


  // Register new user with full details
  Future<void> signUp() async {

    if (!validateSignUpInfo()) {
      AppSnackbar.error(
        signUpInfoError.value ?? '',
      );
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
        AppRoutes.toConfirmEmail(email: email.value);
      } else {
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.registrationFailed.tr, e: e, stk: stk);
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
        await signIn.initialize(serverClientId: _config.googleServerClientId);
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
          AppRoutes.toSignUpPasscode();
        } else {
          email.value = user.email;
          // Existing user - fetch full session
          final sessionResponse = await _auth.signInWithGoogle(accessToken);
          if (sessionResponse.success && sessionResponse.data != null) {
            _storeSession(AuthResponse(user: data.user!, token: data.token!));
            AppRoutes.toHome();
          }
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
    } finally {
      isLoading.value = false;
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

    isLoading.value = true;
    try {
      final response = await _auth.googleSignInComplete(
        passcode.value,
        googleChallengeToken.value,
      );

      if (response.success && response.data != null) {
        googleChallengeToken.value = '';
        _storeSession(response.data!);
        AppRoutes.toHome();
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
    } finally {
      isLoading.value = false;
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
    isLoading.value = true;
    try {
      final response = await _auth.forgotPassword(email.value);
      if (response.success) {
        _startResendCountdown(60);
        AppSnackbar.success(response.message);
      } else {
        AppSnackbar.error(response.error ?? response.message);
      }
    } catch (e, stk) {
      AppSnackbar.error(Constants.locale.resetFailed.tr, e: e, stk: stk);
    } finally {
      isLoading.value = false;
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
    AppRoutes.toAuth();
  }
}
