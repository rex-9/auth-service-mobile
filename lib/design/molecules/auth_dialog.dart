import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_config.dart';
import '../../app_routes.dart';
import '../../contexts/contexts.dart';
import '../../controllers/controllers.dart';
import '../../locales/app_locales.dart';
import '../../reducers/google_sso_reducer.dart';
import '../../utils/utils.dart';
import '../atoms/atoms.dart';
import 'app_dialog.dart';
import 'auth/auth_dialogs.dart';

/// Mirrors web `src/design/molecules/AuthDialog.tsx` — the auth flow
/// orchestrator. Steps:
///
/// initial → (peek user)
///   ├─ exists      → signin-passcode
///   └─ not exists  → signup-passcode-create → signup-passcode-confirm
///                    → signup-info → verify-email → signed in
///
/// Plus: forgot-password, Google SSO (with passcode setup for new accounts),
/// per-email passcode retry attempts with escalating cooldowns.
enum AuthStep {
  initial,
  signinPasscode,
  signupPasscodeCreate,
  signupPasscodeConfirm,
  signupInfo,
  verifyEmail,
  forgotPassword,
}

class PersistedPasscodeRetryState {
  const PersistedPasscodeRetryState({
    required this.remainingAttempts,
    required this.cooldownUntilMs,
    required this.hasFailureHistory,
    this.cooldownLevel = 0,
  });

  final int remainingAttempts;
  final int cooldownUntilMs;
  final bool hasFailureHistory;
  final int cooldownLevel;
}

const fallbackAttemptsPerWindow = 3;
const fallbackCooldownSecondsByLevel = [30, 60, 120];

String getPasscodeRetryStorageKey(String signinKey) {
  final normalized = signinKey.trim().toLowerCase();
  return 'meritbox-passcode-retry-server:${normalized.isEmpty ? 'anonymous' : normalized}';
}

/// Opens the auth dialog over the current page (the web equivalent is
/// navigating to `?dialog=auth&step=initial`).
Future<void> showAuthDialog(
  BuildContext context, {
  String? sessionMessage,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.navy900.withValues(alpha: 0.4),
    builder: (_) => AuthDialog(sessionMessage: sessionMessage),
  );
}

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key, this.sessionMessage});

  final String? sessionMessage;

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  AuthStep _step = AuthStep.initial;

  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();

  String _passcode = '';
  String _passcodeConfirmation = '';
  String _otp = '';
  String _resetPasswordToken = '';

  String _error = '';
  String _message = '';
  String _emailError = '';
  String _otpError = '';
  String _passcodeError = '';
  bool _isLoading = false;
  bool _googlePasscodeSetupRequired = false;

  String _autoSubmittedSignInPasscode = '';
  String _autoSubmittedCreatePasscode = '';
  String _autoSubmittedConfirmPasscode = '';
  String _autoSubmittedVerifyEmailOtp = '';
  bool _signInRequestInFlight = false;
  bool _googleVerifyRequestInFlight = false;
  bool _googlePasscodeRequestInFlight = false;
  bool _wasCooldownActive = false;

  int _serverRemainingAttempts = fallbackAttemptsPerWindow;
  bool _hasFailureHistory = false;
  int _fallbackCooldownLevel = 0;

  final _signInCooldown = CountdownController();
  final _googleRetryCountdown = CountdownController();
  final _resendCodeCountdown = CountdownController();

  SharedPreferences? _prefs;

  String get _email => _emailController.text;

  AuthContext get _auth => context.read<AuthContext>();

  bool get _isGooglePasscodeFlow {
    final status = _auth.googleSsoState.status;
    return status == GoogleSsoFlowStatus.passcodeRequired ||
        status == GoogleSsoFlowStatus.submittingPasscode;
  }

  @override
  void initState() {
    super.initState();
    _error = widget.sessionMessage ?? '';
    _signInCooldown.addListener(_onSignInCooldownTick);
    _googleRetryCountdown.addListener(_rebuild);
    _resendCodeCountdown.addListener(_rebuild);
    SharedPreferences.getInstance().then((prefs) {
      if (!mounted) return;
      _prefs = prefs;
      _syncRetryStateFromStorage();
    });
  }

  @override
  void dispose() {
    _signInCooldown.removeListener(_onSignInCooldownTick);
    _signInCooldown.dispose();
    _googleRetryCountdown.dispose();
    _resendCodeCountdown.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  // -----------------------------------------------------------------------
  // Passcode retry persistence (mirrors localStorage on web).
  // -----------------------------------------------------------------------

  PersistedPasscodeRetryState _loadPersistedPasscodeRetryState(
    String signinKey,
  ) {
    const initial = PersistedPasscodeRetryState(
      remainingAttempts: fallbackAttemptsPerWindow,
      cooldownUntilMs: 0,
      hasFailureHistory: false,
    );
    final prefs = _prefs;
    if (prefs == null) return initial;

    final raw = prefs.getString(getPasscodeRetryStorageKey(signinKey));
    if (raw == null) return initial;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return initial;

      final rawRemaining = decoded['remainingAttempts'];
      final rawCooldownUntil = decoded['cooldownUntilMs'];
      final hasFailureHistory = decoded['hasFailureHistory'] == true;
      final rawLevel = decoded['cooldownLevel'];

      final parsedRemaining = rawRemaining is num
          ? rawRemaining.floor().clamp(0, 1 << 31)
          : fallbackAttemptsPerWindow;
      final parsedCooldownUntil =
          rawCooldownUntil is num ? rawCooldownUntil.round() : 0;
      final parsedLevel = rawLevel is num ? rawLevel.floor().clamp(0, 3) : 0;

      final isCooldownActive =
          parsedCooldownUntil > DateTime.now().millisecondsSinceEpoch;
      final normalizedRemainingAttempts =
          !isCooldownActive && parsedRemaining <= 0
              ? fallbackAttemptsPerWindow
              : parsedRemaining;

      return PersistedPasscodeRetryState(
        remainingAttempts: normalizedRemainingAttempts,
        cooldownUntilMs: isCooldownActive ? parsedCooldownUntil : 0,
        hasFailureHistory: hasFailureHistory,
        cooldownLevel: parsedLevel,
      );
    } catch (_) {
      return initial;
    }
  }

  void _persistPasscodeRetryState(
    String signinKey,
    PersistedPasscodeRetryState state,
  ) {
    _prefs?.setString(
      getPasscodeRetryStorageKey(signinKey),
      jsonEncode({
        'remainingAttempts': state.remainingAttempts,
        'cooldownUntilMs': state.cooldownUntilMs,
        'hasFailureHistory': state.hasFailureHistory,
        'cooldownLevel': state.cooldownLevel,
      }),
    );
  }

  PersistedPasscodeRetryState _syncRetryStateFromStorage() {
    final persisted = _loadPersistedPasscodeRetryState(_email);
    setState(() {
      _serverRemainingAttempts = persisted.remainingAttempts;
      _hasFailureHistory = persisted.hasFailureHistory;
      _fallbackCooldownLevel = persisted.cooldownLevel;
    });
    _signInCooldown.startAt(persisted.cooldownUntilMs);
    return persisted;
  }

  void _applyServerRetryMeta(
    PasscodeRetryMeta? retryMeta, {
    String mode = 'failure',
    int? statusCode,
    bool? shouldCountAttempt,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    var nextRemainingAttempts = _serverRemainingAttempts;
    var nextHasFailureHistory = _hasFailureHistory;
    var nextFallbackCooldownLevel = _fallbackCooldownLevel;

    final hasServerMeta = retryMeta?.remainingAttempts != null ||
        retryMeta?.cooldownSeconds != null ||
        retryMeta?.cooldownUntilMs != null;

    final countAttempt = shouldCountAttempt ?? (mode == 'success');

    final fallbackTriggeredStatus = mode == 'failure' &&
        countAttempt &&
        [401, 429].contains(statusCode ?? -1);

    if (mode == 'success') {
      nextRemainingAttempts = fallbackAttemptsPerWindow;
      nextHasFailureHistory = false;
      nextFallbackCooldownLevel = 0;
    } else {
      if (!countAttempt) {
        // Keep the current attempts count.
      } else if (hasServerMeta && retryMeta?.remainingAttempts != null) {
        nextRemainingAttempts =
            retryMeta!.remainingAttempts!.clamp(0, 1 << 31);
      } else if (fallbackTriggeredStatus) {
        final safeCurrentAttempts = _serverRemainingAttempts > 0
            ? _serverRemainingAttempts
            : fallbackAttemptsPerWindow;
        nextRemainingAttempts = (safeCurrentAttempts - 1).clamp(0, 1 << 31);
      }

      nextHasFailureHistory = hasServerMeta
          ? retryMeta?.remainingAttempts != null ||
              (retryMeta?.cooldownSeconds ?? 0) > 0 ||
              (retryMeta?.cooldownUntilMs ?? 0) > now
          : (fallbackTriggeredStatus || nextHasFailureHistory) && countAttempt;
    }

    final cooldownFromUntil = retryMeta?.cooldownUntilMs ?? 0;
    var cooldownFromSeconds =
        (retryMeta?.cooldownSeconds != null && retryMeta!.cooldownSeconds! > 0)
            ? now + retryMeta.cooldownSeconds! * 1000
            : 0;

    if (!hasServerMeta &&
        fallbackTriggeredStatus &&
        nextRemainingAttempts == 0) {
      final nextLevel = (nextFallbackCooldownLevel + 1).clamp(0, 3);
      nextFallbackCooldownLevel = nextLevel;
      final durationSeconds = nextLevel - 1 <
              fallbackCooldownSecondsByLevel.length
          ? fallbackCooldownSecondsByLevel[nextLevel - 1]
          : fallbackCooldownSecondsByLevel.last;
      cooldownFromSeconds = now + durationSeconds * 1000;
    }

    var nextCooldownUntilMs = cooldownFromUntil > cooldownFromSeconds
        ? cooldownFromUntil
        : cooldownFromSeconds;
    final normalizedCooldownUntilMs =
        nextCooldownUntilMs > now ? nextCooldownUntilMs : 0;

    if (normalizedCooldownUntilMs > now) {
      nextRemainingAttempts = 0;
      nextHasFailureHistory = true;
    }

    if (mode == 'success') {
      nextFallbackCooldownLevel = 0;
    }

    setState(() {
      _serverRemainingAttempts = nextRemainingAttempts;
      _hasFailureHistory = nextHasFailureHistory;
      _fallbackCooldownLevel = nextFallbackCooldownLevel;
    });
    _signInCooldown.startAt(normalizedCooldownUntilMs);

    _persistPasscodeRetryState(
      _email,
      PersistedPasscodeRetryState(
        remainingAttempts: nextRemainingAttempts,
        cooldownUntilMs: normalizedCooldownUntilMs,
        hasFailureHistory: nextHasFailureHistory,
        cooldownLevel: nextFallbackCooldownLevel,
      ),
    );
  }

  void _onSignInCooldownTick() {
    // When the cooldown expires, restore attempts (mirrors the web effect).
    if (_wasCooldownActive && !_signInCooldown.isActive) {
      setState(() {
        _serverRemainingAttempts = fallbackAttemptsPerWindow;
        _hasFailureHistory = true;
        _passcode = '';
        _passcodeError = '';
        _error = '';
      });
      _persistPasscodeRetryState(
        _email,
        PersistedPasscodeRetryState(
          remainingAttempts: fallbackAttemptsPerWindow,
          cooldownUntilMs: 0,
          hasFailureHistory: true,
          cooldownLevel: _fallbackCooldownLevel,
        ),
      );
    }
    _wasCooldownActive = _signInCooldown.isActive;
    _rebuild();
  }

  // -----------------------------------------------------------------------
  // Navigation helpers.
  // -----------------------------------------------------------------------

  void _closeDialog() {
    _auth.dispatchGoogleSsoAction(const GoogleSsoReset());
    _auth.setSessionMessage(null);
    Navigator.of(context).pop();
  }

  void _navigateHome() {
    final navigator = Navigator.of(context);
    navigator.pop(); // close the dialog
    navigator.pushNamedAndRemoveUntil(
      AppRoutes.client.protected.home,
      (route) => false,
    );
  }

  void _goToStep(AuthStep step) {
    setState(() => _step = step);
  }

  void _resetToInitial({bool clearEmail = false}) {
    setState(() {
      _step = AuthStep.initial;
      _passcode = '';
      _passcodeConfirmation = '';
      _passcodeError = '';
      _googlePasscodeSetupRequired = false;
      if (clearEmail) _emailController.clear();
    });
    _auth.dispatchGoogleSsoAction(const GoogleSsoReset());
  }

  void _handleBack() {
    switch (_step) {
      case AuthStep.signinPasscode:
        _resetToInitial();
      case AuthStep.signupPasscodeCreate:
        if (_resetPasswordToken.isNotEmpty) {
          setState(() {
            _step = AuthStep.forgotPassword;
            _passcode = '';
            _passcodeConfirmation = '';
            _passcodeError = '';
            _resetPasswordToken = '';
          });
          return;
        }
        _resetToInitial();
      case AuthStep.signupPasscodeConfirm:
        setState(() {
          _step = AuthStep.signupPasscodeCreate;
          _passcodeConfirmation = '';
          _passcodeError = '';
        });
      case AuthStep.signupInfo:
        if (!_googlePasscodeSetupRequired) {
          _fullNameController.clear();
          _usernameController.clear();
        }
        _goToStep(AuthStep.signupPasscodeConfirm);
      case AuthStep.verifyEmail:
        _goToStep(AuthStep.signupInfo);
      case AuthStep.forgotPassword:
        _goToStep(
          _googlePasscodeSetupRequired
              ? AuthStep.signupPasscodeCreate
              : AuthStep.signinPasscode,
        );
      case AuthStep.initial:
        break;
    }
  }

  // -----------------------------------------------------------------------
  // Step handlers (ported one-to-one from the web AuthDialog).
  // -----------------------------------------------------------------------

  Future<void> _handleEmailSubmit() async {
    setState(() {
      _emailError = '';
      _error = '';
      _message = '';
    });

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(_email)) {
      setState(() {
        _emailError =
            'Please enter a valid email address. (e.g. example@domain.com)';
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userExists = await userController.peekUser(
        _email,
        (message) => setState(() => _error = message),
      );
      if (!mounted) return;
      if (userExists == true) {
        _syncRetryStateFromStorage();
        _goToStep(AuthStep.signinPasscode);
      } else if (userExists == false) {
        _goToStep(AuthStep.signupPasscodeCreate);
      }
    } catch (err) {
      setState(() => _error = 'Failed to check user. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitGooglePasscode(String passcodeToSubmit) async {
    final challengeToken = _auth.googleSsoState.challengeToken;
    if (_googlePasscodeRequestInFlight ||
        _googleRetryCountdown.isActive ||
        challengeToken == null) {
      return;
    }

    _googlePasscodeRequestInFlight = true;
    setState(() => _isLoading = true);
    _auth.dispatchGoogleSsoAction(const SubmitPasscodeStart());
    var shouldResetGoogleFlow = false;

    try {
      final result = await authController.completeGoogleSignIn(
        passcodeToSubmit,
        challengeToken,
      );
      if (!mounted) return;

      if (result.success && result.token != null && result.user != null) {
        _auth.signin(result.token!, result.user!);
        _auth.dispatchGoogleSsoAction(
          const SubmitPasscodeSuccessAuthenticated(),
        );
        _auth.dispatchGoogleSsoAction(const ClearChallengeToken());
        _googlePasscodeSetupRequired = false;
        _navigateHome();
        return;
      }

      if (result.statusCode == 422) {
        setState(() {
          _passcodeError = result.errorMessage ?? 'Invalid passcode.';
        });
      } else if (result.statusCode == 429) {
        final waitSeconds =
            (result.retryAfterSeconds ?? 1).clamp(1, 1 << 31);
        _googleRetryCountdown.start(waitSeconds);
        setState(() {
          _passcodeError =
              'Too many attempts. Please wait $waitSeconds seconds and try again.';
        });
      } else if (result.statusCode == 401) {
        setState(() => _error = AppLocales.signInGoogleFailure);
        shouldResetGoogleFlow = true;
      } else {
        setState(() {
          _error =
              result.errorMessage ?? 'Failed to complete Google sign in.';
        });
        shouldResetGoogleFlow = true;
      }

      _auth.dispatchGoogleSsoAction(SubmitPasscodeFailed(
        errorMessage: result.errorMessage ?? 'Google sign in failed.',
        errorCode: result.statusCode,
        retryAfterSeconds: result.retryAfterSeconds,
      ));
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Failed to complete Google sign in.');
      }
      shouldResetGoogleFlow = true;
      _auth.dispatchGoogleSsoAction(const SubmitPasscodeFailed(
        errorMessage: 'Failed to complete Google sign in.',
      ));
    } finally {
      if (shouldResetGoogleFlow) {
        _auth.dispatchGoogleSsoAction(const ClearChallengeToken());
        _googlePasscodeSetupRequired = false;
      }
      _googlePasscodeRequestInFlight = false;
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignInPasscode() async {
    if (_isGooglePasscodeFlow) {
      setState(() {
        _passcodeError = '';
        _error = '';
        _message = '';
      });

      if (_passcode.length != 6) {
        setState(() => _passcodeError = 'Passcode must be 6 digits');
        return;
      }

      await _submitGooglePasscode(_passcode);
      return;
    }

    final persisted = _syncRetryStateFromStorage();
    if (persisted.cooldownUntilMs > DateTime.now().millisecondsSinceEpoch ||
        _signInRequestInFlight) {
      return;
    }

    final normalizedSigninKey = _email.trim();
    if (normalizedSigninKey.isEmpty) {
      setState(() {
        _step = AuthStep.initial;
        _passcode = '';
        _passcodeError = 'Please enter your email before signing in.';
      });
      return;
    }

    setState(() {
      _passcodeError = '';
      _error = '';
      _message = '';
    });

    if (_passcode.length != 6) {
      setState(() => _passcodeError = 'Passcode must be 6 digits');
      return;
    }

    _signInRequestInFlight = true;
    setState(() => _isLoading = true);

    try {
      final result = await authController.signInWithEmailOrUsername(
        normalizedSigninKey,
        _passcode,
        (message) => mounted
            ? setState(() => _passcodeError = message)
            : null,
        (message) => mounted ? setState(() => _message = message) : null,
        _auth.signin,
        _navigateHome,
      );
      if (!mounted) return;

      if (result.success) {
        _applyServerRetryMeta(
          result.retryMeta,
          mode: 'success',
          statusCode: result.statusCode,
          shouldCountAttempt: false,
        );
        return;
      }

      _applyServerRetryMeta(
        result.retryMeta,
        mode: 'failure',
        statusCode: result.statusCode,
        shouldCountAttempt: result.shouldCountAttempt,
      );

      if (result.statusCode == 429) {
        final waitSeconds = result.retryMeta?.cooldownSeconds ??
            (((result.retryMeta?.cooldownUntilMs ?? 0) -
                        DateTime.now().millisecondsSinceEpoch) /
                    1000)
                .ceil()
                .clamp(0, 1 << 31);
        setState(() {
          _passcodeError =
              'Too many incorrect passcode attempts. Please wait $waitSeconds seconds.';
        });
      }
    } catch (err) {
      if (mounted) {
        setState(
          () => _passcodeError = 'Incorrect passcode. Please try again.',
        );
      }
    } finally {
      _signInRequestInFlight = false;
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCreatePasscode() async {
    setState(() {
      _passcodeError = '';
      _error = '';
    });

    if (_passcode.length != 6) {
      setState(() => _passcodeError = 'Passcode must be 6 digits');
      return;
    }

    setState(() {
      _step = AuthStep.signupPasscodeConfirm;
      _passcodeConfirmation = '';
    });
  }

  Future<void> _handleConfirmPasscode() async {
    setState(() {
      _passcodeError = '';
      _error = '';
    });

    if (_passcodeConfirmation.length != 6) {
      setState(() => _passcodeError = 'Passcode must be 6 digits');
      return;
    }

    if (_passcode != _passcodeConfirmation) {
      setState(() => _passcodeError = 'Passcodes do not match');
      return;
    }

    if (_googlePasscodeSetupRequired) {
      await _submitGooglePasscode(_passcode);
      return;
    }

    if (_resetPasswordToken.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        await authController.resetPassword(
          _resetPasswordToken,
          _passcode,
          _passcodeConfirmation,
          (message) => mounted ? setState(() => _error = message) : null,
          (message) => mounted ? setState(() => _message = message) : null,
          () {
            if (!mounted) return;
            setState(() {
              _resetPasswordToken = '';
              _step = _email.trim().isNotEmpty
                  ? AuthStep.signinPasscode
                  : AuthStep.initial;
              _passcode = '';
              _passcodeConfirmation = '';
            });
          },
        );
      } catch (err) {
        if (mounted) {
          setState(
            () => _error = 'Failed to reset passcode. Please try again.',
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }

    setState(() => _step = AuthStep.signupInfo);
  }

  Future<void> _handleSignUpSubmit() async {
    setState(() => _error = '');

    final fullName = _fullNameController.text;
    final username = _usernameController.text;

    if (fullName.length < 2) {
      setState(() => _error = 'Please enter your full name');
      return;
    }

    if (username.length < 3) {
      setState(() => _error = 'Username must be at least 3 characters');
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      setState(() {
        _error = 'Username can only contain letters, numbers, and underscores';
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      await authController.signUpWithEmail(
        username,
        _email,
        _passcode,
        _passcodeConfirmation,
        (message) => mounted ? setState(() => _error = message) : null,
        () {
          if (mounted) _goToStep(AuthStep.verifyEmail);
        },
      );
    } catch (err) {
      if (mounted) {
        setState(() => _error = 'Signup failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSendCode() async {
    setState(() {
      _error = '';
      _message = '';
    });
    await authController.sendConfirmationEmail(
      _email,
      (message) => mounted ? setState(() => _error = message) : null,
      (message) => mounted ? setState(() => _message = message) : null,
      () => _resendCodeCountdown.start(30),
    );
  }

  Future<void> _handleVerifyEmail() async {
    setState(() {
      _otpError = '';
      _error = '';
      _message = '';
    });

    if (_otp.length != 6) {
      setState(() => _otpError = 'Please enter a valid 6-digit code');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await authController.confirmEmailWithCode(
        _email,
        _otp,
        (message) => mounted ? setState(() => _otpError = message) : null,
        (message) => mounted ? setState(() => _message = message) : null,
        (token, user) {
          _auth.signin(token, user);
          if (mounted) _navigateHome();
        },
      );
    } catch (err) {
      if (mounted) {
        setState(
          () => _otpError = 'Invalid verification code. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPasswordSubmit() async {
    setState(() {
      _error = '';
      _message = '';
    });

    setState(() => _isLoading = true);
    try {
      await authController.sendForgotPasswordMail(
        _email,
        (message) => mounted ? setState(() => _error = message) : null,
        (message) => mounted ? setState(() => _message = message) : null,
        () => _resendCodeCountdown.start(60),
      );
    } catch (err) {
      if (mounted) {
        setState(
          () => _error = 'Failed to send reset email. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_googleVerifyRequestInFlight) return;

    _googleVerifyRequestInFlight = true;
    setState(() {
      _isLoading = true;
      _error = '';
      _passcodeError = '';
      _googlePasscodeSetupRequired = false;
    });
    _auth.dispatchGoogleSsoAction(const VerifyGoogleStart());

    try {
      // Android needs the web/server client id to receive an idToken;
      // iOS reads its client id from Info.plist.
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId:
            !kIsWeb && Platform.isAndroid ? AppConfig.googleClientId : null,
      );
      final account = await googleSignIn.signIn();
      if (account == null) {
        // User cancelled the Google account picker.
        _auth.dispatchGoogleSsoAction(const GoogleSsoReset());
        return;
      }

      final authentication = await account.authentication;
      final googleToken =
          authentication.idToken ?? authentication.accessToken;
      if (googleToken == null) {
        throw Exception('Missing Google token');
      }

      final result = await authController.signInWithGoogle(googleToken);
      if (!mounted) return;

      if (result.success &&
          result.passcodeRequired == true &&
          result.challengeToken != null) {
        if (result.passcodeAction == null) {
          const missingActionError =
              'Passcode setup action is missing from Google sign in response.';
          setState(() => _error = missingActionError);
          _auth.dispatchGoogleSsoAction(const VerifyGoogleFailed(
            errorMessage: missingActionError,
          ));
          return;
        }

        _auth.dispatchGoogleSsoAction(VerifyGooglePasscodeRequired(
          challengeToken: result.challengeToken!,
        ));
        setState(() {
          _googlePasscodeSetupRequired = true;
          _passcode = '';
          _passcodeConfirmation = '';
          _step = AuthStep.signupPasscodeCreate;
        });
        return;
      }

      if (result.success && result.token != null && result.user != null) {
        _auth.signin(result.token!, result.user!);
        _auth.dispatchGoogleSsoAction(
          const VerifyGoogleSuccessAuthenticated(),
        );
        _navigateHome();
        return;
      }

      setState(() {
        _error = result.statusCode == 401
            ? AppLocales.signInGoogleFailure
            : (result.errorMessage ?? AppLocales.signInGoogleFailure);
      });
      _auth.dispatchGoogleSsoAction(VerifyGoogleFailed(
        errorMessage: result.errorMessage ?? AppLocales.signInGoogleFailure,
        errorCode: result.statusCode,
      ));
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocales.signInGoogleFailure);
      }
      _auth.dispatchGoogleSsoAction(const VerifyGoogleFailed(
        errorMessage: AppLocales.signInGoogleFailure,
      ));
    } finally {
      _googleVerifyRequestInFlight = false;
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // -----------------------------------------------------------------------
  // Auto-submit when 6 digits are entered (mirrors the web effects).
  // -----------------------------------------------------------------------

  void _onSignInPasscodeChanged(String value) {
    setState(() => _passcode = value);

    if (value.length != 6) {
      _autoSubmittedSignInPasscode = '';
      return;
    }

    final blockedByCooldown = _isGooglePasscodeFlow
        ? _googleRetryCountdown.isActive
        : _signInCooldown.isActive;
    if (_isLoading ||
        _signInRequestInFlight ||
        _googlePasscodeRequestInFlight ||
        blockedByCooldown ||
        _autoSubmittedSignInPasscode == value) {
      return;
    }

    _autoSubmittedSignInPasscode = value;
    _handleSignInPasscode();
  }

  void _onCreatePasscodeChanged(String value) {
    setState(() => _passcode = value);

    if (value.length != 6) {
      _autoSubmittedCreatePasscode = '';
      return;
    }
    if (_isLoading || _autoSubmittedCreatePasscode == value) return;

    _autoSubmittedCreatePasscode = value;
    _handleCreatePasscode();
  }

  void _onConfirmPasscodeChanged(String value) {
    setState(() => _passcodeConfirmation = value);

    if (value.length != 6) {
      _autoSubmittedConfirmPasscode = '';
      return;
    }

    final confirmKey =
        '$_passcode|$value|$_resetPasswordToken|$_googlePasscodeSetupRequired';
    if (_isLoading || _autoSubmittedConfirmPasscode == confirmKey) return;

    _autoSubmittedConfirmPasscode = confirmKey;
    _handleConfirmPasscode();
  }

  void _onVerifyEmailOtpChanged(String value) {
    setState(() => _otp = value);

    if (value.length != 6) {
      _autoSubmittedVerifyEmailOtp = '';
      return;
    }
    if (_isLoading || _autoSubmittedVerifyEmailOtp == value) return;

    _autoSubmittedVerifyEmailOtp = value;
    _handleVerifyEmail();
  }

  // -----------------------------------------------------------------------
  // Build.
  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Rebuild when the Google SSO flow state changes.
    context.watch<AuthContext>();

    final isGooglePasscodeFlow = _isGooglePasscodeFlow;
    final isGooglePasscodeSetupFlow =
        isGooglePasscodeFlow && _googlePasscodeSetupRequired;
    final isCooldownActive = _signInCooldown.isActive;
    final isGoogleRetryActive = _googleRetryCountdown.isActive;
    final cooldownSecondsLeft = _signInCooldown.secondsLeft;
    final shouldShowAttempts = !isGooglePasscodeFlow &&
        !isCooldownActive &&
        _hasFailureHistory &&
        _serverRemainingAttempts < fallbackAttemptsPerWindow;

    final attemptsLabel =
        'Attempts remaining before cooldown: $_serverRemainingAttempts/$fallbackAttemptsPerWindow';
    final cooldownHelperText = isGooglePasscodeFlow
        ? isGoogleRetryActive
            ? 'Too many attempts. Please wait ${_googleRetryCountdown.secondsLeft} seconds.'
            : isGooglePasscodeSetupFlow
                ? 'Create and confirm your 6-digit passcode'
                : 'Enter your 6-digit passcode to continue Google sign in'
        : isCooldownActive
            ? 'Too many incorrect passcode attempts. Please wait $cooldownSecondsLeft seconds.'
            : 'Enter your 6-digit passcode';

    return AppDialog(
      onClose: _closeDialog,
      onBack: _step != AuthStep.initial ? _handleBack : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Welcome to Meritbox',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.72,
              color: AppColors.gold600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Support dreams or make yours come true where every merit counts.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.navy900.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 20),
          switch (_step) {
            AuthStep.initial => InitialDialog(
                isLoading: _isLoading,
                emailController: _emailController,
                emailError: _emailError,
                error: _error,
                onSubmit: _handleEmailSubmit,
                onGoogleSignIn: _handleGoogleSignIn,
              ),
            AuthStep.signinPasscode => SigninPasscodeDialog(
                email: _email,
                mode: isGooglePasscodeFlow
                    ? SigninPasscodeMode.google
                    : SigninPasscodeMode.email,
                passcode: _passcode,
                passcodeError: _passcodeError,
                helperText: cooldownHelperText,
                isLoading: _isLoading,
                isCooldownActive: isGooglePasscodeFlow
                    ? isGoogleRetryActive
                    : isCooldownActive,
                cooldownSecondsLeft: isGooglePasscodeFlow
                    ? _googleRetryCountdown.secondsLeft
                    : cooldownSecondsLeft,
                shouldShowAttempts: shouldShowAttempts,
                attemptsLabel: attemptsLabel,
                error: _error,
                isSubmitDisabled: _isLoading ||
                    (isGooglePasscodeFlow
                        ? isGoogleRetryActive
                        : isCooldownActive) ||
                    _passcode.length != 6 ||
                    _signInRequestInFlight ||
                    _googlePasscodeRequestInFlight,
                onPasscodeChange: _onSignInPasscodeChanged,
                onSubmit: _handleSignInPasscode,
                onUseDifferentEmail: () => _resetToInitial(clearEmail: true),
                onForgotPassword: () => _goToStep(AuthStep.forgotPassword),
              ),
            AuthStep.signupPasscodeCreate => SignupPasscodeCreateDialog(
                email: _email,
                passcode: _passcode,
                passcodeError: _passcodeError,
                isLoading: _isLoading,
                error: _error,
                onPasscodeChange: _onCreatePasscodeChanged,
                onSubmit: _handleCreatePasscode,
                onUseDifferentEmail: () => _resetToInitial(clearEmail: true),
                onForgotPasscode: () => _goToStep(AuthStep.forgotPassword),
              ),
            AuthStep.signupPasscodeConfirm => SignupPasscodeConfirmDialog(
                email: _email,
                passcodeConfirmation: _passcodeConfirmation,
                passcodeError: _passcodeError,
                isLoading: _isLoading,
                error: _error,
                onPasscodeConfirmationChange: _onConfirmPasscodeChanged,
                onSubmit: _handleConfirmPasscode,
                onUseDifferentEmail: () => _resetToInitial(clearEmail: true),
                onForgotPasscode: () => _goToStep(AuthStep.forgotPassword),
              ),
            AuthStep.signupInfo => SignupInfoDialog(
                fullNameController: _fullNameController,
                usernameController: _usernameController,
                isLoading: _isLoading,
                error: _error,
                onUsernameChanged: (value) {
                  final normalized =
                      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
                  if (normalized != value) {
                    _usernameController.value = TextEditingValue(
                      text: normalized,
                      selection:
                          TextSelection.collapsed(offset: normalized.length),
                    );
                  }
                },
                onSubmit: _handleSignUpSubmit,
              ),
            AuthStep.verifyEmail => VerifyEmailDialog(
                email: _email,
                otp: _otp,
                otpError: _otpError,
                message: _message,
                error: _error,
                isLoading: _isLoading,
                resendCountdownActive: _resendCodeCountdown.isActive,
                resendCountdownSecondsLeft: _resendCodeCountdown.secondsLeft,
                onOtpChange: _onVerifyEmailOtpChanged,
                onSubmit: _handleVerifyEmail,
                onResendCode: _handleSendCode,
                onUseDifferentEmail: () {
                  setState(() {
                    _otp = '';
                    _fullNameController.clear();
                    _usernameController.clear();
                  });
                  _resetToInitial(clearEmail: true);
                },
              ),
            AuthStep.forgotPassword => ForgotPasswordDialog(
                emailController: _emailController,
                message: _message,
                error: _error,
                isLoading: _isLoading,
                resendCountdownActive: _resendCodeCountdown.isActive,
                resendCountdownSecondsLeft: _resendCodeCountdown.secondsLeft,
                onSubmit: _handleForgotPasswordSubmit,
                onBackToSignin: () => _goToStep(
                  _googlePasscodeSetupRequired
                      ? AuthStep.signupPasscodeCreate
                      : AuthStep.signinPasscode,
                ),
              ),
          },
        ],
      ),
    );
  }
}
