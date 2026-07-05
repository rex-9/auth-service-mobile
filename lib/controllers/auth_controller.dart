import '../models/models.dart';
import '../services/services.dart';

/// Mirrors web `src/controllers/auth.controller.ts`.

class PasscodeRetryMeta {
  const PasscodeRetryMeta({
    this.remainingAttempts,
    this.cooldownSeconds,
    this.cooldownUntilMs,
  });

  final int? remainingAttempts;
  final int? cooldownSeconds;
  final int? cooldownUntilMs;
}

class PasscodeSignInResult {
  const PasscodeSignInResult({
    required this.success,
    required this.shouldCountAttempt,
    this.statusCode,
    this.retryMeta,
    this.errorMessage,
  });

  final bool success;
  final bool shouldCountAttempt;
  final int? statusCode;
  final PasscodeRetryMeta? retryMeta;
  final String? errorMessage;
}

class GoogleSignInStartResult {
  const GoogleSignInStartResult({
    required this.success,
    this.statusCode,
    this.passcodeRequired,
    this.passcodeAction,
    this.challengeToken,
    this.user,
    this.token,
    this.errorMessage,
  });

  final bool success;
  final int? statusCode;
  final bool? passcodeRequired;
  final String? passcodeAction;
  final String? challengeToken;
  final User? user;
  final String? token;
  final String? errorMessage;
}

class GoogleSignInCompleteResult {
  const GoogleSignInCompleteResult({
    required this.success,
    this.statusCode,
    this.retryAfterSeconds,
    this.user,
    this.token,
    this.errorMessage,
  });

  final bool success;
  final int? statusCode;
  final int? retryAfterSeconds;
  final User? user;
  final String? token;
  final String? errorMessage;
}

class AuthController {
  AuthController._();

  static final AuthController instance = AuthController._();

  // ---------------------------------------------------------------------
  // Payload normalization helpers (ported one-to-one from the web client).
  // ---------------------------------------------------------------------

  String? _normalizeString(dynamic value) {
    if (value is! String) return null;
    final normalized = value.trim();
    return normalized.isNotEmpty ? normalized : null;
  }

  bool? _normalizeBoolean(dynamic value) {
    if (value is bool) return value;
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (['true', '1', 'yes', 'y'].contains(normalized)) return true;
      if (['false', '0', 'no', 'n'].contains(normalized)) return false;
    }
    return null;
  }

  num? _normalizeNumber(dynamic value) {
    if (value is num && value.isFinite) return value;
    if (value is String) {
      final parsed = num.tryParse(value);
      if (parsed != null && parsed.isFinite) return parsed;
    }
    return null;
  }

  int? _normalizeTimestampMs(dynamic value) {
    final asNumber = _normalizeNumber(value);
    if (asNumber != null) {
      if (asNumber > 1e12) return asNumber.round();
      if (asNumber > 1e9) return (asNumber * 1000).round();
    }
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed.millisecondsSinceEpoch;
    }
    return null;
  }

  /// Breadth-first search for the first matching key in a nested payload,
  /// mirroring `findFieldValue` on the web.
  dynamic _findFieldValue(
    dynamic source,
    List<String> keys, {
    int maxDepth = 4,
  }) {
    if (source is! Map) return null;

    final queue = <({dynamic node, int depth})>[(node: source, depth: 0)];
    final visited = <Object>{};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      final node = current.node;
      if (node is! Map) continue;
      if (!visited.add(node)) continue;

      for (final entry in node.entries) {
        if (keys.contains(entry.key)) return entry.value;
        if (current.depth < maxDepth && entry.value is Map) {
          queue.add((node: entry.value, depth: current.depth + 1));
        }
      }
    }
    return null;
  }

  Map<String, dynamic> _payloadOf(ApiResponse<ApiAuthResponse> response) {
    return {
      'status': {
        'code': response.data?.status?.code,
        'error': response.data?.status?.error,
        'message': response.data?.status?.message,
      },
      'data': response.data?.data,
    };
  }

  String? _extractGooglePasscodeAction(dynamic payload) {
    final rawAction =
        _findFieldValue(payload, ['passcode_action', 'passcodeAction']);
    final normalized = _normalizeString(rawAction)?.toLowerCase();
    return (normalized != null && normalized.isNotEmpty) ? normalized : null;
  }

  bool _extractGooglePasscodeRequired(dynamic payload) {
    final rawValue =
        _findFieldValue(payload, ['passcode_required', 'passcodeRequired']);

    final normalizedBoolean = _normalizeBoolean(rawValue);
    if (normalizedBoolean != null) return normalizedBoolean;

    final normalizedString = _normalizeString(rawValue)?.toLowerCase();
    if (normalizedString == null) return false;

    return ['required', 'setup', 'set', 'create', 'new']
        .contains(normalizedString);
  }

  int? _extractRetryAfterSeconds(dynamic payload) {
    final retryAfterRaw = _findFieldValue(payload, [
      'retry_after',
      'retryAfter',
      'retry_after_seconds',
      'retryAfterSeconds',
    ]);

    final normalized = _normalizeNumber(retryAfterRaw);
    if (normalized == null) return null;
    final ceiled = normalized.ceil();
    return ceiled < 0 ? 0 : ceiled;
  }

  PasscodeRetryMeta extractPasscodeRetryMeta(dynamic payload) {
    final remainingAttemptsRaw = _findFieldValue(payload, [
      'remaining_attempts',
      'attempts_remaining_before_cooldown',
      'attempts_remaining',
      'remainingAttempts',
      'attemptsLeft',
    ]);

    final cooldownSecondsRaw = _findFieldValue(payload, [
      'retry_after',
      'retry_after_seconds',
      'cooldown_seconds',
      'cooldown_remaining',
      'cooldownSeconds',
      'wait_seconds',
      'waitSeconds',
    ]);

    final cooldownUntilRaw = _findFieldValue(payload, [
      'cooldown_until',
      'cooldownUntil',
      'retry_at',
      'retryAt',
      'unlock_at',
      'unlockAt',
      'cooldown_expires_at',
      'cooldownExpiresAt',
    ]);

    final remainingAttempts = _normalizeNumber(remainingAttemptsRaw);
    final cooldownSecondsValue = _normalizeNumber(cooldownSecondsRaw);
    final int? normalizedCooldownSeconds = cooldownSecondsValue == null
        ? null
        : cooldownSecondsValue > 1000
            ? (cooldownSecondsValue / 1000).ceil()
            : cooldownSecondsValue.ceil();

    var cooldownUntilMs = _normalizeTimestampMs(cooldownUntilRaw);
    if ((cooldownUntilMs == null || cooldownUntilMs == 0) &&
        normalizedCooldownSeconds != null &&
        normalizedCooldownSeconds > 0) {
      cooldownUntilMs = DateTime.now().millisecondsSinceEpoch +
          normalizedCooldownSeconds * 1000;
    }

    return PasscodeRetryMeta(
      remainingAttempts: remainingAttempts?.floor().clamp(0, 1 << 31),
      cooldownSeconds: normalizedCooldownSeconds?.clamp(0, 1 << 31),
      cooldownUntilMs: cooldownUntilMs,
    );
  }

  ({int? statusCode, String errorMessage}) _parseAuthError(
    ApiResponse<ApiAuthResponse> response,
  ) {
    final status = response.data?.status;
    final errorMessage = status?.error ??
        response.error ??
        ((status?.message.isNotEmpty ?? false)
            ? status!.message
            : 'Authentication failed.');
    return (statusCode: status?.code, errorMessage: errorMessage);
  }

  User? _userFromData(Map<String, dynamic>? data) {
    final rawUser = data?['user'];
    if (rawUser is Map<String, dynamic>) return User.fromJson(rawUser);
    return null;
  }

  // ---------------------------------------------------------------------
  // Flow entry points.
  // ---------------------------------------------------------------------

  Future<void> signInWithToken(
    String token,
    void Function(String message) setError,
    void Function(String token, User user) signin,
  ) async {
    await apiHandler(
      'signing in with token',
      () => authService.signInWithToken(token),
      setError,
      (response) {
        final user = _userFromData(response.data);
        final authToken = response.data?['token'] as String?;
        if (user != null && authToken != null) signin(authToken, user);
      },
    );
  }

  Future<PasscodeSignInResult> signInWithEmailOrUsername(
    String signinKey,
    String passcode,
    void Function(String message) setError,
    void Function(String message) setMessage,
    void Function(String token, User user) signin,
    void Function() navigateHome,
  ) async {
    try {
      final response =
          await authService.signInWithEmailOrUsername(signinKey, passcode);
      final status = response.data?.status;
      final data = response.data?.data;
      final retryMeta = extractPasscodeRetryMeta(_payloadOf(response));
      final statusCode = status?.code;

      final user = _userFromData(data);
      final token = data?['token'] as String?;

      if (status?.success == true && token != null && user != null) {
        setMessage(status!.message);
        signin(token, user);
        navigateHome();
        return PasscodeSignInResult(
          success: true,
          shouldCountAttempt: false,
          statusCode: statusCode,
          retryMeta: PasscodeRetryMeta(
            remainingAttempts: retryMeta.remainingAttempts ?? 3,
            cooldownSeconds: 0,
            cooldownUntilMs: 0,
          ),
        );
      }

      final errorMessage = status?.error ??
          response.error ??
          ((status?.message.isNotEmpty ?? false)
              ? status!.message
              : 'Incorrect passcode. Please try again.');
      final normalizedError = errorMessage.toLowerCase();
      final shouldCountAttempt =
          [401, 403, 422, 429].contains(status?.code ?? -1) ||
              retryMeta.remainingAttempts != null ||
              (retryMeta.cooldownSeconds ?? 0) > 0 ||
              (retryMeta.cooldownUntilMs ?? 0) >
                  DateTime.now().millisecondsSinceEpoch ||
              RegExp(r'(passcode|password|credential|invalid|incorrect|wrong|unauthor)')
                  .hasMatch(normalizedError);

      setError(errorMessage);
      setMessage('');

      return PasscodeSignInResult(
        success: false,
        shouldCountAttempt: shouldCountAttempt,
        statusCode: statusCode,
        retryMeta: retryMeta,
        errorMessage: errorMessage,
      );
    } catch (_) {
      const errorMessage = 'Failed to sign in. Please try again.';
      setError(errorMessage);
      setMessage('');
      return const PasscodeSignInResult(
        success: false,
        shouldCountAttempt: false,
        errorMessage: errorMessage,
      );
    }
  }

  Future<GoogleSignInStartResult> signInWithGoogle(String token) async {
    final response = await authService.signInWithGoogle(token);
    final status = response.data?.status;
    final data = response.data?.data;

    if (status?.success == true) {
      final payload = _payloadOf(response);
      final passcodeRequired = _extractGooglePasscodeRequired(payload);
      final challengeToken = (data?['challenge_token'] as String?) ??
          (data?['flow_token'] as String?);
      final passcodeAction = _extractGooglePasscodeAction(payload);

      if (passcodeRequired) {
        if (challengeToken == null || passcodeAction == null) {
          return GoogleSignInStartResult(
            success: false,
            statusCode: status!.code,
            errorMessage:
                'Google verification requires passcode setup metadata.',
          );
        }

        return GoogleSignInStartResult(
          success: true,
          statusCode: status!.code,
          passcodeRequired: true,
          passcodeAction: passcodeAction,
          challengeToken: challengeToken,
        );
      }

      return GoogleSignInStartResult(
        success: true,
        statusCode: status!.code,
        passcodeRequired: false,
        user: _userFromData(data),
        token: data?['token'] as String?,
      );
    }

    final parsed = _parseAuthError(response);
    return GoogleSignInStartResult(
      success: false,
      statusCode: parsed.statusCode,
      errorMessage: parsed.errorMessage,
    );
  }

  Future<GoogleSignInCompleteResult> completeGoogleSignIn(
    String passcode,
    String challengeToken,
  ) async {
    final response =
        await authService.completeGoogleSignIn(passcode, challengeToken);
    final status = response.data?.status;
    final data = response.data?.data;

    final user = _userFromData(data);
    final token = data?['token'] as String?;

    if (status?.success == true && token != null && user != null) {
      return GoogleSignInCompleteResult(
        success: true,
        statusCode: status!.code,
        user: user,
        token: token,
      );
    }

    final parsed = _parseAuthError(response);
    final retryAfterSeconds = _extractRetryAfterSeconds(_payloadOf(response));

    return GoogleSignInCompleteResult(
      success: false,
      statusCode: parsed.statusCode,
      retryAfterSeconds: retryAfterSeconds,
      errorMessage: parsed.errorMessage,
    );
  }

  Future<void> signUpWithEmail(
    String username,
    String email,
    String password,
    String passwordConfirmation,
    void Function(String message) setError,
    void Function() navigateVerifyEmail,
  ) async {
    await apiHandler(
      'signing up with email',
      () => authService.signUpWithEmail(
        username,
        email,
        password,
        passwordConfirmation,
      ),
      setError,
      (_) => navigateVerifyEmail(),
    );
  }

  Future<void> sendConfirmationEmail(
    String emailOrUsername,
    void Function(String message) setError,
    void Function(String message) setMessage,
    void Function() startCountdown,
  ) async {
    await apiHandler(
      'sending confirmation email',
      () => authService.sendConfirmationEmail(emailOrUsername),
      setError,
      (response) {
        setMessage(response.status!.message);
        startCountdown();
      },
    );
  }

  Future<void> confirmEmailWithCode(
    String emailOrUsername,
    String confirmationCode,
    void Function(String message) setError,
    void Function(String message) setMessage,
    void Function(String token, User user) signin,
  ) async {
    await apiHandler(
      'confirming email with code',
      () => authService.confirmEmailWithCode(emailOrUsername, confirmationCode),
      setError,
      (response) {
        setMessage(response.status!.message);
        final user = _userFromData(response.data);
        final token = response.data?['token'] as String?;
        if (user != null && token != null) signin(token, user);
      },
      () => setMessage(''),
    );
  }

  Future<void> sendForgotPasswordMail(
    String email,
    void Function(String message) setError,
    void Function(String message) setMessage,
    void Function() startCountdown,
  ) async {
    await apiHandler(
      'sending forgot password email',
      () => authService.sendForgotPasswordMail(email),
      setError,
      (response) {
        setMessage(response.status!.message);
        startCountdown();
      },
    );
  }

  Future<void> resetPassword(
    String token,
    String password,
    String passwordConfirmation,
    void Function(String message) setError,
    void Function(String message) setMessage,
    void Function() navigateSignIn,
  ) async {
    await apiHandler(
      'resetting password',
      () => authService.resetPassword(token, password, passwordConfirmation),
      setError,
      (response) {
        setMessage(response.status!.message);
        navigateSignIn();
      },
    );
  }

  Future<void> signOut() async {
    try {
      final response = await authService.signOut();
      final status = response.data?.status;
      final statusError = status?.error;
      final isAlreadySignedOut = statusError == 'Unauthorized' ||
          statusError == 'Signature has expired' ||
          statusError == 'No verification key available';

      if (status?.success == true || isAlreadySignedOut) {
        // User signed out from server successfully.
      }
    } catch (_) {
      // Server sign out failed; local sign out still proceeds.
    }
  }
}

final authController = AuthController.instance;
