// lib/locales/app_translations.dart
import 'package:get/get.dart';
import 'app_locales.dart';

/// Mirrors the web client's locales (en / my in `src/locales/*.json`).
/// Use with `'key'.tr` or `'key'.trParams({'email': ...})`.
class AppTranslations extends Translations {
  static const supportedLocales = {'en_US': 'English', 'my_MM': 'မြန်မာ'};

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // Common
      AppLocales.common.home: 'Home',
      AppLocales.common.welcomeHome: 'Welcome to Rexone!',
      AppLocales.common.loading: 'Loading...',
      AppLocales.common.signOut: 'Sign Out',
      AppLocales.common.goBack: 'Go Back',
      AppLocales.common.submit: 'Submit',
      AppLocales.common.save: 'Save',
      AppLocales.common.cancel: 'Cancel',
      AppLocales.common.delete: 'Delete',
      AppLocales.common.confirm: 'Confirm',
      AppLocales.common.error: 'Error',
      AppLocales.common.success: 'Success',
      AppLocales.common.warning: 'Warning',
      AppLocales.common.info: 'Info',
      AppLocales.common.exit: 'Exit',
      AppLocales.common.exitTitle: 'Exit App',
      AppLocales.common.exitConfirm: 'Are you sure you want to exit the app?',

      // Auth Shared
      AppLocales.auth.shared.emailLabel: 'Email',
      AppLocales.auth.shared.emailHint: 'your@email.com',
      AppLocales.auth.shared.continueButton: 'Continue',
      AppLocales.auth.shared.useDifferentEmail: 'Use different email',
      AppLocales.auth.shared.passcodeLength: 'Passcode must be 6 digits',
      AppLocales.auth.shared.sessionExpired:
          'Your session has expired. Please sign in again.',
      AppLocales.auth.shared.sessionReplaced:
          'Your session was replaced by a newer sign in on this platform.',

      // Auth Initial
      AppLocales.auth.initial.title: '✨ Welcome to Rexone ✨',
      AppLocales.auth.initial.subtitle:
          'Support dreams or make yours come true',
      AppLocales.auth.initial.continueWithGoogle: 'Continue with Google',
      AppLocales.auth.initial.or: 'or',
      AppLocales.auth.initial.emailHelper:
          'Enter your email to sign in or create an account',
      AppLocales.auth.initial.invalidEmail:
          'Please enter a valid email address. (e.g. example@domain.com)',
      AppLocales.auth.initial.checking: 'Checking...',
      AppLocales.auth.initial.googleFailure: 'Google authentication failed!',
      AppLocales.auth.initial.googleTooManyAttempts:
          'Too many attempts. Please wait @seconds seconds and try again.',
      AppLocales.auth.initial.connectionFailed:
          'Connection failed. Please try again.',
      AppLocales.auth.initial.goBack: 'Go Back',

      // Auth SignIn Passcode
      AppLocales.auth.signInPasscode.title: 'Sign In',
      AppLocales.auth.signInPasscode.heading: 'Enter your passcode',
      AppLocales.auth.signInPasscode.subtitle:
          'Enter your 6-digit passcode for @email',
      AppLocales.auth.signInPasscode.passcodeLabel: 'Passcode',
      AppLocales.auth.signInPasscode.signingIn: 'Signing in...',
      AppLocales.auth.signInPasscode.forgotPasscodeLink:
          'Forgot your passcode?',
      AppLocales.auth.signInPasscode.passcode6Digits:
          'Please enter 6-digit passcode',
      AppLocales.auth.signInPasscode.attemptsRemaining:
          'Attempts remaining before cooldown: @left/@total',
      AppLocales.auth.signInPasscode.cooldownMessage:
          'Too many incorrect passcode attempts. Please wait @seconds seconds.',
      AppLocales.auth.signInPasscode.tryAgainIn: 'Try again in @seconds⁠s',
      AppLocales.auth.signInPasscode.signInFailed:
          'Sign in failed. Please try again.',

      // Auth SignUp Passcode Create
      AppLocales.auth.signUpPasscodeCreate.title: 'Create Account',
      AppLocales.auth.signUpPasscodeCreate.heading: 'Create a passcode',
      AppLocales.auth.signUpPasscodeCreate.subtitle:
          "You'll use this 6-digit passcode to sign in",
      AppLocales.auth.signUpPasscodeCreate.googleHeading: 'One last step',
      AppLocales.auth.signUpPasscodeCreate.googleSubtitle:
          'Create and confirm a passcode to finish Google sign up',
      AppLocales.auth.signUpPasscodeCreate.instruction:
          'This will be used to quickly sign in to your account.',

      // Auth SignUp Passcode Confirm
      AppLocales.auth.signUpPasscodeConfirm.title: 'Confirm Passcode',
      AppLocales.auth.signUpPasscodeConfirm.heading: 'Confirm Passcode',
      AppLocales.auth.signUpPasscodeConfirm.subtitle:
          'Please confirm your passcode.',
      AppLocales.auth.signUpPasscodeConfirm.confirm: 'Confirm',
      AppLocales.auth.signUpPasscodeConfirm.changePasscode: 'Change Passcode',
      AppLocales.auth.signUpPasscodeConfirm.passcodesMismatch:
          'Passcodes do not match',
      AppLocales.auth.signUpPasscodeConfirm.sendingCode: 'Sending code...',

      // Auth SignUp Info
      AppLocales.auth.signUpInfo.title: 'Complete Profile',
      AppLocales.auth.signUpInfo.heading: 'Tell us about yourself',
      AppLocales.auth.signUpInfo.fullNameLabel: 'Full Name',
      AppLocales.auth.signUpInfo.fullNameHint: 'John Doe',
      AppLocales.auth.signUpInfo.usernameLabel: 'Username',
      AppLocales.auth.signUpInfo.usernameHint: 'john_doe',
      AppLocales.auth.signUpInfo.createAccountButton: 'Create Account',
      AppLocales.auth.signUpInfo.creatingAccount: 'Creating account...',
      AppLocales.auth.signUpInfo.enterFullName: 'Please enter your full name',
      AppLocales.auth.signUpInfo.usernameMinLength:
          'Username must be at least 3 characters',
      AppLocales.auth.signUpInfo.usernameCharset:
          'Username can only contain letters, numbers, and underscores',
      AppLocales.auth.signUpInfo.registrationFailed: 'Registration failed',

      // Auth Confirm Email
      AppLocales.auth.confirmEmail.title: 'Verify Email',
      AppLocales.auth.confirmEmail.heading: 'Verify your email',
      AppLocales.auth.confirmEmail.subtitle: 'We sent a 6-digit code to @email',
      AppLocales.auth.confirmEmail.confirmCodeButton: 'Verify Code',
      AppLocales.auth.confirmEmail.verifying: 'Verifying...',
      AppLocales.auth.confirmEmail.resendCode: 'Resend Code',
      AppLocales.auth.confirmEmail.resendCodeIn: 'Resend code in @seconds⁠s',
      AppLocales.auth.confirmEmail.enter6DigitCode: 'Please enter 6-digit code',
      AppLocales.auth.confirmEmail.verificationFailed: 'Verification failed',
      AppLocales.auth.confirmEmail.sendCodeFailed:
          'Failed to send verification code',

      // Auth Forgot Passcode
      AppLocales.auth.forgotPasscode.title: 'Forgot Passcode',
      AppLocales.auth.forgotPasscode.subtitle:
          'Enter your email and we will send you a link to reset your passcode.',
      AppLocales.auth.forgotPasscode.sendResetLink: 'Send Passcode Reset Link',
      AppLocales.auth.forgotPasscode.sending: 'Sending...',
      AppLocales.auth.forgotPasscode.backToSignIn: 'Back to Sign In',
      AppLocales.auth.forgotPasscode.resetFailed:
          'Failed to send reset instructions',

      // Settings
      AppLocales.setting.settings: 'Settings',
      AppLocales.setting.theme: 'Theme',
      AppLocales.setting.language: 'Language',
      AppLocales.setting.account: 'Account',
      AppLocales.setting.logoutConfirmation:
          'Are you sure you want to sign out?',
      AppLocales.setting.appInfo: 'App Info',
      AppLocales.setting.confirmDelete: 'Delete',
      AppLocales.setting.confirmClear: 'Clear',
      AppLocales.setting.clearHistoryTitle: 'Clear History',
      AppLocales.setting.clearHistoryConfirmMsg:
          'All messages in this conversation will be permanently deleted.',
      AppLocales.setting.deleteRoomTitle: 'Delete Room',
      AppLocales.setting.deleteRoomConfirmMsg:
          'This room and all its messages will be permanently deleted.',
      AppLocales.setting.cancelSubTitle: 'Cancel Subscription',
      AppLocales.setting.cancelSubConfirmMsg:
          'Your subscription will remain active until the end of the billing period.',

      // AI
      AppLocales.ai.title: 'AI Assistant',
      AppLocales.ai.rooms: 'Chat Rooms',
      AppLocales.ai.newChat: 'New Conversation',
      AppLocales.ai.defaultGreeting:
          "Hello! I'm your AI assistant. How can I help you today?",
      AppLocales.ai.messagesCount: '@count messages',
      AppLocales.ai.listen: 'Listen',
      AppLocales.ai.thinking: 'AI is thinking',
      AppLocales.ai.cancelListening: 'Cancel listening',
      AppLocales.ai.typeMessage: 'Type your message...',
      AppLocales.ai.send: 'Send',
      AppLocales.ai.processing: 'AI is thinking...',
      AppLocales.ai.clearHistory: 'Clear History',
      AppLocales.ai.micPermissionTitle: 'Microphone access required',
      AppLocales.ai.micPermissionMessage:
          'Voice input needs microphone access. Open Settings to enable it for this app.',
      AppLocales.ai.openSettings: 'Open Settings',
      AppLocales.ai.aiSendMessageFailed: 'Failed to send message',
      AppLocales.ai.aiResponseFailed: 'Failed to get AI response',
      AppLocales.ai.aiHistoryCleared: 'Chat history cleared',
      AppLocales.ai.aiClearHistoryFailed: 'Failed to clear history',
      AppLocales.ai.aiStartRecordingFailed: 'Failed to start recording',
      AppLocales.ai.aiTranscriptionFailed: 'Failed to transcribe audio',
      AppLocales.ai.aiTtsFailed: 'Failed to play speech',
      AppLocales.ai.aiTtsEmpty: 'Nothing to speak',

      // Feedback
      AppLocales.feedback.title: 'Share Your Feedback',
      AppLocales.feedback.description:
          'We value your thoughts and ideas to help improve Rexone.',
      AppLocales.feedback.rateExperience: 'Rate your experience (1 - 10)',
      AppLocales.feedback.tellUsMore: "What's on your mind?",
      AppLocales.feedback.placeholder:
          'Tell us anything — bugs, suggestions, questions, or ideas. We triage automatically!',
      AppLocales.feedback.submit: 'Send Feedback',
      AppLocales.feedback.submitting: 'Submitting...',
      AppLocales.feedback.successMessage: 'Thank you for your feedback!',

      // Payment
      AppLocales.payment.title: 'Billing & Subscriptions',
      AppLocales.payment.subscriptions: 'Subscriptions',
      AppLocales.payment.transactions: 'Transactions',
      AppLocales.payment.upgradePlan: 'Upgrade Plan',
      AppLocales.payment.active: 'Active',
      AppLocales.payment.canceled: 'Canceled',
      AppLocales.payment.cancelSubscription: 'Cancel Subscription',
      AppLocales.payment.resumeSubscription: 'Resume Subscription',
      AppLocales.payment.subscribeNow: 'Subscribe Now',
      AppLocales.payment.successTitle: 'Payment Successful!',
      AppLocales.payment.successDesc:
          'Your payment has been processed and your features are active.',
      AppLocales.payment.cancelTitle: 'Payment Canceled',
      AppLocales.payment.cancelDesc:
          'Your payment was canceled. No charges were made.',

      // User
      AppLocales.user.profile: 'User Profile',
      AppLocales.user.changeAvatar: 'Change Avatar',
      AppLocales.user.avatarHint:
          'Upload a new profile picture (PNG, JPG, WebP supported)',
      AppLocales.user.selectImage: 'Choose Image',
      AppLocales.user.uploadAvatar: 'Upload Avatar',
      AppLocales.user.accountInfo: 'Account Information',
      AppLocales.user.roles: 'Roles',
      AppLocales.user.permissions: 'Permissions',
      AppLocales.ai.micPermissionTitle: 'Se requiere acceso al micrófono',
      AppLocales.ai.micPermissionMessage:
          'La entrada de voz necesita acceso al micrófono. Abre Ajustes para habilitarlo en esta app.',
      AppLocales.ai.openSettings: 'Abrir ajustes',
      AppLocales.ai.aiSendMessageFailed: 'No se pudo enviar el mensaje',
      AppLocales.ai.aiResponseFailed:
          'No se pudo obtener la respuesta de la IA',
      AppLocales.ai.aiHistoryCleared: 'Historial de chat borrado',
      AppLocales.ai.aiClearHistoryFailed: 'No se pudo borrar el historial',
      AppLocales.ai.aiStartRecordingFailed: 'No se pudo iniciar la grabación',
      AppLocales.ai.aiTranscriptionFailed: 'No se pudo transcribir el audio',
      AppLocales.ai.aiTtsFailed: 'No se pudo reproducir el audio',
      AppLocales.ai.aiTtsEmpty: 'Nada que reproducir',
    },
    'my_MM': {
      // Common
      AppLocales.common.home: 'မူလစာမျက်နှာ',
      AppLocales.common.welcomeHome: 'Rexone မှ ကြိုဆိုပါတယ်!',
      AppLocales.common.loading: 'ဖွင့်နေသည်...',
      AppLocales.common.signOut: 'ထွက်ရန်',
      AppLocales.common.goBack: 'ပြန်သွား',
      AppLocales.common.submit: 'တင်သွင်းရန်',
      AppLocales.common.save: 'သိမ်းဆည်းမည်',
      AppLocales.common.cancel: 'မလုပ်တော့ပါ',
      AppLocales.common.delete: 'ဖျက်မည်',
      AppLocales.common.confirm: 'အတည်ပြုပါ',
      AppLocales.common.error: 'အမှား',
      AppLocales.common.success: 'အောင်မြင်သည်',
      AppLocales.common.warning: 'သတိပေးချက်',
      AppLocales.common.info: 'သတင်းအချက်အလက်',
      AppLocales.common.exit: 'ထွက်ရန်',
      AppLocales.common.exitTitle: 'အက်ပ်မှ ထွက်ရန်',
      AppLocales.common.exitConfirm: 'ထွက်ရန် သေချာပါသလား?',

      // Auth Shared
      AppLocales.auth.shared.emailLabel: 'အီးမေးလ်',
      AppLocales.auth.shared.emailHint: 'your@email.com',
      AppLocales.auth.shared.continueButton: 'ဆက်လုပ်ရန်',
      AppLocales.auth.shared.useDifferentEmail: 'အခြားအီးမေးလ် သုံးရန်',
      AppLocales.auth.shared.passcodeLength:
          'ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ် ထည့်ပါ',
      AppLocales.auth.shared.sessionExpired:
          'သင့် Session သက်တမ်းကုန်သွားပါပြီ။ ကျေးဇူးပြု၍ ပြန်လည်ဝင်ရောက်ပါ။',
      AppLocales.auth.shared.sessionReplaced:
          'ဤစက်ပေါ်တွင် နောက်ဆုံးလော့ဂ်အင်ဝင်မှုကြောင့် သင့် session အသစ်ဖြင့် အစားထိုးခံရပါသည်။',

      // Auth Initial
      AppLocales.auth.initial.title: '✨ Rexone မှ ကြိုဆိုပါတယ် ✨',
      AppLocales.auth.initial.subtitle:
          'အိပ်မက်များကို ပံ့ပိုးပါ သို့မဟုတ် သင့်အိပ်မက်ကို အကောင်အထည်ဖော်ပါ',
      AppLocales.auth.initial.continueWithGoogle:
          'Google ဖြင့် ဆက်လက်လုပ်ဆောင်ရန်',
      AppLocales.auth.initial.or: 'သို့မဟုတ်',
      AppLocales.auth.initial.emailHelper:
          'လော့ဂ်အင်ဝင်ရန် သို့မဟုတ် အကောင့်ဖွင့်ရန် အီးမေးလ်ထည့်ပါ',
      AppLocales.auth.initial.invalidEmail:
          'မှန်ကန်သော အီးမေးလ်လိပ်စာ ထည့်ပါ။ (ဥပမာ example@domain.com)',
      AppLocales.auth.initial.checking: 'စစ်ဆေးနေသည်...',
      AppLocales.auth.initial.googleFailure: 'Google အတည်ပြုမှု မအောင်မြင်ပါ!',
      AppLocales.auth.initial.googleTooManyAttempts:
          'ကြိုးစားမှုများလွန်းပါသည်။ @seconds စက္ကန့် စောင့်ပြီး ထပ်စမ်းပါ။',
      AppLocales.auth.initial.connectionFailed:
          'ချိတ်ဆက်မှု မအောင်မြင်ပါ။ ထပ်စမ်းကြည့်ပါ။',
      AppLocales.auth.initial.goBack: 'ပြန်သွား',

      // Auth SignIn Passcode
      AppLocales.auth.signInPasscode.title: 'လော့ဂ်အင်',
      AppLocales.auth.signInPasscode.heading: 'သင့်လျှို့ဝှက်ကုဒ်ကို ထည့်ပါ',
      AppLocales.auth.signInPasscode.subtitle:
          '@email အတွက် ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ထည့်ပါ',
      AppLocales.auth.signInPasscode.passcodeLabel: 'လျှို့ဝှက်ကုဒ်',
      AppLocales.auth.signInPasscode.signingIn: 'လော့ဂ်အင်ဝင်နေသည်...',
      AppLocales.auth.signInPasscode.forgotPasscodeLink:
          'လျှို့ဝှက်ကုဒ် မေ့သွားပြီလား?',
      AppLocales.auth.signInPasscode.passcode6Digits:
          'ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ် ထည့်ပါ',
      AppLocales.auth.signInPasscode.attemptsRemaining:
          'ခဏရပ်နားချိန်မတိုင်မီ ကျန်ကြိုးစားခွင့်: @left/@total',
      AppLocales.auth.signInPasscode.cooldownMessage:
          'လျှို့ဝှက်ကုဒ် အမှားများလွန်းပါသည်။ @seconds စက္ကန့် စောင့်ပါ။',
      AppLocales.auth.signInPasscode.tryAgainIn: '@seconds⁠s အတွင်း ပြန်စမ်းပါ',
      AppLocales.auth.signInPasscode.signInFailed:
          'လော့ဂ်အင် မအောင်မြင်ပါ။ ထပ်စမ်းကြည့်ပါ။',

      // Auth SignUp Passcode Create
      AppLocales.auth.signUpPasscodeCreate.title: 'အကောင့်ဖွင့်ရန်',
      AppLocales.auth.signUpPasscodeCreate.heading: 'လျှို့ဝှက်ကုဒ် သတ်မှတ်ပါ',
      AppLocales.auth.signUpPasscodeCreate.subtitle:
          'လော့ဂ်အင်ဝင်ရန် ဤဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ကို သုံးပါမည်',
      AppLocales.auth.signUpPasscodeCreate.googleHeading: 'နောက်ဆုံးအဆင့်',
      AppLocales.auth.signUpPasscodeCreate.googleSubtitle:
          'Google အကောင့်ဖွင့်ခြင်း ပြီးမြောက်ရန် လျှို့ဝှက်ကုဒ် သတ်မှတ်ပြီး အတည်ပြုပါ',
      AppLocales.auth.signUpPasscodeCreate.instruction:
          'အကောင့်သို့ အမြန်လော့ဂ်အင်ဝင်ရန် ဤကုဒ်ကို သုံးပါမည်။',

      // Auth SignUp Passcode Confirm
      AppLocales.auth.signUpPasscodeConfirm.title: 'လျှို့ဝှက်ကုဒ် အတည်ပြုရန်',
      AppLocales.auth.signUpPasscodeConfirm.heading:
          'လျှို့ဝှက်ကုဒ် အတည်ပြုရန်',
      AppLocales.auth.signUpPasscodeConfirm.subtitle:
          'ကျေးဇူးပြု၍ သင့်ကုဒ်ကို အတည်ပြုပါ။',
      AppLocales.auth.signUpPasscodeConfirm.confirm: 'အတည်ပြုပါ',
      AppLocales.auth.signUpPasscodeConfirm.changePasscode: 'ကုဒ်ပြောင်းမည်',
      AppLocales.auth.signUpPasscodeConfirm.passcodesMismatch:
          'လျှို့ဝှက်ကုဒ်များ မကိုက်ညီပါ',
      AppLocales.auth.signUpPasscodeConfirm.sendingCode: 'ကုဒ် ပို့နေသည်...',

      // Auth SignUp Info
      AppLocales.auth.signUpInfo.title: 'ပရိုဖိုင် ဖြည့်ရန်',
      AppLocales.auth.signUpInfo.heading: 'သင့်အကြောင်း ပြောပြပါ',
      AppLocales.auth.signUpInfo.fullNameLabel: 'အမည်အပြည့်အစုံ',
      AppLocales.auth.signUpInfo.fullNameHint: 'မောင်မောင်',
      AppLocales.auth.signUpInfo.usernameLabel: 'အသုံးပြုသူအမည်',
      AppLocales.auth.signUpInfo.usernameHint: 'maung_maung',
      AppLocales.auth.signUpInfo.createAccountButton: 'အကောင့်ဖွင့်ရန်',
      AppLocales.auth.signUpInfo.creatingAccount: 'အကောင့်ဖွင့်နေသည်...',
      AppLocales.auth.signUpInfo.enterFullName: 'အမည်အပြည့်အစုံ ထည့်ပါ',
      AppLocales.auth.signUpInfo.usernameMinLength:
          'အသုံးပြုသူအမည်သည် အနည်းဆုံး စာလုံး ၃ လုံး ရှိရမည်',
      AppLocales.auth.signUpInfo.usernameCharset:
          'အသုံးပြုသူအမည်တွင် စာလုံး၊ ဂဏန်းနှင့် underscore များသာ ပါဝင်နိုင်သည်',
      AppLocales.auth.signUpInfo.registrationFailed:
          'အကောင့်ဖွင့်ခြင်း မအောင်မြင်ပါ',

      // Auth Confirm Email
      AppLocales.auth.confirmEmail.title: 'အီးမေးလ် အတည်ပြုရန်',
      AppLocales.auth.confirmEmail.heading: 'သင့်အီးမေးလ်ကို အတည်ပြုပါ',
      AppLocales.auth.confirmEmail.subtitle:
          '@email သို့ ဂဏန်း ၆ လုံး ကုဒ် ပို့ထားပါသည်',
      AppLocales.auth.confirmEmail.confirmCodeButton: 'ကုဒ် အတည်ပြုရန်',
      AppLocales.auth.confirmEmail.verifying: 'အတည်ပြုနေသည်...',
      AppLocales.auth.confirmEmail.resendCode: 'ကုဒ် ပြန်ပို့ရန်',
      AppLocales.auth.confirmEmail.resendCodeIn:
          '@seconds⁠s အတွင်း ကုဒ်ပြန်ပို့နိုင်သည်',
      AppLocales.auth.confirmEmail.enter6DigitCode: 'ဂဏန်း ၆ လုံး ကုဒ် ထည့်ပါ',
      AppLocales.auth.confirmEmail.verificationFailed:
          'အတည်ပြုမှု မအောင်မြင်ပါ',
      AppLocales.auth.confirmEmail.sendCodeFailed: 'အတည်ပြုကုဒ် ပို့၍မရပါ',

      // Auth Forgot Passcode
      AppLocales.auth.forgotPasscode.title: 'လျှို့ဝှက်ကုဒ် မေ့နေပါသလား',
      AppLocales.auth.forgotPasscode.subtitle:
          'အီးမေးလ်ထည့်ပါ။ လျှို့ဝှက်ကုဒ် ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ပေးပါမည်။',
      AppLocales.auth.forgotPasscode.sendResetLink:
          'ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ရန်',
      AppLocales.auth.forgotPasscode.sending: 'ပို့နေသည်...',
      AppLocales.auth.forgotPasscode.backToSignIn: 'လော့ဂ်အင်သို့ ပြန်သွားရန်',
      AppLocales.auth.forgotPasscode.resetFailed:
          'ပြန်သတ်မှတ်ရန် ညွှန်ကြားချက် ပို့၍မရပါ',

      // Settings
      AppLocales.setting.settings: 'ဆက်တင်များ',
      AppLocales.setting.theme: 'အပြင်အဆင်',
      AppLocales.setting.language: 'ဘာသာစကား',
      AppLocales.setting.account: 'အကောင့်',
      AppLocales.setting.logoutConfirmation: 'ထွက်ရန် သေချာပါသလား?',
      AppLocales.setting.appInfo: 'အက်ပ်အချက်အလက်',
      AppLocales.setting.confirmDelete: 'ဖျက်မည်',
      AppLocales.setting.confirmClear: 'ရှင်းလင်းမည်',
      AppLocales.setting.clearHistoryTitle: 'မှတ်တမ်းရှင်းလင်းရန်',
      AppLocales.setting.clearHistoryConfirmMsg:
          'ဤစကားဝိုင်းရှိ မက်ဆေ့ဂျ်များ အားလုံး အပြီးအပိုင် ဖျက်မည်။',
      AppLocales.setting.deleteRoomTitle: 'အခန်းဖျက်ရန်',
      AppLocales.setting.deleteRoomConfirmMsg:
          'ဤအခန်းနှင့် မက်ဆေ့ဂျ်များ အားလုံး အပြီးအပိုင် ဖျက်မည်။',
      AppLocales.setting.cancelSubTitle: 'စာရင်းသွင်းမှု ပယ်ဖျက်ရန်',
      AppLocales.setting.cancelSubConfirmMsg:
          'ငွေပေးချေမှု ကာလကုန်သည်အထိ သင့်စာရင်းသွင်းမှု ဆက်လက် အသုံးပြုနိုင်မည်။',

      // AI
      AppLocales.ai.title: 'AI လက်ထောက်',
      AppLocales.ai.rooms: 'စကားပြောခန်းများ',
      AppLocales.ai.newChat: 'စကားဝိုင်းအသစ်',
      AppLocales.ai.defaultGreeting:
          'မင်္ဂလာပါ! ကျွန်တော်သည် သင်၏ AI လက်ထောက် ဖြစ်ပါသည်။ ဘာများ ကူညီပေးရမလဲ?',
      AppLocales.ai.messagesCount: 'မက်ဆေ့ဂျ် @count စောင်',
      AppLocales.ai.listen: 'နားထောင်မည်',
      AppLocales.ai.thinking: 'AI စဉ်းစားနေသည်',
      AppLocales.ai.cancelListening: 'နားထောင်ခြင်း ရပ်တန့်မည်',
      AppLocales.ai.typeMessage: 'မက်ဆေ့ဂျ် ရေးပါ...',
      AppLocales.ai.send: 'ပို့မည်',
      AppLocales.ai.processing: 'AI စဉ်းစားနေသည်...',
      AppLocales.ai.clearHistory: 'မှတ်တမ်းရှင်းရန်',
      AppLocales.ai.micPermissionTitle: 'မိုက်ခရိုဖုန်း ခွင့်ပြုချက် လိုအပ်သည်',
      AppLocales.ai.micPermissionMessage:
          'အသံဖြင့် ရိုက်ထည့်ရန် မိုက်ခရိုဖုန်း ခွင့်ပြုချက် လိုအပ်ပါသည်။ Settings မှ ဖွင့်ပေးပါ။',
      AppLocales.ai.openSettings: 'Settings ဖွင့်ရန်',
      AppLocales.ai.aiSendMessageFailed: 'မက်ဆေ့ဂျ် ပို့၍ မရပါ',
      AppLocales.ai.aiResponseFailed: 'AI အဖြေကို ရယူ၍ မရပါ',
      AppLocales.ai.aiHistoryCleared: 'စကားဝိုင်းမှတ်တမ်း ရှင်းလင်းပြီးပါပြီ',
      AppLocales.ai.aiClearHistoryFailed: 'မှတ်တမ်း ရှင်းလင်း၍ မရပါ',
      AppLocales.ai.aiStartRecordingFailed: 'အသံဖမ်းခြင်း စတင်၍ မရပါ',
      AppLocales.ai.aiTranscriptionFailed: 'အသံကို စာသားမပြောင်း၍ ရပါ',
      AppLocales.ai.aiTtsFailed: 'အသံဖွင့်၍ မရပါ',
      AppLocales.ai.aiTtsEmpty: 'ဖွင့်ရန် စာသားမရှိပါ',

      // Feedback
      AppLocales.feedback.title: 'အကြံပြုချက် ပေးပို့ရန်',
      AppLocales.feedback.description:
          'Rexone ပိုမိုကောင်းမွန်စေရန် သင့်အကြံပြုချက်များကို တန်ဖိုးထားပါသည်။',
      AppLocales.feedback.rateExperience:
          'သင့်အတွေ့အကြုံကို အဆင့်သတ်မှတ်ပါ (၁ - ၁၀)',
      AppLocales.feedback.tellUsMore: 'သင့်စိတ်ထဲမှာ ဘာရှိပါသလဲ?',
      AppLocales.feedback.placeholder:
          'ချို့ယွင်းချက်၊ အကြံပြုချက်၊ မေးခွန်း သို့မဟုတ် အကြံဥာဏ်များကို ရေးသားနိုင်ပါသည်။',
      AppLocales.feedback.submit: 'အကြံပြုချက် ပို့မည်',
      AppLocales.feedback.submitting: 'ပို့နေသည်...',
      AppLocales.feedback.successMessage:
          'သင့်အကြံပြုချက်အတွက် ကျေးဇူးတင်ပါသည်!',

      // Payment
      AppLocales.payment.title: 'ငွေပေးချေမှုနှင့် စာရင်းသွင်းမှုများ',
      AppLocales.payment.subscriptions: 'စာရင်းသွင်းမှုများ',
      AppLocales.payment.transactions: 'ငွေပေးငွေယူ မှတ်တမ်း',
      AppLocales.payment.upgradePlan: 'အစီအစဉ် အဆင့်မြှင့်ရန်',
      AppLocales.payment.active: 'အသုံးပြုနေသည်',
      AppLocales.payment.canceled: 'ပယ်ဖျက်ပြီး',
      AppLocales.payment.cancelSubscription: 'စာရင်းသွင်းမှု ပယ်ဖျက်ရန်',
      AppLocales.payment.resumeSubscription: 'စာရင်းသွင်းမှု ပြန်လည်စတင်ရန်',
      AppLocales.payment.subscribeNow: 'ယခု စာရင်းသွင်းမည်',
      AppLocales.payment.successTitle: 'ငွေပေးချေမှု အောင်မြင်ပါသည်!',
      AppLocales.payment.successDesc:
          'သင့်ငွေပေးချေမှု ပြီးမြောက်ပြီး ဝန်ဆောင်မှုများ စတင်အသုံးပြုနိုင်ပါပြီ။',
      AppLocales.payment.cancelTitle: 'ငွေပေးချေမှု ပယ်ဖျက်ထားသည်',
      AppLocales.payment.cancelDesc:
          'သင့်ငွေပေးချေမှုကို ပယ်ဖျက်လိုက်ပါသည်။ မည်သည့်ငွေမှ ကောက်ခံထားခြင်းမရှိပါ။',

      // User
      AppLocales.user.profile: 'အသုံးပြုသူ ပရိုဖိုင်',
      AppLocales.user.changeAvatar: 'ပရိုဖိုင်ပုံ ပြောင်းရန်',
      AppLocales.user.avatarHint: 'ပရိုဖိုင်ပုံ အသစ်တင်ပါ (PNG, JPG, WebP)',
      AppLocales.user.selectImage: 'ပုံရွေးချယ်ပါ',
      AppLocales.user.uploadAvatar: 'ပရိုဖိုင်ပုံ တင်မည်',
      AppLocales.user.accountInfo: 'အကောင့် အချက်အလက်',
      AppLocales.user.roles: 'အခန်းကဏ္ဍများ',
      AppLocales.user.permissions: 'ခွင့်ပြုချက်များ',
    },
  };
}
