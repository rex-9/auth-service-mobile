// lib/locales/app_translations.dart
import 'package:get/get.dart';
import '../constants/locale_constants.dart';

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
      LocaleConstants.welcomeTitle: '✨ Welcome to Meritbox ✨',
      LocaleConstants.welcomeSubtitle: 'Support dreams or make yours come true',
      LocaleConstants.continueWithGoogle: 'Continue with Google',
      LocaleConstants.or: 'or',
      LocaleConstants.emailLabel: 'Email',
      LocaleConstants.emailHint: 'your@email.com',
      LocaleConstants.emailHelper:
          'Enter your email to sign in or create an account',
      LocaleConstants.continueButton: 'Continue',
      LocaleConstants.checking: 'Checking...',
      LocaleConstants.invalidEmail:
          'Please enter a valid email address. (e.g. example@domain.com)',
      LocaleConstants.connectionFailed: 'Connection failed. Please try again.',

      // Sign in passcode
      LocaleConstants.signinTitle: 'Sign In',
      LocaleConstants.signinHeading: 'Enter your passcode',
      LocaleConstants.signinSubtitle: 'Enter your 6-digit passcode for @email',
      LocaleConstants.passcodeLabel: 'Passcode',
      LocaleConstants.signingIn: 'Signing in...',
      LocaleConstants.useDifferentEmail: 'Use different email',
      LocaleConstants.forgotPasscodeLink: 'Forgot your passcode?',
      LocaleConstants.passcode6Digits: 'Please enter 6-digit passcode',
      LocaleConstants.attemptsRemaining:
          'Attempts remaining before cooldown: @left/@total',
      LocaleConstants.cooldownMessage:
          'Too many incorrect passcode attempts. Please wait @seconds seconds.',
      LocaleConstants.tryAgainIn: 'Try again in @seconds⁠s',

      // Sign up passcode
      LocaleConstants.signupTitle: 'Create Account',
      LocaleConstants.createPasscodeHeading: 'Create a passcode',
      LocaleConstants.createPasscodeSubtitle:
          "You'll use this 6-digit passcode to sign in",
      LocaleConstants.googlePasscodeHeading: 'One last step',
      LocaleConstants.googlePasscodeSubtitle:
          'Create and confirm a passcode to finish Google sign up',
      LocaleConstants.confirmPasscodeLabel: 'Confirm Passcode',
      LocaleConstants.passcodesDoNotMatch: 'Passcodes do not match',
      LocaleConstants.sendingCode: 'Sending code...',

      // Sign up info
      LocaleConstants.signupInfoTitle: 'Complete Profile',
      LocaleConstants.signupInfoHeading: 'Tell us about yourself',
      LocaleConstants.fullNameLabel: 'Full Name',
      LocaleConstants.fullNameHint: 'John Doe',
      LocaleConstants.usernameLabel: 'Username',
      LocaleConstants.usernameHint: 'john_doe',
      LocaleConstants.createAccountButton: 'Create Account',
      LocaleConstants.creatingAccount: 'Creating account...',
      LocaleConstants.enterFullName: 'Please enter your full name',
      LocaleConstants.usernameMinLength:
          'Username must be at least 3 characters',
      LocaleConstants.usernameCharset:
          'Username can only contain letters, numbers, and underscores',

      // Verify email
      LocaleConstants.verifyEmailTitle: 'Verify Email',
      LocaleConstants.verifyEmailHeading: 'Verify your email',
      LocaleConstants.verifyEmailSubtitle: 'We sent a 6-digit code to @email',
      LocaleConstants.verifyCodeButton: 'Verify Code',
      LocaleConstants.verifying: 'Verifying...',
      LocaleConstants.resendCode: 'Resend Code',
      LocaleConstants.resendCodeIn: 'Resend code in @seconds⁠s',
      LocaleConstants.enter6DigitCode: 'Please enter 6-digit code',

      // Forgot passcode
      LocaleConstants.forgotPasscodeTitle: 'Forgot Passcode',
      LocaleConstants.forgotPasscodeSubtitle:
          'Enter your email and we will send you a link to reset your passcode.',
      LocaleConstants.sendResetLink: 'Send Passcode Reset Link',
      LocaleConstants.sending: 'Sending...',
      LocaleConstants.backToSignIn: 'Back to Sign In',

      // Home
      LocaleConstants.home: 'Home',
      LocaleConstants.welcomeHome: 'Welcome to Meritbox!',
      LocaleConstants.loading: 'Loading...',
      LocaleConstants.signOutButton: 'Sign Out',

      // Google / session
      LocaleConstants.signInGoogleFailure: 'Google authentication failed!',
      LocaleConstants.googleTooManyAttempts:
          'Too many attempts. Please wait @seconds seconds and try again.',
      LocaleConstants.sessionReplaced:
          'Your session was replaced by a newer sign in on this platform.',

      // Generic
      LocaleConstants.error: 'Error',
      LocaleConstants.success: 'Success',
      LocaleConstants.warning: 'Warning',
      LocaleConstants.info: 'Info',
      LocaleConstants.signInFailed: 'Sign in failed. Please try again.',
      LocaleConstants.verificationFailed: 'Verification failed',
      LocaleConstants.registrationFailed: 'Registration failed',
      LocaleConstants.sendCodeFailed: 'Failed to send verification code',
      LocaleConstants.resetFailed: 'Failed to send reset instructions',
    },
    'es_ES': {
      LocaleConstants.welcomeTitle: '✨ Bienvenido a Meritbox ✨',
      LocaleConstants.welcomeSubtitle: 'Apoya sueños o haz realidad los tuyos',
      LocaleConstants.continueWithGoogle: 'Continuar con Google',
      LocaleConstants.or: 'o',
      LocaleConstants.emailLabel: 'Correo electrónico',
      LocaleConstants.emailHint: 'tu@email.com',
      LocaleConstants.emailHelper:
          'Ingresa tu correo para iniciar sesión o crear una cuenta',
      LocaleConstants.continueButton: 'Continuar',
      LocaleConstants.checking: 'Verificando...',
      LocaleConstants.invalidEmail:
          'Ingresa un correo electrónico válido. (ej. ejemplo@dominio.com)',
      LocaleConstants.connectionFailed:
          'Falló la conexión. Inténtalo de nuevo.',
      LocaleConstants.signinTitle: 'Iniciar sesión',
      LocaleConstants.signinHeading: 'Ingresa tu código',
      LocaleConstants.signinSubtitle:
          'Ingresa tu código de 6 dígitos para @email',
      LocaleConstants.passcodeLabel: 'Código',
      LocaleConstants.signingIn: 'Iniciando sesión...',
      LocaleConstants.useDifferentEmail: 'Usar otro correo',
      LocaleConstants.forgotPasscodeLink: '¿Olvidaste tu código?',
      LocaleConstants.passcode6Digits: 'Ingresa un código de 6 dígitos',
      LocaleConstants.attemptsRemaining:
          'Intentos restantes antes del bloqueo: @left/@total',
      LocaleConstants.cooldownMessage:
          'Demasiados intentos incorrectos. Espera @seconds segundos.',
      LocaleConstants.tryAgainIn: 'Reintentar en @seconds⁠s',
      LocaleConstants.signupTitle: 'Crear cuenta',
      LocaleConstants.createPasscodeHeading: 'Crea un código',
      LocaleConstants.createPasscodeSubtitle:
          'Usarás este código de 6 dígitos para iniciar sesión',
      LocaleConstants.googlePasscodeHeading: 'Un último paso',
      LocaleConstants.googlePasscodeSubtitle:
          'Crea y confirma un código para completar el registro con Google',
      LocaleConstants.confirmPasscodeLabel: 'Confirmar código',
      LocaleConstants.passcodesDoNotMatch: 'Los códigos no coinciden',
      LocaleConstants.sendingCode: 'Enviando código...',
      LocaleConstants.signupInfoTitle: 'Completar perfil',
      LocaleConstants.signupInfoHeading: 'Cuéntanos sobre ti',
      LocaleConstants.fullNameLabel: 'Nombre completo',
      LocaleConstants.fullNameHint: 'Juan Pérez',
      LocaleConstants.usernameLabel: 'Nombre de usuario',
      LocaleConstants.usernameHint: 'juan_perez',
      LocaleConstants.createAccountButton: 'Crear cuenta',
      LocaleConstants.creatingAccount: 'Creando cuenta...',
      LocaleConstants.enterFullName: 'Ingresa tu nombre completo',
      LocaleConstants.usernameMinLength:
          'El nombre de usuario debe tener al menos 3 caracteres',
      LocaleConstants.usernameCharset:
          'El nombre de usuario solo puede contener letras, números y guiones bajos',
      LocaleConstants.verifyEmailTitle: 'Verificar correo',
      LocaleConstants.verifyEmailHeading: 'Verifica tu correo',
      LocaleConstants.verifyEmailSubtitle:
          'Enviamos un código de 6 dígitos a @email',
      LocaleConstants.verifyCodeButton: 'Verificar código',
      LocaleConstants.verifying: 'Verificando...',
      LocaleConstants.resendCode: 'Reenviar código',
      LocaleConstants.resendCodeIn: 'Reenviar código en @seconds⁠s',
      LocaleConstants.enter6DigitCode: 'Ingresa un código de 6 dígitos',
      LocaleConstants.forgotPasscodeTitle: 'Código olvidado',
      LocaleConstants.forgotPasscodeSubtitle:
          'Ingresa tu correo y te enviaremos un enlace para restablecer tu código.',
      LocaleConstants.sendResetLink: 'Enviar enlace de restablecimiento',
      LocaleConstants.sending: 'Enviando...',
      LocaleConstants.backToSignIn: 'Volver a iniciar sesión',
      LocaleConstants.home: 'Inicio',
      LocaleConstants.welcomeHome: '¡Bienvenido a Meritbox!',
      LocaleConstants.loading: 'Cargando...',
      LocaleConstants.signOutButton: 'Cerrar sesión',
      LocaleConstants.signInGoogleFailure: '¡La autenticación de Google falló!',
      LocaleConstants.googleTooManyAttempts:
          'Demasiados intentos. Espera @seconds segundos e inténtalo de nuevo.',
      LocaleConstants.sessionReplaced:
          'Tu sesión fue reemplazada por un inicio de sesión más reciente en esta plataforma.',
      LocaleConstants.error: 'Error',
      LocaleConstants.success: 'Éxito',
      LocaleConstants.warning: 'Advertencia',
      LocaleConstants.info: 'Información',
      LocaleConstants.signInFailed:
          'Falló el inicio de sesión. Inténtalo de nuevo.',
      LocaleConstants.verificationFailed: 'La verificación falló',
      LocaleConstants.registrationFailed: 'El registro falló',
      LocaleConstants.sendCodeFailed:
          'No se pudo enviar el código de verificación',
      LocaleConstants.resetFailed: 'No se pudieron enviar las instrucciones',
    },
    'my_MM': {
      LocaleConstants.welcomeTitle: '✨ Meritbox မှ ကြိုဆိုပါတယ် ✨',
      LocaleConstants.welcomeSubtitle:
          'အိပ်မက်များကို ပံ့ပိုးပါ သို့မဟုတ် သင့်အိပ်မက်ကို အကောင်အထည်ဖော်ပါ',
      LocaleConstants.continueWithGoogle: 'Google ဖြင့် ဆက်လက်လုပ်ဆောင်ရန်',
      LocaleConstants.or: 'သို့မဟုတ်',
      LocaleConstants.emailLabel: 'အီးမေးလ်',
      LocaleConstants.emailHint: 'your@email.com',
      LocaleConstants.emailHelper:
          'လော့ဂ်အင်ဝင်ရန် သို့မဟုတ် အကောင့်ဖွင့်ရန် အီးမေးလ်ထည့်ပါ',
      LocaleConstants.continueButton: 'ဆက်လုပ်ရန်',
      LocaleConstants.checking: 'စစ်ဆေးနေသည်...',
      LocaleConstants.invalidEmail:
          'မှန်ကန်သော အီးမေးလ်လိပ်စာ ထည့်ပါ။ (ဥပမာ example@domain.com)',
      LocaleConstants.connectionFailed:
          'ချိတ်ဆက်မှု မအောင်မြင်ပါ။ ထပ်စမ်းကြည့်ပါ။',
      LocaleConstants.signinTitle: 'လော့ဂ်အင်',
      LocaleConstants.signinHeading: 'သင့်လျှို့ဝှက်ကုဒ်ကို ထည့်ပါ',
      LocaleConstants.signinSubtitle:
          '@email အတွက် ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ထည့်ပါ',
      LocaleConstants.passcodeLabel: 'လျှို့ဝှက်ကုဒ်',
      LocaleConstants.signingIn: 'လော့ဂ်အင်ဝင်နေသည်...',
      LocaleConstants.useDifferentEmail: 'အခြားအီးမေးလ် သုံးရန်',
      LocaleConstants.forgotPasscodeLink: 'လျှို့ဝှက်ကုဒ် မေ့သွားပြီလား?',
      LocaleConstants.passcode6Digits: 'ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ် ထည့်ပါ',
      LocaleConstants.attemptsRemaining:
          'ခဏရပ်နားချိန်မတိုင်မီ ကျန်ကြိုးစားခွင့်: @left/@total',
      LocaleConstants.cooldownMessage:
          'လျှို့ဝှက်ကုဒ် အမှားများလွန်းပါသည်။ @seconds စက္ကန့် စောင့်ပါ။',
      LocaleConstants.tryAgainIn: '@seconds⁠s အတွင်း ပြန်စမ်းပါ',
      LocaleConstants.signupTitle: 'အကောင့်ဖွင့်ရန်',
      LocaleConstants.createPasscodeHeading: 'လျှို့ဝှက်ကုဒ် သတ်မှတ်ပါ',
      LocaleConstants.createPasscodeSubtitle:
          'လော့ဂ်အင်ဝင်ရန် ဤဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ကို သုံးပါမည်',
      LocaleConstants.googlePasscodeHeading: 'နောက်ဆုံးအဆင့်',
      LocaleConstants.googlePasscodeSubtitle:
          'Google အကောင့်ဖွင့်ခြင်း ပြီးမြောက်ရန် လျှို့ဝှက်ကုဒ် သတ်မှတ်ပြီး အတည်ပြုပါ',
      LocaleConstants.confirmPasscodeLabel: 'လျှို့ဝှက်ကုဒ် အတည်ပြုရန်',
      LocaleConstants.passcodesDoNotMatch: 'လျှို့ဝှက်ကုဒ်များ မကိုက်ညီပါ',
      LocaleConstants.sendingCode: 'ကုဒ် ပို့နေသည်...',
      LocaleConstants.signupInfoTitle: 'ပရိုဖိုင် ဖြည့်ရန်',
      LocaleConstants.signupInfoHeading: 'သင့်အကြောင်း ပြောပြပါ',
      LocaleConstants.fullNameLabel: 'အမည်အပြည့်အစုံ',
      LocaleConstants.fullNameHint: 'မောင်မောင်',
      LocaleConstants.usernameLabel: 'အသုံးပြုသူအမည်',
      LocaleConstants.usernameHint: 'maung_maung',
      LocaleConstants.createAccountButton: 'အကောင့်ဖွင့်ရန်',
      LocaleConstants.creatingAccount: 'အကောင့်ဖွင့်နေသည်...',
      LocaleConstants.enterFullName: 'အမည်အပြည့်အစုံ ထည့်ပါ',
      LocaleConstants.usernameMinLength:
          'အသုံးပြုသူအမည်သည် အနည်းဆုံး စာလုံး ၃ လုံး ရှိရမည်',
      LocaleConstants.usernameCharset:
          'အသုံးပြုသူအမည်တွင် စာလုံး၊ ဂဏန်းနှင့် underscore များသာ ပါဝင်နိုင်သည်',
      LocaleConstants.verifyEmailTitle: 'အီးမေးလ် အတည်ပြုရန်',
      LocaleConstants.verifyEmailHeading: 'သင့်အီးမေးလ်ကို အတည်ပြုပါ',
      LocaleConstants.verifyEmailSubtitle:
          '@email သို့ ဂဏန်း ၆ လုံး ကုဒ် ပို့ထားပါသည်',
      LocaleConstants.verifyCodeButton: 'ကုဒ် အတည်ပြုရန်',
      LocaleConstants.verifying: 'အတည်ပြုနေသည်...',
      LocaleConstants.resendCode: 'ကုဒ် ပြန်ပို့ရန်',
      LocaleConstants.resendCodeIn: '@seconds⁠s အတွင်း ကုဒ်ပြန်ပို့နိုင်သည်',
      LocaleConstants.enter6DigitCode: 'ဂဏန်း ၆ လုံး ကုဒ် ထည့်ပါ',
      LocaleConstants.forgotPasscodeTitle: 'လျှို့ဝှက်ကုဒ် မေ့နေပါသလား',
      LocaleConstants.forgotPasscodeSubtitle:
          'အီးမေးလ်ထည့်ပါ။ လျှို့ဝှက်ကုဒ် ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ပေးပါမည်။',
      LocaleConstants.sendResetLink: 'ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ရန်',
      LocaleConstants.sending: 'ပို့နေသည်...',
      LocaleConstants.backToSignIn: 'လော့ဂ်အင်သို့ ပြန်သွားရန်',
      LocaleConstants.home: 'မူလစာမျက်နှာ',
      LocaleConstants.welcomeHome: 'Meritbox မှ ကြိုဆိုပါတယ်!',
      LocaleConstants.loading: 'ဖွင့်နေသည်...',
      LocaleConstants.signOutButton: 'ထွက်ရန်',
      LocaleConstants.signInGoogleFailure: 'Google အတည်ပြုမှု မအောင်မြင်ပါ!',
      LocaleConstants.googleTooManyAttempts:
          'ကြိုးစားမှုများလွန်းပါသည်။ @seconds စက္ကန့် စောင့်ပြီး ထပ်စမ်းပါ။',
      LocaleConstants.sessionReplaced:
          'ဤစက်ပေါ်တွင် နောက်ဆုံးလော့ဂ်အင်ဝင်မှုကြောင့် သင့် session အသစ်ဖြင့် အစားထိုးခံရပါသည်။',
      LocaleConstants.error: 'အမှား',
      LocaleConstants.success: 'အောင်မြင်သည်',
      LocaleConstants.warning: 'သတိပေးချက်',
      LocaleConstants.info: 'သတင်းအချက်အလက်',
      LocaleConstants.signInFailed: 'လော့ဂ်အင် မအောင်မြင်ပါ။ ထပ်စမ်းကြည့်ပါ။',
      LocaleConstants.verificationFailed: 'အတည်ပြုမှု မအောင်မြင်ပါ',
      LocaleConstants.registrationFailed: 'အကောင့်ဖွင့်ခြင်း မအောင်မြင်ပါ',
      LocaleConstants.sendCodeFailed: 'အတည်ပြုကုဒ် ပို့၍မရပါ',
      LocaleConstants.resetFailed: 'ပြန်သတ်မှတ်ရန် ညွှန်ကြားချက် ပို့၍မရပါ',
    },
  };
}
