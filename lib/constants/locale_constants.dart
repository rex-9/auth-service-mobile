// lib/constants/locale_constants.dart
class LocaleConstants {
  const LocaleConstants();

  // Auth (Initial)
  String get welcomeTitle => 'welcome_title';
  String get welcomeSubtitle => 'welcome_subtitle';
  String get continueWithGoogle => 'continue_with_google';
  String get or => 'or';
  String get emailLabel => 'email_label';
  String get emailHint => 'email_hint';
  String get emailHelper => 'email_helper';
  String get continueButton => 'continue_button';
  String get checking => 'checking';

  // Sign In
  String get signinTitle => 'signin_title';
  String get signinHeading => 'signin_heading';
  String get signinSubtitle => 'signin_subtitle';
  String get passcodeLabel => 'passcode_label';
  String get signingIn => 'signing_in';
  String get useDifferentEmail => 'use_different_email';
  String get forgotPasscodeLink => 'forgot_passcode_link';
  String get attemptsRemaining => 'attempts_remaining';
  String get cooldownMessage => 'cooldown_message';
  String get tryAgainIn => 'try_again_in';

  // Sign Up
  String get signupTitle => 'signup_title';
  String get createPasscodeHeading => 'create_passcode_heading';
  String get createPasscodeSubtitle => 'create_passcode_subtitle';
  String get googlePasscodeHeading => 'google_passcode_heading';
  String get googlePasscodeSubtitle => 'google_passcode_subtitle';
  String get confirmPasscodeLabel => 'confirm_passcode_label';
  String get sendingCode => 'sending_code';

  // Sign Up Info
  String get signupInfoTitle => 'signup_info_title';
  String get signupInfoHeading => 'signup_info_heading';
  String get fullNameLabel => 'full_name_label';
  String get fullNameHint => 'full_name_hint';
  String get usernameLabel => 'username_label';
  String get usernameHint => 'username_hint';
  String get createAccountButton => 'create_account_button';
  String get creatingAccount => 'creating_account';

  // Verify Email
  String get verifyEmailTitle => 'verify_email_title';
  String get verifyEmailHeading => 'verify_email_heading';
  String get verifyEmailSubtitle => 'verify_email_subtitle';
  String get verifyCodeButton => 'verify_code_button';
  String get verifying => 'verifying';
  String get resendCode => 'resend_code';
  String get resendCodeIn => 'resend_code_in';

  // Forgot Passcode
  String get forgotPasscodeTitle => 'forgot_passcode_title';
  String get forgotPasscodeSubtitle => 'forgot_passcode_subtitle';
  String get sendResetLink => 'send_reset_link';
  String get sending => 'sending';
  String get backToSignIn => 'back_to_sign_in';

  // Home
  String get home => 'home';
  String get welcomeHome => 'welcome_home';
  String get loading => 'loading';
  String get signOutButton => 'sign_out_button';

  // Google / Session
  String get signInGoogleFailure => 'sign_in_google_failure';
  String get googleTooManyAttempts => 'google_too_many_attempts';
  String get sessionReplaced => 'session_replaced';

  // Generic
  String get error => 'error';
  String get success => 'success';
  String get warning => 'warning';
  String get info => 'info';
  String get signInFailed => 'sign_in_failed';
  String get verificationFailed => 'verification_failed';
  String get registrationFailed => 'registration_failed';
  String get sendCodeFailed => 'send_code_failed';
  String get resetFailed => 'reset_failed';
  String get connectionFailed => 'connection_failed';

  // Validation
  String get invalidEmail => 'invalid_email';
  String get passcode6Digits => 'passcode_6_digits';
  String get passcodesDoNotMatch => 'passcodes_do_not_match';
  String get enter6DigitCode => 'enter_6_digit_code';
  String get enterFullName => 'enter_full_name';
  String get usernameMinLength => 'username_min_length';
  String get usernameCharset => 'username_charset';
}
