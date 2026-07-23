// lib/locales/app_translations.dart
import 'package:get/get.dart';
import 'package:auth_service_mobile/constants/constants.dart';

/// Mirrors the web client's locales (en / es / my in `src/locales/*.json`).
/// Use with `'key'.tr` or `'key'.trParams({'email': ...})`.
class AppTranslations extends Translations {
  static const supportedLocales = {
    'en_US': 'English',
    'es_ES': 'Español',
    'my_MM': 'မြန်မာ',
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // Auth (initial)
      Constants.locale.welcomeTitle: '✨ Welcome to Auth Service ✨',
      Constants.locale.welcomeSubtitle:
          'Support dreams or make yours come true',
      Constants.locale.continueWithGoogle: 'Continue with Google',
      Constants.locale.or: 'or',
      Constants.locale.emailLabel: 'Email',
      Constants.locale.emailHint: 'your@email.com',
      Constants.locale.emailHelper:
          'Enter your email to sign in or create an account',
      Constants.locale.continueButton: 'Continue',
      Constants.locale.checking: 'Checking...',
      Constants.locale.invalidEmail:
          'Please enter a valid email address. (e.g. example@domain.com)',
      Constants.locale.connectionFailed: 'Connection failed. Please try again.',
      Constants.locale.goBack: 'Go Back',

      // Sign in passcode
      Constants.locale.signinTitle: 'Sign In',
      Constants.locale.signinHeading: 'Enter your passcode',
      Constants.locale.signinSubtitle: 'Enter your 6-digit passcode for @email',
      Constants.locale.passcodeLabel: 'Passcode',
      Constants.locale.signingIn: 'Signing in...',
      Constants.locale.useDifferentEmail: 'Use different email',
      Constants.locale.forgotPasscodeLink: 'Forgot your passcode?',
      Constants.locale.passcode6Digits: 'Please enter 6-digit passcode',
      Constants.locale.attemptsRemaining:
          'Attempts remaining before cooldown: @left/@total',
      Constants.locale.cooldownMessage:
          'Too many incorrect passcode attempts. Please wait @seconds seconds.',
      Constants.locale.tryAgainIn: 'Try again in @seconds⁠s',

      // Sign up passcode
      Constants.locale.signupTitle: 'Create Account',
      Constants.locale.createPasscodeHeading: 'Create a passcode',
      Constants.locale.createPasscodeSubtitle:
          "You'll use this 6-digit passcode to sign in",
      Constants.locale.googlePasscodeHeading: 'One last step',
      Constants.locale.googlePasscodeSubtitle:
          'Create and confirm a passcode to finish Google sign up',
      Constants.locale.confirmPasscodeHeading: 'Confirm Passcode',
      Constants.locale.confirmPasscodeSubtitle: 'Please confirm your passcode.',
      Constants.locale.confirm: 'Confirm',
      Constants.locale.changePasscode: 'Change Passcode',
      Constants.locale.passcodesDoNotMatch: 'Passcodes do not match',
      Constants.locale.sendingCode: 'Sending code...',

      // Sign up info
      Constants.locale.signupInfoTitle: 'Complete Profile',
      Constants.locale.signupInfoHeading: 'Tell us about yourself',
      Constants.locale.fullNameLabel: 'Full Name',
      Constants.locale.fullNameHint: 'John Doe',
      Constants.locale.usernameLabel: 'Username',
      Constants.locale.usernameHint: 'john_doe',
      Constants.locale.createAccountButton: 'Create Account',
      Constants.locale.creatingAccount: 'Creating account...',
      Constants.locale.enterFullName: 'Please enter your full name',
      Constants.locale.usernameMinLength:
          'Username must be at least 3 characters',
      Constants.locale.usernameCharset:
          'Username can only contain letters, numbers, and underscores',

      // Verify email
      Constants.locale.confirmEmailTitle: 'Verify Email',
      Constants.locale.confirmEmailHeading: 'Verify your email',
      Constants.locale.confirmEmailSubtitle: 'We sent a 6-digit code to @email',
      Constants.locale.confirmCodeButton: 'Verify Code',
      Constants.locale.verifying: 'Verifying...',
      Constants.locale.resendCode: 'Resend Code',
      Constants.locale.resendCodeIn: 'Resend code in @seconds⁠s',
      Constants.locale.enter6DigitCode: 'Please enter 6-digit code',

      // Forgot passcode
      Constants.locale.forgotPasscodeTitle: 'Forgot Passcode',
      Constants.locale.forgotPasscodeSubtitle:
          'Enter your email and we will send you a link to reset your passcode.',
      Constants.locale.sendResetLink: 'Send Passcode Reset Link',
      Constants.locale.sending: 'Sending...',
      Constants.locale.backToSignIn: 'Back to Sign In',

      // Home
      Constants.locale.home: 'Home',
      Constants.locale.welcomeHome: 'Welcome to Auth Service!',
      Constants.locale.loading: 'Loading...',
      Constants.locale.signOutButton: 'Sign Out',

      // Google / session
      Constants.locale.signInGoogleFailure: 'Google authentication failed!',
      Constants.locale.googleTooManyAttempts:
          'Too many attempts. Please wait @seconds seconds and try again.',
      Constants.locale.sessionReplaced:
          'Your session was replaced by a newer sign in on this platform.',

      // Generic
      Constants.locale.error: 'Error',
      Constants.locale.success: 'Success',
      Constants.locale.warning: 'Warning',
      Constants.locale.info: 'Info',
      Constants.locale.signInFailed: 'Sign in failed. Please try again.',
      Constants.locale.verificationFailed: 'Verification failed',
      Constants.locale.registrationFailed: 'Registration failed',
      Constants.locale.sendCodeFailed: 'Failed to send verification code',
      Constants.locale.resetFailed: 'Failed to send reset instructions',

      // Settings
      Constants.locale.settings: 'Settings',
      Constants.locale.theme: 'Theme',
      Constants.locale.language: 'Language',
      Constants.locale.account: 'Account',
      Constants.locale.logoutConfirmation: 'Are you sure you want to sign out?',
      Constants.locale.cancel: 'Cancel',
      Constants.locale.exit: 'Exit',
      Constants.locale.exitConfirm: 'Are you sure you want to exit the app?',
      Constants.locale.exitTitle: 'Exit App',
      Constants.locale.appInfo: 'App Info',
    },
    'es_ES': {
      Constants.locale.welcomeTitle: '✨ Bienvenido a Auth Service ✨',
      Constants.locale.welcomeSubtitle: 'Apoya sueños o haz realidad los tuyos',
      Constants.locale.continueWithGoogle: 'Continuar con Google',
      Constants.locale.or: 'o',
      Constants.locale.emailLabel: 'Correo electrónico',
      Constants.locale.emailHint: 'tu@email.com',
      Constants.locale.emailHelper:
          'Ingresa tu correo para iniciar sesión o crear una cuenta',
      Constants.locale.continueButton: 'Continuar',
      Constants.locale.checking: 'Verificando...',
      Constants.locale.invalidEmail:
          'Ingresa un correo electrónico válido. (ej. ejemplo@dominio.com)',
      Constants.locale.connectionFailed:
          'Falló la conexión. Inténtalo de nuevo.',
      Constants.locale.goBack: 'volver',

      Constants.locale.signinTitle: 'Iniciar sesión',
      Constants.locale.signinHeading: 'Ingresa tu código',
      Constants.locale.signinSubtitle:
          'Ingresa tu código de 6 dígitos para @email',
      Constants.locale.passcodeLabel: 'Código',
      Constants.locale.signingIn: 'Iniciando sesión...',
      Constants.locale.useDifferentEmail: 'Usar otro correo',
      Constants.locale.forgotPasscodeLink: '¿Olvidaste tu código?',
      Constants.locale.passcode6Digits: 'Ingresa un código de 6 dígitos',
      Constants.locale.attemptsRemaining:
          'Intentos restantes antes del bloqueo: @left/@total',
      Constants.locale.cooldownMessage:
          'Demasiados intentos incorrectos. Espera @seconds segundos.',
      Constants.locale.tryAgainIn: 'Reintentar en @seconds⁠s',
      Constants.locale.signupTitle: 'Crear cuenta',
      Constants.locale.createPasscodeHeading: 'Crea un código',
      Constants.locale.createPasscodeSubtitle:
          'Usarás este código de 6 dígitos para iniciar sesión',
      Constants.locale.googlePasscodeHeading: 'Un último paso',
      Constants.locale.googlePasscodeSubtitle:
          'Crea y confirma un código para completar el registro con Google',
      Constants.locale.confirmPasscodeHeading: 'Confirmar código',
      Constants.locale.confirmPasscodeSubtitle:
          'Por favor confirma tu código de acceso.',
      Constants.locale.confirm: 'Confirmar',
      Constants.locale.changePasscode: 'Cambiar código',
      Constants.locale.passcodesDoNotMatch: 'Los códigos no coinciden',
      Constants.locale.sendingCode: 'Enviando código...',
      Constants.locale.signupInfoTitle: 'Completar perfil',
      Constants.locale.signupInfoHeading: 'Cuéntanos sobre ti',
      Constants.locale.fullNameLabel: 'Nombre completo',
      Constants.locale.fullNameHint: 'Juan Pérez',
      Constants.locale.usernameLabel: 'Nombre de usuario',
      Constants.locale.usernameHint: 'juan_perez',
      Constants.locale.createAccountButton: 'Crear cuenta',
      Constants.locale.creatingAccount: 'Creando cuenta...',
      Constants.locale.enterFullName: 'Ingresa tu nombre completo',
      Constants.locale.usernameMinLength:
          'El nombre de usuario debe tener al menos 3 caracteres',
      Constants.locale.usernameCharset:
          'El nombre de usuario solo puede contener letras, números y guiones bajos',
      Constants.locale.confirmEmailTitle: 'Verificar correo',
      Constants.locale.confirmEmailHeading: 'Verifica tu correo',
      Constants.locale.confirmEmailSubtitle:
          'Enviamos un código de 6 dígitos a @email',
      Constants.locale.confirmCodeButton: 'Verificar código',
      Constants.locale.verifying: 'Verificando...',
      Constants.locale.resendCode: 'Reenviar código',
      Constants.locale.resendCodeIn: 'Reenviar código en @seconds⁠s',
      Constants.locale.enter6DigitCode: 'Ingresa un código de 6 dígitos',
      Constants.locale.forgotPasscodeTitle: 'Código olvidado',
      Constants.locale.forgotPasscodeSubtitle:
          'Ingresa tu correo y te enviaremos un enlace para restablecer tu código.',
      Constants.locale.sendResetLink: 'Enviar enlace de restablecimiento',
      Constants.locale.sending: 'Enviando...',
      Constants.locale.backToSignIn: 'Volver a iniciar sesión',
      Constants.locale.home: 'Inicio',
      Constants.locale.welcomeHome: '¡Bienvenido a Auth Service!',
      Constants.locale.loading: 'Cargando...',
      Constants.locale.signOutButton: 'Cerrar sesión',
      Constants.locale.signInGoogleFailure:
          '¡La autenticación de Google falló!',
      Constants.locale.googleTooManyAttempts:
          'Demasiados intentos. Espera @seconds segundos e inténtalo de nuevo.',
      Constants.locale.sessionReplaced:
          'Tu sesión fue reemplazada por un inicio de sesión más reciente en esta plataforma.',
      Constants.locale.error: 'Error',
      Constants.locale.success: 'Éxito',
      Constants.locale.warning: 'Advertencia',
      Constants.locale.info: 'Información',
      Constants.locale.signInFailed:
          'Falló el inicio de sesión. Inténtalo de nuevo.',
      Constants.locale.verificationFailed: 'La verificación falló',
      Constants.locale.registrationFailed: 'El registro falló',
      Constants.locale.sendCodeFailed:
          'No se pudo enviar el código de verificación',
      Constants.locale.resetFailed: 'No se pudieron enviar las instrucciones',

      // Settings
      Constants.locale.settings: 'Ajustes',
      Constants.locale.theme: 'Tema',
      Constants.locale.language: 'Idioma',
      Constants.locale.account: 'Cuenta',
      Constants.locale.logoutConfirmation:
          '¿Estás seguro de que quieres cerrar sesión?',
      Constants.locale.cancel: 'Cancelar',
      Constants.locale.exit: 'Salir',
      Constants.locale.exitConfirm:
          '¿Estás seguro de que quieres salir de la aplicación?',
      Constants.locale.exitTitle: 'Salir de la aplicación',
      Constants.locale.appInfo: 'Información de la aplicación',
    },
    'my_MM': {
      Constants.locale.welcomeTitle: '✨ Auth Service မှ ကြိုဆိုပါတယ် ✨',
      Constants.locale.welcomeSubtitle:
          'အိပ်မက်များကို ပံ့ပိုးပါ သို့မဟုတ် သင့်အိပ်မက်ကို အကောင်အထည်ဖော်ပါ',
      Constants.locale.continueWithGoogle: 'Google ဖြင့် ဆက်လက်လုပ်ဆောင်ရန်',
      Constants.locale.or: 'သို့မဟုတ်',
      Constants.locale.emailLabel: 'အီးမေးလ်',
      Constants.locale.emailHint: 'your@email.com',
      Constants.locale.emailHelper:
          'လော့ဂ်အင်ဝင်ရန် သို့မဟုတ် အကောင့်ဖွင့်ရန် အီးမေးလ်ထည့်ပါ',
      Constants.locale.continueButton: 'ဆက်လုပ်ရန်',
      Constants.locale.checking: 'စစ်ဆေးနေသည်...',
      Constants.locale.invalidEmail:
          'မှန်ကန်သော အီးမေးလ်လိပ်စာ ထည့်ပါ။ (ဥပမာ example@domain.com)',
      Constants.locale.connectionFailed:
          'ချိတ်ဆက်မှု မအောင်မြင်ပါ။ ထပ်စမ်းကြည့်ပါ။',
      Constants.locale.goBack: 'ပြန်သွား',
      Constants.locale.signinTitle: 'လော့ဂ်အင်',
      Constants.locale.signinHeading: 'သင့်လျှို့ဝှက်ကုဒ်ကို ထည့်ပါ',
      Constants.locale.signinSubtitle:
          '@email အတွက် ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ထည့်ပါ',
      Constants.locale.passcodeLabel: 'လျှို့ဝှက်ကုဒ်',
      Constants.locale.signingIn: 'လော့ဂ်အင်ဝင်နေသည်...',
      Constants.locale.useDifferentEmail: 'အခြားအီးမေးလ် သုံးရန်',
      Constants.locale.forgotPasscodeLink: 'လျှို့ဝှက်ကုဒ် မေ့သွားပြီလား?',
      Constants.locale.passcode6Digits: 'ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ် ထည့်ပါ',
      Constants.locale.attemptsRemaining:
          'ခဏရပ်နားချိန်မတိုင်မီ ကျန်ကြိုးစားခွင့်: @left/@total',
      Constants.locale.cooldownMessage:
          'လျှို့ဝှက်ကုဒ် အမှားများလွန်းပါသည်။ @seconds စက္ကန့် စောင့်ပါ။',
      Constants.locale.tryAgainIn: '@seconds⁠s အတွင်း ပြန်စမ်းပါ',
      Constants.locale.signupTitle: 'အကောင့်ဖွင့်ရန်',
      Constants.locale.createPasscodeHeading: 'လျှို့ဝှက်ကုဒ် သတ်မှတ်ပါ',
      Constants.locale.createPasscodeSubtitle:
          'လော့ဂ်အင်ဝင်ရန် ဤဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ကို သုံးပါမည်',
      Constants.locale.googlePasscodeHeading: 'နောက်ဆုံးအဆင့်',
      Constants.locale.googlePasscodeSubtitle:
          'Google အကောင့်ဖွင့်ခြင်း ပြီးမြောက်ရန် လျှို့ဝှက်ကုဒ် သတ်မှတ်ပြီး အတည်ပြုပါ',
      Constants.locale.confirmPasscodeHeading: 'လျှို့ဝှက်ကုဒ် အတည်ပြုရန်',
      Constants.locale.confirmPasscodeSubtitle:
          'ကျေးဇူးပြု၍ သင့်ကုဒ်ကို အတည်ပြုပါ။',
      Constants.locale.confirm: 'အတည်ပြုပါ',
      Constants.locale.changePasscode: 'ကုဒ်ပြောင်းမည်',
      Constants.locale.passcodesDoNotMatch: 'လျှို့ဝှက်ကုဒ်များ မကိုက်ညီပါ',
      Constants.locale.sendingCode: 'ကုဒ် ပို့နေသည်...',
      Constants.locale.signupInfoTitle: 'ပရိုဖိုင် ဖြည့်ရန်',
      Constants.locale.signupInfoHeading: 'သင့်အကြောင်း ပြောပြပါ',
      Constants.locale.fullNameLabel: 'အမည်အပြည့်အစုံ',
      Constants.locale.fullNameHint: 'မောင်မောင်',
      Constants.locale.usernameLabel: 'အသုံးပြုသူအမည်',
      Constants.locale.usernameHint: 'maung_maung',
      Constants.locale.createAccountButton: 'အကောင့်ဖွင့်ရန်',
      Constants.locale.creatingAccount: 'အကောင့်ဖွင့်နေသည်...',
      Constants.locale.enterFullName: 'အမည်အပြည့်အစုံ ထည့်ပါ',
      Constants.locale.usernameMinLength:
          'အသုံးပြုသူအမည်သည် အနည်းဆုံး စာလုံး ၃ လုံး ရှိရမည်',
      Constants.locale.usernameCharset:
          'အသုံးပြုသူအမည်တွင် စာလုံး၊ ဂဏန်းနှင့် underscore များသာ ပါဝင်နိုင်သည်',
      Constants.locale.confirmEmailTitle: 'အီးမေးလ် အတည်ပြုရန်',
      Constants.locale.confirmEmailHeading: 'သင့်အီးမေးလ်ကို အတည်ပြုပါ',
      Constants.locale.confirmEmailSubtitle:
          '@email သို့ ဂဏန်း ၆ လုံး ကုဒ် ပို့ထားပါသည်',
      Constants.locale.confirmCodeButton: 'ကုဒ် အတည်ပြုရန်',
      Constants.locale.verifying: 'အတည်ပြုနေသည်...',
      Constants.locale.resendCode: 'ကုဒ် ပြန်ပို့ရန်',
      Constants.locale.resendCodeIn: '@seconds⁠s အတွင်း ကုဒ်ပြန်ပို့နိုင်သည်',
      Constants.locale.enter6DigitCode: 'ဂဏန်း ၆ လုံး ကုဒ် ထည့်ပါ',
      Constants.locale.forgotPasscodeTitle: 'လျှို့ဝှက်ကုဒ် မေ့နေပါသလား',
      Constants.locale.forgotPasscodeSubtitle:
          'အီးမေးလ်ထည့်ပါ။ လျှို့ဝှက်ကုဒ် ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ပေးပါမည်။',
      Constants.locale.sendResetLink: 'ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ရန်',
      Constants.locale.sending: 'ပို့နေသည်...',
      Constants.locale.backToSignIn: 'လော့ဂ်အင်သို့ ပြန်သွားရန်',
      Constants.locale.home: 'မူလစာမျက်နှာ',
      Constants.locale.welcomeHome: 'Auth Service မှ ကြိုဆိုပါတယ်!',
      Constants.locale.loading: 'ဖွင့်နေသည်...',
      Constants.locale.signOutButton: 'ထွက်ရန်',
      Constants.locale.signInGoogleFailure: 'Google အတည်ပြုမှု မအောင်မြင်ပါ!',
      Constants.locale.googleTooManyAttempts:
          'ကြိုးစားမှုများလွန်းပါသည်။ @seconds စက္ကန့် စောင့်ပြီး ထပ်စမ်းပါ။',
      Constants.locale.sessionReplaced:
          'ဤစက်ပေါ်တွင် နောက်ဆုံးလော့ဂ်အင်ဝင်မှုကြောင့် သင့် session အသစ်ဖြင့် အစားထိုးခံရပါသည်။',
      Constants.locale.error: 'အမှား',
      Constants.locale.success: 'အောင်မြင်သည်',
      Constants.locale.warning: 'သတိပေးချက်',
      Constants.locale.info: 'သတင်းအချက်အလက်',
      Constants.locale.signInFailed: 'လော့ဂ်အင် မအောင်မြင်ပါ။ ထပ်စမ်းကြည့်ပါ။',
      Constants.locale.verificationFailed: 'အတည်ပြုမှု မအောင်မြင်ပါ',
      Constants.locale.registrationFailed: 'အကောင့်ဖွင့်ခြင်း မအောင်မြင်ပါ',
      Constants.locale.sendCodeFailed: 'အတည်ပြုကုဒ် ပို့၍မရပါ',
      Constants.locale.resetFailed: 'ပြန်သတ်မှတ်ရန် ညွှန်ကြားချက် ပို့၍မရပါ',

      // Settings
      Constants.locale.settings: 'ဆက်တင်များ',
      Constants.locale.theme: 'အပြင်အဆင်',
      Constants.locale.language: 'ဘာသာစကား',
      Constants.locale.account: 'အကောင့်',
      Constants.locale.logoutConfirmation: 'ထွက်ရန် သေချာပါသလား?',
      Constants.locale.cancel: 'မလုပ်တော့ပါ',
      Constants.locale.exit: 'ထွက်ရန်',
      Constants.locale.exitConfirm: 'ထွက်ရန် သေချာပါသလား?',
      Constants.locale.exitTitle: 'အက်ပ်မှ ထွက်ရန်',
      Constants.locale.appInfo: 'အက်ပ်အချက်အလက်',
    },
  };
}
