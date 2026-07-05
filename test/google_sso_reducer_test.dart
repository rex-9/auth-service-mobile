import 'package:flutter_test/flutter_test.dart';

import 'package:auth_service_mobile/reducers/google_sso_reducer.dart';

void main() {
  group('googleSsoStateReducer', () {
    test('starts idle', () {
      expect(initialGoogleSsoState.status, GoogleSsoFlowStatus.idle);
      expect(initialGoogleSsoState.challengeToken, isNull);
    });

    test('VERIFY_GOOGLE_START resets errors and token', () {
      final state = googleSsoStateReducer(
        const GoogleSsoState(
          status: GoogleSsoFlowStatus.error,
          errorMessage: 'boom',
        ),
        const VerifyGoogleStart(),
      );
      expect(state.status, GoogleSsoFlowStatus.verifyingGoogle);
      expect(state.errorMessage, isNull);
      expect(state.challengeToken, isNull);
    });

    test('VERIFY_GOOGLE_PASSCODE_REQUIRED stores the challenge token', () {
      final state = googleSsoStateReducer(
        initialGoogleSsoState,
        const VerifyGooglePasscodeRequired(challengeToken: 'challenge-123'),
      );
      expect(state.status, GoogleSsoFlowStatus.passcodeRequired);
      expect(state.challengeToken, 'challenge-123');
    });

    test('SUBMIT_PASSCODE_START keeps the challenge token', () {
      final state = googleSsoStateReducer(
        const GoogleSsoState(
          status: GoogleSsoFlowStatus.passcodeRequired,
          challengeToken: 'challenge-123',
        ),
        const SubmitPasscodeStart(),
      );
      expect(state.status, GoogleSsoFlowStatus.submittingPasscode);
      expect(state.challengeToken, 'challenge-123');
    });

    test('SUBMIT_PASSCODE_FAILED keeps token and records the error', () {
      final state = googleSsoStateReducer(
        const GoogleSsoState(
          status: GoogleSsoFlowStatus.submittingPasscode,
          challengeToken: 'challenge-123',
        ),
        const SubmitPasscodeFailed(
          errorMessage: 'Invalid passcode.',
          errorCode: 422,
          retryAfterSeconds: 5,
        ),
      );
      expect(state.status, GoogleSsoFlowStatus.error);
      expect(state.challengeToken, 'challenge-123');
      expect(state.errorCode, 422);
      expect(state.retryAfterSeconds, 5);
    });

    test('SUBMIT_PASSCODE_SUCCESS_AUTHENTICATED clears everything', () {
      final state = googleSsoStateReducer(
        const GoogleSsoState(
          status: GoogleSsoFlowStatus.submittingPasscode,
          challengeToken: 'challenge-123',
        ),
        const SubmitPasscodeSuccessAuthenticated(),
      );
      expect(state.status, GoogleSsoFlowStatus.authenticated);
      expect(state.challengeToken, isNull);
    });

    test('CLEAR_CHALLENGE_TOKEN only drops the token', () {
      final state = googleSsoStateReducer(
        const GoogleSsoState(
          status: GoogleSsoFlowStatus.error,
          challengeToken: 'challenge-123',
          errorMessage: 'boom',
          errorCode: 401,
        ),
        const ClearChallengeToken(),
      );
      expect(state.status, GoogleSsoFlowStatus.error);
      expect(state.challengeToken, isNull);
      expect(state.errorMessage, 'boom');
      expect(state.errorCode, 401);
    });

    test('RESET returns to the initial state', () {
      final state = googleSsoStateReducer(
        const GoogleSsoState(
          status: GoogleSsoFlowStatus.error,
          challengeToken: 'challenge-123',
        ),
        const GoogleSsoReset(),
      );
      expect(state.status, GoogleSsoFlowStatus.idle);
      expect(state.challengeToken, isNull);
    });
  });
}
