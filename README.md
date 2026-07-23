# Auth Service Mobile

A Flutter mobile application for Auth Service platform with clean GetX architecture, consistent design system, and multi-language support.

---

## 📁 Project Structure

```
lib/
├── bindings/          # Dependency injection
│   └── initial_binding.dart
├── config/            # App configuration
│   ├── app_config.dart
│   └── config.dart
├── constants/         # App constants & keys
│   ├── app_constants.dart
│   ├── http_status.dart
│   └── locale_constants.dart
├── controllers/       # GetX controllers (business logic)
│   ├── auth_controller.dart
│   └── settings_controller.dart
├── design/            # 🎨 Design System (READ THIS!)
│   ├── components/    # Reusable UI components
│   ├── elements/      # Design tokens
│   ├── extensions/    # Theme-aware extensions
│   └── design.dart    # Single entry point
├── helpers/           # Utility helpers
│   └── flag_helper.dart
├── locales/           # Internationalization
│   └── app_translations.dart
├── models/            # Data models
│   ├── api_response.dart
│   └── user_model.dart
├── pages/             # UI screens
│   ├── auth_page.dart
│   ├── home_page.dart
│   ├── settings_page.dart
│   └── splash_page.dart
├── routes/            # Navigation & route guards
│   ├── app_routes.dart
│   ├── route_guard.dart
│   └── server_routes.dart
└── services/          # API & storage services
    ├── api_service.dart
    ├── auth_service.dart
    ├── auth_service_impl.dart
    └── storage_service.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >=3.0.0
- Dart >=3.0.0
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/auth_service_mobile.git
cd auth_service_mobile
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Environment Configuration**

Create `.env.dev` file in project root:

```env
APP_NAME=Auth Service
APP_VERSION=1.0.0
GOOGLE_SERVER_CLIENT_ID=your_client_id.apps.googleusercontent.com
API_BASE_URL=http://10.0.2.2:3000
```

Add to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - .env.dev
    - .env.uat
    - .env.prod
```

4. **Configure Google Sign-In**

#### Android

- Add `google-services.json` to `android/app/`
- Configure SHA-1 and SHA-256 fingerprints

#### iOS

- Add `GoogleService-Info.plist` to `ios/Runner/`
- Configure URL schemes in `Info.plist`

5. **Run the app**

```bash
# Development
flutter run

# With specific environment
flutter run --dart-define=APP_ENV=.env.dev
```

---

## 📱 Features

- **Dual Authentication Flow**
  - Email-based authentication with 6-digit passcode
  - Google Sign-In integration
  - Smart user detection (existing vs new users)

- **Clean Architecture**
  - GetX MVC pattern
  - Interface + Implementation pattern for services
  - Separation of concerns (Services, Controllers, Pages)
  - Centralized dependency injection

- **Modern UI/UX**
  - Material Design 3
  - Light/Dark theme support (persisted)
  - Localization: English, Español, မြန်မာ (persisted)
  - Responsive design with ScreenUtil
  - Smooth animations and transitions

- **Security**
  - JWT token-based authentication
  - Secure local storage with GetStorage
  - 6-digit passcode validation
  - Passcode attempt limiting with escalating cooldowns (30s/60s/120s)
  - One active session per platform (`X-Platform: mobile`)
  - Forgot passcode reset-link email with resend countdown

---

## 📂 Configuration & Constants

### Config (`lib/config/`)

```dart
import 'package:auth_service_mobile/config/config.dart';

// App config
AppConfig().googleServerClientIdKey
AppConfig().apiBaseUrl
```

### Constants (`lib/constants/`)

```dart
import 'package:auth_service_mobile/constants/constants.dart';

// App constants
Constants.app.name
Constants.app.version

// HTTP Status codes (no magic numbers!)
HttpStatus.ok            // 200
HttpStatus.unauthorized  // 401
HttpStatus.tooManyRequests // 429

// Locale keys (for translations)
Constants.locale.welcomeTitle
Constants.locale.signIn
Constants.locale.error
```

### HTTP Status Codes

```dart
// Use constants instead of hardcoded numbers
if (response.statusCode == HttpStatus.unauthorized) {
  // Handle unauthorized
}

// Check status
if (HttpStatusMap.isSuccess(response.statusCode)) {
  // Success!
}
```

### Routes (`lib/routes/`)

```dart
import 'package:auth_service_mobile/routes/routes.dart';

// Navigate
AppRoutes.toHome()
AppRoutes.toSettings()
AppRoutes.toAuth()

// Server endpoints
ServerRoutes.baseUrl
ServerRoutes.peekUser
ServerRoutes.signIn
```

---

## 🧪 Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

---

## 📦 Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS IPA
flutter build ios --release

# Web
flutter build web --release
```

---

## 🛠️ Dependencies

| Package              | Purpose                          |
| -------------------- | -------------------------------- |
| `get`                | State management, navigation, DI |
| `get_storage`        | Local storage                    |
| `google_sign_in`     | Google authentication            |
| `pin_code_fields`    | OTP/Passcode input               |
| `flutter_screenutil` | Responsive design                |
| `package_info_plus`  | App version info                 |
| `flutter_dotenv`     | Environment variables            |

---

## 📄 License

This project is proprietary and confidential.

---

## 🙏 Acknowledgments

- Flutter team
- GetX team
- Google Sign-In team

---

**Made with ❤️ by Auth Service Team**
