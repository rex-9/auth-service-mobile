// lib/locales/app_translations.dart
import 'package:get/get.dart';

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
      'welcome_title': '✨ Welcome to Meritbox ✨',
      'welcome_subtitle': 'Support dreams or make yours come true',
      'continue_with_google': 'Continue with Google',
      'or': 'or',
      'email_label': 'Email',
      'email_hint': 'your@email.com',
      'email_helper': 'Enter your email to sign in or create an account',
      'continue_button': 'Continue',
      'checking': 'Checking...',
      'invalid_email':
          'Please enter a valid email address. (e.g. example@domain.com)',
      'connection_failed': 'Connection failed. Please try again.',

      // Sign in passcode
      'signin_title': 'Sign In',
      'signin_heading': 'Enter your passcode',
      'signin_subtitle': 'Enter your 6-digit passcode for @email',
      'passcode_label': 'Passcode',
      'signing_in': 'Signing in...',
      'use_different_email': 'Use different email',
      'forgot_passcode_link': 'Forgot your passcode?',
      'passcode_6_digits': 'Please enter 6-digit passcode',
      'attempts_remaining':
          'Attempts remaining before cooldown: @left/@total',
      'cooldown_message':
          'Too many incorrect passcode attempts. Please wait @seconds seconds.',
      'try_again_in': 'Try again in @seconds⁠s',

      // Sign up passcode
      'signup_title': 'Create Account',
      'create_passcode_heading': 'Create a passcode',
      'create_passcode_subtitle':
          "You'll use this 6-digit passcode to sign in",
      'google_passcode_heading': 'One last step',
      'google_passcode_subtitle':
          'Create and confirm a passcode to finish Google sign up',
      'confirm_passcode_label': 'Confirm Passcode',
      'passcodes_do_not_match': 'Passcodes do not match',
      'sending_code': 'Sending code...',

      // Sign up info
      'signup_info_title': 'Complete Profile',
      'signup_info_heading': 'Tell us about yourself',
      'full_name_label': 'Full Name',
      'full_name_hint': 'John Doe',
      'username_label': 'Username',
      'username_hint': 'john_doe',
      'create_account_button': 'Create Account',
      'creating_account': 'Creating account...',
      'enter_full_name': 'Please enter your full name',
      'username_min_length': 'Username must be at least 3 characters',
      'username_charset':
          'Username can only contain letters, numbers, and underscores',

      // Verify email
      'verify_email_title': 'Verify Email',
      'verify_email_heading': 'Verify your email',
      'verify_email_subtitle': 'We sent a 6-digit code to @email',
      'verify_code_button': 'Verify Code',
      'verifying': 'Verifying...',
      'resend_code': 'Resend Code',
      'resend_code_in': 'Resend code in @seconds⁠s',
      'enter_6_digit_code': 'Please enter 6-digit code',

      // Forgot passcode
      'forgot_passcode_title': 'Forgot Passcode',
      'forgot_passcode_subtitle':
          'Enter your email and we will send you a link to reset your passcode.',
      'send_reset_link': 'Send Passcode Reset Link',
      'sending': 'Sending...',
      'back_to_sign_in': 'Back to Sign In',

      // Home
      'home': 'Home',
      'welcome_home': 'Welcome to Meritbox!',
      'loading': 'Loading...',
      'sign_out_button': 'Sign Out',

      // Google / session
      'sign_in_google_failure': 'Google authentication failed!',
      'google_too_many_attempts':
          'Too many attempts. Please wait @seconds seconds and try again.',
      'session_replaced':
          'Your session was replaced by a newer sign in on this platform.',

      // Generic
      'error': 'Error',
      'success': 'Success',
      'sign_in_failed': 'Sign in failed. Please try again.',
      'verification_failed': 'Verification failed',
      'registration_failed': 'Registration failed',
      'send_code_failed': 'Failed to send verification code',
      'reset_failed': 'Failed to send reset instructions',
    },
    'es_ES': {
      'welcome_title': '✨ Bienvenido a Meritbox ✨',
      'welcome_subtitle': 'Apoya sueños o haz realidad los tuyos',
      'continue_with_google': 'Continuar con Google',
      'or': 'o',
      'email_label': 'Correo electrónico',
      'email_hint': 'tu@email.com',
      'email_helper':
          'Ingresa tu correo para iniciar sesión o crear una cuenta',
      'continue_button': 'Continuar',
      'checking': 'Verificando...',
      'invalid_email':
          'Ingresa un correo electrónico válido. (ej. ejemplo@dominio.com)',
      'connection_failed': 'Falló la conexión. Inténtalo de nuevo.',
      'signin_title': 'Iniciar sesión',
      'signin_heading': 'Ingresa tu código',
      'signin_subtitle': 'Ingresa tu código de 6 dígitos para @email',
      'passcode_label': 'Código',
      'signing_in': 'Iniciando sesión...',
      'use_different_email': 'Usar otro correo',
      'forgot_passcode_link': '¿Olvidaste tu código?',
      'passcode_6_digits': 'Ingresa un código de 6 dígitos',
      'attempts_remaining':
          'Intentos restantes antes del bloqueo: @left/@total',
      'cooldown_message':
          'Demasiados intentos incorrectos. Espera @seconds segundos.',
      'try_again_in': 'Reintentar en @seconds⁠s',
      'signup_title': 'Crear cuenta',
      'create_passcode_heading': 'Crea un código',
      'create_passcode_subtitle':
          'Usarás este código de 6 dígitos para iniciar sesión',
      'google_passcode_heading': 'Un último paso',
      'google_passcode_subtitle':
          'Crea y confirma un código para completar el registro con Google',
      'confirm_passcode_label': 'Confirmar código',
      'passcodes_do_not_match': 'Los códigos no coinciden',
      'sending_code': 'Enviando código...',
      'signup_info_title': 'Completar perfil',
      'signup_info_heading': 'Cuéntanos sobre ti',
      'full_name_label': 'Nombre completo',
      'full_name_hint': 'Juan Pérez',
      'username_label': 'Nombre de usuario',
      'username_hint': 'juan_perez',
      'create_account_button': 'Crear cuenta',
      'creating_account': 'Creando cuenta...',
      'enter_full_name': 'Ingresa tu nombre completo',
      'username_min_length':
          'El nombre de usuario debe tener al menos 3 caracteres',
      'username_charset':
          'El nombre de usuario solo puede contener letras, números y guiones bajos',
      'verify_email_title': 'Verificar correo',
      'verify_email_heading': 'Verifica tu correo',
      'verify_email_subtitle': 'Enviamos un código de 6 dígitos a @email',
      'verify_code_button': 'Verificar código',
      'verifying': 'Verificando...',
      'resend_code': 'Reenviar código',
      'resend_code_in': 'Reenviar código en @seconds⁠s',
      'enter_6_digit_code': 'Ingresa un código de 6 dígitos',
      'forgot_passcode_title': 'Código olvidado',
      'forgot_passcode_subtitle':
          'Ingresa tu correo y te enviaremos un enlace para restablecer tu código.',
      'send_reset_link': 'Enviar enlace de restablecimiento',
      'sending': 'Enviando...',
      'back_to_sign_in': 'Volver a iniciar sesión',
      'home': 'Inicio',
      'welcome_home': '¡Bienvenido a Meritbox!',
      'loading': 'Cargando...',
      'sign_out_button': 'Cerrar sesión',
      'sign_in_google_failure': '¡La autenticación de Google falló!',
      'google_too_many_attempts':
          'Demasiados intentos. Espera @seconds segundos e inténtalo de nuevo.',
      'session_replaced':
          'Tu sesión fue reemplazada por un inicio de sesión más reciente en esta plataforma.',
      'error': 'Error',
      'success': 'Éxito',
      'sign_in_failed': 'Falló el inicio de sesión. Inténtalo de nuevo.',
      'verification_failed': 'La verificación falló',
      'registration_failed': 'El registro falló',
      'send_code_failed': 'No se pudo enviar el código de verificación',
      'reset_failed': 'No se pudieron enviar las instrucciones',
    },
    'my_MM': {
      'welcome_title': '✨ Meritbox မှ ကြိုဆိုပါတယ် ✨',
      'welcome_subtitle':
          'အိပ်မက်များကို ပံ့ပိုးပါ သို့မဟုတ် သင့်အိပ်မက်ကို အကောင်အထည်ဖော်ပါ',
      'continue_with_google': 'Google ဖြင့် ဆက်လက်လုပ်ဆောင်ရန်',
      'or': 'သို့မဟုတ်',
      'email_label': 'အီးမေးလ်',
      'email_hint': 'your@email.com',
      'email_helper':
          'လော့ဂ်အင်ဝင်ရန် သို့မဟုတ် အကောင့်ဖွင့်ရန် အီးမေးလ်ထည့်ပါ',
      'continue_button': 'ဆက်လုပ်ရန်',
      'checking': 'စစ်ဆေးနေသည်...',
      'invalid_email':
          'မှန်ကန်သော အီးမေးလ်လိပ်စာ ထည့်ပါ။ (ဥပမာ example@domain.com)',
      'connection_failed': 'ချိတ်ဆက်မှု မအောင်မြင်ပါ။ ထပ်စမ်းကြည့်ပါ။',
      'signin_title': 'လော့ဂ်အင်',
      'signin_heading': 'သင့်လျှို့ဝှက်ကုဒ်ကို ထည့်ပါ',
      'signin_subtitle': '@email အတွက် ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ထည့်ပါ',
      'passcode_label': 'လျှို့ဝှက်ကုဒ်',
      'signing_in': 'လော့ဂ်အင်ဝင်နေသည်...',
      'use_different_email': 'အခြားအီးမေးလ် သုံးရန်',
      'forgot_passcode_link': 'လျှို့ဝှက်ကုဒ် မေ့သွားပြီလား?',
      'passcode_6_digits': 'ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ် ထည့်ပါ',
      'attempts_remaining':
          'ခဏရပ်နားချိန်မတိုင်မီ ကျန်ကြိုးစားခွင့်: @left/@total',
      'cooldown_message':
          'လျှို့ဝှက်ကုဒ် အမှားများလွန်းပါသည်။ @seconds စက္ကန့် စောင့်ပါ။',
      'try_again_in': '@seconds⁠s အတွင်း ပြန်စမ်းပါ',
      'signup_title': 'အကောင့်ဖွင့်ရန်',
      'create_passcode_heading': 'လျှို့ဝှက်ကုဒ် သတ်မှတ်ပါ',
      'create_passcode_subtitle':
          'လော့ဂ်အင်ဝင်ရန် ဤဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ကို သုံးပါမည်',
      'google_passcode_heading': 'နောက်ဆုံးအဆင့်',
      'google_passcode_subtitle':
          'Google အကောင့်ဖွင့်ခြင်း ပြီးမြောက်ရန် လျှို့ဝှက်ကုဒ် သတ်မှတ်ပြီး အတည်ပြုပါ',
      'confirm_passcode_label': 'လျှို့ဝှက်ကုဒ် အတည်ပြုရန်',
      'passcodes_do_not_match': 'လျှို့ဝှက်ကုဒ်များ မကိုက်ညီပါ',
      'sending_code': 'ကုဒ် ပို့နေသည်...',
      'signup_info_title': 'ပရိုဖိုင် ဖြည့်ရန်',
      'signup_info_heading': 'သင့်အကြောင်း ပြောပြပါ',
      'full_name_label': 'အမည်အပြည့်အစုံ',
      'full_name_hint': 'မောင်မောင်',
      'username_label': 'အသုံးပြုသူအမည်',
      'username_hint': 'maung_maung',
      'create_account_button': 'အကောင့်ဖွင့်ရန်',
      'creating_account': 'အကောင့်ဖွင့်နေသည်...',
      'enter_full_name': 'အမည်အပြည့်အစုံ ထည့်ပါ',
      'username_min_length':
          'အသုံးပြုသူအမည်သည် အနည်းဆုံး စာလုံး ၃ လုံး ရှိရမည်',
      'username_charset':
          'အသုံးပြုသူအမည်တွင် စာလုံး၊ ဂဏန်းနှင့် underscore များသာ ပါဝင်နိုင်သည်',
      'verify_email_title': 'အီးမေးလ် အတည်ပြုရန်',
      'verify_email_heading': 'သင့်အီးမေးလ်ကို အတည်ပြုပါ',
      'verify_email_subtitle': '@email သို့ ဂဏန်း ၆ လုံး ကုဒ် ပို့ထားပါသည်',
      'verify_code_button': 'ကုဒ် အတည်ပြုရန်',
      'verifying': 'အတည်ပြုနေသည်...',
      'resend_code': 'ကုဒ် ပြန်ပို့ရန်',
      'resend_code_in': '@seconds⁠s အတွင်း ကုဒ်ပြန်ပို့နိုင်သည်',
      'enter_6_digit_code': 'ဂဏန်း ၆ လုံး ကုဒ် ထည့်ပါ',
      'forgot_passcode_title': 'လျှို့ဝှက်ကုဒ် မေ့နေပါသလား',
      'forgot_passcode_subtitle':
          'အီးမေးလ်ထည့်ပါ။ လျှို့ဝှက်ကုဒ် ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ပေးပါမည်။',
      'send_reset_link': 'ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ရန်',
      'sending': 'ပို့နေသည်...',
      'back_to_sign_in': 'လော့ဂ်အင်သို့ ပြန်သွားရန်',
      'home': 'မူလစာမျက်နှာ',
      'welcome_home': 'Meritbox မှ ကြိုဆိုပါတယ်!',
      'loading': 'ဖွင့်နေသည်...',
      'sign_out_button': 'ထွက်ရန်',
      'sign_in_google_failure': 'Google အတည်ပြုမှု မအောင်မြင်ပါ!',
      'google_too_many_attempts':
          'ကြိုးစားမှုများလွန်းပါသည်။ @seconds စက္ကန့် စောင့်ပြီး ထပ်စမ်းပါ။',
      'session_replaced':
          'ဤစက်ပေါ်တွင် နောက်ဆုံးလော့ဂ်အင်ဝင်မှုကြောင့် သင့် session အသစ်ဖြင့် အစားထိုးခံရပါသည်။',
      'error': 'အမှား',
      'success': 'အောင်မြင်သည်',
      'sign_in_failed': 'လော့ဂ်အင် မအောင်မြင်ပါ။ ထပ်စမ်းကြည့်ပါ။',
      'verification_failed': 'အတည်ပြုမှု မအောင်မြင်ပါ',
      'registration_failed': 'အကောင့်ဖွင့်ခြင်း မအောင်မြင်ပါ',
      'send_code_failed': 'အတည်ပြုကုဒ် ပို့၍မရပါ',
      'reset_failed': 'ပြန်သတ်မှတ်ရန် ညွှန်ကြားချက် ပို့၍မရပါ',
    },
  };
}
