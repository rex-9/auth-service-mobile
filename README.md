Here's a comprehensive README for your Flutter project with emphasis on the design system:

---

# Meritbox Mobile

A Flutter mobile application for Meritbox platform with clean GetX architecture, consistent design system, and multi-language support.

## 📁 Project Structure

```
lib/
├── bindings/          # Dependency injection
├── config/            # App configuration
├── constants/         # App constants & keys
├── controllers/       # GetX controllers (business logic)
├── design/            # 🎨 Design System (READ THIS!)
├── locales/           # Internationalization
├── models/            # Data models
├── pages/             # UI screens
├── routes/            # Navigation & route guards
├── services/          # API & storage services
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >=3.0.0
- Dart >=3.0.0
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/meritbox_mobile.git
cd meritbox_mobile
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure API endpoints**

Update `lib/routes/server_routes.dart`:

```dart
static const String baseUrl = 'https://your-api-server.com';
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
flutter run
```

## 📱 Features

- **Dual Authentication Flow**
  - Email-based authentication with 6-digit passcode
  - Google Sign-In integration
  - Smart user detection (existing vs new users)

- **Clean Architecture**
  - GetX MVC pattern
  - Separation of concerns (Services, Controllers, Pages)
  - Centralized dependency injection

- **Modern UI/UX**
  - Material Design 3
  - Light/Dark theme support (auto / day / night toggle, persisted)
  - Localization: English, Español, မြန်မာ (GetX translations, persisted)
  - Responsive design with ScreenUtil
  - Smooth animations and transitions

- **Security**
  - JWT token-based authentication
  - Secure local storage with GetStorage
  - 6-digit passcode validation
  - Passcode attempt limiting with escalating cooldowns (30s/60s/120s), synced with server retry metadata and persisted per email
  - One active session per platform (`X-Platform: mobile`); replaced sessions are signed out with a notice
  - Forgot passcode reset-link email with resend countdown

---

## 📂 Configuration & Constants

### Config (`lib/config/`)

```dart
import 'package:meritbox_mobile/config/config.dart';

// App config
AppConfig().googleServerClientIdKey
AppConfig().apiBaseUrl
```

### Constants (`lib/constants/`)

```dart
import 'package:meritbox_mobile/constants/constants.dart';

// App constants
Constants.app.name
Constants.app.version

// Locale keys (for translations)
Constants.locale.welcomeTitle
Constants.locale.signIn
Constants.locale.error
```

### Locales (`lib/locales/`)

```dart
import 'package:meritbox_mobile/locales/app_translations.dart';

// Use translations
'key'.tr
'key'.trParams({'name': 'John'})

// Supported locales
AppTranslations.supportedLocales  // {'en_US': 'English', ...}
```

### Routes (`lib/routes/`)

```dart
import 'package:meritbox_mobile/routes/routes.dart';

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

## 🧪 Running Tests

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

---

## 📄 License

This project is proprietary and confidential.

---

## 🙏 Acknowledgments

- Flutter team
- GetX team
- Google Sign-In team

---

**Made with ❤️ by Meritbox Team**

---
