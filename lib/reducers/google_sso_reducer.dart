/// Mirrors web `src/reducers/googleSso.reducer.ts`.
enum GoogleSsoFlowStatus {
  idle,
  verifyingGoogle,
  passcodeRequired,
  submittingPasscode,
  authenticated,
  error,
}

class GoogleSsoState {
  const GoogleSsoState({
    this.status = GoogleSsoFlowStatus.idle,
    this.challengeToken,
    this.retryAfterSeconds,
    this.errorMessage,
    this.errorCode,
  });

  final GoogleSsoFlowStatus status;
  final String? challengeToken;
  final int? retryAfterSeconds;
  final String? errorMessage;
  final int? errorCode;
}

const initialGoogleSsoState = GoogleSsoState();

sealed class GoogleSsoAction {
  const GoogleSsoAction();
}

class GoogleSsoReset extends GoogleSsoAction {
  const GoogleSsoReset();
}

class VerifyGoogleStart extends GoogleSsoAction {
  const VerifyGoogleStart();
}

class VerifyGoogleSuccessAuthenticated extends GoogleSsoAction {
  const VerifyGoogleSuccessAuthenticated();
}

class VerifyGooglePasscodeRequired extends GoogleSsoAction {
  const VerifyGooglePasscodeRequired({required this.challengeToken});

  final String challengeToken;
}

class VerifyGoogleFailed extends GoogleSsoAction {
  const VerifyGoogleFailed({
    required this.errorMessage,
    this.errorCode,
    this.retryAfterSeconds,
  });

  final String errorMessage;
  final int? errorCode;
  final int? retryAfterSeconds;
}

class SubmitPasscodeStart extends GoogleSsoAction {
  const SubmitPasscodeStart();
}

class SubmitPasscodeSuccessAuthenticated extends GoogleSsoAction {
  const SubmitPasscodeSuccessAuthenticated();
}

class SubmitPasscodeFailed extends GoogleSsoAction {
  const SubmitPasscodeFailed({
    required this.errorMessage,
    this.errorCode,
    this.retryAfterSeconds,
  });

  final String errorMessage;
  final int? errorCode;
  final int? retryAfterSeconds;
}

class ClearChallengeToken extends GoogleSsoAction {
  const ClearChallengeToken();
}

GoogleSsoState googleSsoStateReducer(
  GoogleSsoState state,
  GoogleSsoAction action,
) {
  switch (action) {
    case GoogleSsoReset():
      return initialGoogleSsoState;

    case VerifyGoogleStart():
      return const GoogleSsoState(status: GoogleSsoFlowStatus.verifyingGoogle);

    case VerifyGoogleSuccessAuthenticated():
      return const GoogleSsoState(status: GoogleSsoFlowStatus.authenticated);

    case VerifyGooglePasscodeRequired(:final challengeToken):
      return GoogleSsoState(
        status: GoogleSsoFlowStatus.passcodeRequired,
        challengeToken: challengeToken,
      );

    case VerifyGoogleFailed(
        :final errorMessage,
        :final errorCode,
        :final retryAfterSeconds
      ):
      return GoogleSsoState(
        status: GoogleSsoFlowStatus.error,
        retryAfterSeconds: retryAfterSeconds,
        errorMessage: errorMessage,
        errorCode: errorCode,
      );

    case SubmitPasscodeStart():
      return GoogleSsoState(
        status: GoogleSsoFlowStatus.submittingPasscode,
        challengeToken: state.challengeToken,
      );

    case SubmitPasscodeSuccessAuthenticated():
      return const GoogleSsoState(status: GoogleSsoFlowStatus.authenticated);

    case SubmitPasscodeFailed(
        :final errorMessage,
        :final errorCode,
        :final retryAfterSeconds
      ):
      return GoogleSsoState(
        status: GoogleSsoFlowStatus.error,
        challengeToken: state.challengeToken,
        retryAfterSeconds: retryAfterSeconds,
        errorMessage: errorMessage,
        errorCode: errorCode,
      );

    case ClearChallengeToken():
      return GoogleSsoState(
        status: state.status,
        retryAfterSeconds: state.retryAfterSeconds,
        errorMessage: state.errorMessage,
        errorCode: state.errorCode,
      );
  }
}
