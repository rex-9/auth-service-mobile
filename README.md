<a name="readme-top"></a>

<div align="center">
  <h3><b>Rexone Mobile</b></h3>
</div>

<!-- TABLE OF CONTENTS -->

# 📗 Table of Contents

- [📗 Table of Contents](#-table-of-contents)
- [📖 Rexone Mobile](#-rexone-mobile)
  - [🚀 Featuring!](#-featuring)
    - [🌟 Modern Tech Stack](#-modern-tech-stack)
    - [🏗️ Architecture \& Design](#️-architecture--design)
    - [🎨 Design System](#-design-system)
    - [🌍 Localization](#-localization)
    - [🔐 Authentication \& Security](#-authentication--security)
    - [⚙️ Configuration \& Environment Management](#️-configuration--environment-management)
  - [🛠 Built With](#-built-with)
    - [Tech Stack](#tech-stack)
  - [💻 Getting Started](#-getting-started)
    - [Prerequisites](#prerequisites)
    - [Setup](#setup)
    - [Environment Variables](#environment-variables)
    - [Google Sign-In Configuration](#google-sign-in-configuration)
      - [Android](#android)
      - [iOS](#ios)
    - [Run](#run)
  - [📁 Project Structure](#-project-structure)
  - [📂 Configuration \& Constants](#-configuration--constants)
    - [Config](#config)
    - [Constants](#constants)
    - [HTTP Status Codes](#http-status-codes)
    - [Routes](#routes)
  - [🧪 Testing](#-testing)
  - [� Analytics Implementation](#-analytics-implementation)
    - [Android APK](#android-apk)
    - [Android App Bundle](#android-app-bundle)
    - [iOS](#ios-1)
    - [Web](#web)
  - [📦 Dependencies](#-dependencies)
- [☕ Support](#-support)
  - [👤 Author](#-author)

# 📖 Rexone Mobile

**Rexone Mobile** is a Flutter mobile foundation for the Rexone platform, providing a scalable and maintainable architecture for authenticated mobile applications.

The project provides a clean **GetX-based MVC architecture**, centralized dependency injection, a reusable design system, environment-based configuration, multi-language support, and secure authentication workflows.

It is designed to work as part of the **Rexone ecosystem**, sharing a common backend foundation with Rexone Web while maintaining a platform-specific mobile experience.

**Related Repositories:**

- **Core API**: [Rexone Core](https://github.com/rex-9/rexone-core)
- **Web Application**: [Rexone Web](https://github.com/rex-9/rexone-web)

## 🚀 Featuring!

### 🌟 Modern Tech Stack

- **Flutter**: Cross-platform mobile application development.
- **Dart**: Strongly typed and modern application development.
- **GetX**: State management, navigation, and dependency injection.
- **GetStorage**: Lightweight persistent local storage.
- **Flutter ScreenUtil**: Responsive UI scaling across different screen sizes.
- **Flutter Dotenv**: Environment-specific application configuration.

### 🏗️ Architecture & Design

- **GetX MVC Architecture**: Clear separation between Pages, Controllers, Services, and Models.
- **Controller Layer**: Handles application and business logic while coordinating UI state.
- **Service Layer**: Encapsulates API communication and application services.
- **Interface + Implementation Pattern**: Services can be defined through abstractions and implemented independently.
- **Model Layer**: Strongly typed application and API data models.
- **Centralized Dependency Injection**: Application dependencies are registered through GetX bindings.
- **Route Guards**: Authentication-aware navigation and protected application flows.
- **Separation of Concerns**: Keeps presentation, business logic, networking, configuration, and persistence independently maintainable.

### 🎨 Design System

The application includes a centralized design system under `lib/design/`.

- **Reusable Components**: Shared UI components for consistent application experiences.
- **Design Elements**: Centralized design tokens and visual constants.
- **Theme Extensions**: Theme-aware reusable styling and component behavior.
- **Material Design 3**: Modern Material-based application interface.
- **Light & Dark Themes**: Theme switching with persisted user preferences.
- **Single Design Entry Point**: Shared design functionality can be accessed through `design.dart`.

> **Important:** When building new UI, use the existing design system instead of creating one-off components whenever possible.

### 🌍 Localization

Rexone Mobile supports a multi-language application experience.

Currently supported languages include:

- 🇬🇧 **English**
- 🇪🇸 **Español**
- 🇲🇲 **မြန်မာ**

Localization is centralized under `lib/locales/`, with language and locale-related constants maintained under `lib/constants/`.

User language preferences are persisted locally.

### 🔐 Authentication & Security

- **Email Authentication**: Email-based authentication with a 6-digit passcode.
- **Google Sign-In**: OAuth-based authentication through Google.
- **Smart User Detection**: Determines whether a user already exists before authentication.
- **JWT Authentication**: Token-based authentication through the Rexone Core API.
- **Secure Local Storage**: Authentication and application state can be persisted locally using GetStorage.
- **Passcode Validation**: Six-digit passcode validation and authentication flow.
- **Attempt Limiting**: Failed passcode attempts use escalating cooldown periods.
- **Session Control**: Platform-aware authentication using `X-Platform: mobile`.
- **Password Recovery**: Forgot-passcode workflow with reset-link email support.
- **Resend Protection**: Countdown-based protection for reset-link requests.
- **Protected Navigation**: Route guards prevent unauthorized access to protected application areas.

### ⚙️ Configuration & Environment Management

Rexone Mobile supports environment-specific configuration.

Environment configuration can be separated into:

- `.env.dev`
- `.env.uat`
- `.env.prod`

Configuration values such as API endpoints, application metadata, and Google authentication credentials are loaded through the application's configuration layer.

This allows the same application codebase to be used across development, UAT, and production environments without hardcoding environment-specific values.

## 🛠 Built With

### Tech Stack

| Technology             | Purpose                                                |
| ---------------------- | ------------------------------------------------------ |
| **Flutter**            | Cross-platform mobile application framework            |
| **Dart**               | Application programming language                       |
| **GetX**               | State management, navigation, and dependency injection |
| **GetStorage**         | Local persistent storage                               |
| **Google Sign-In**     | Google authentication                                  |
| **Pin Code Fields**    | Six-digit passcode input                               |
| **Flutter ScreenUtil** | Responsive screen scaling                              |
| **Flutter Dotenv**     | Environment configuration                              |
| **Package Info Plus**  | Application version information                        |
| **Rexone Core API**    | Backend API and application services                   |

## 💻 Getting Started

To get a local copy up and running, follow these steps.

### Prerequisites

In order to run this project you need:

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio or VS Code
- Android Emulator or physical Android device
- iOS Simulator or physical iOS device for iOS development
- CocoaPods for iOS development

Check your Flutter installation:

```sh
  flutter --version
```

Check the available development environments:

```sh
  flutter doctor
```

### Setup

Clone this repository:

```sh
  git clone git@github.com:rex-9/rexone-mobile.git
```

Enter the project directory:

```sh
  cd rexone-mobile
```

Install Flutter dependencies:

```sh
flutter pub get

# Configure Firebase (for analytics)
# Add google-services.json (Android) / GoogleService-Info.plist (iOS)

# Run the app
flutter run
```

### Environment Variables

Create the required environment files in the project root.

For development:

```env
APP_NAME=Rexone
APP_VERSION=1.0.0
GOOGLE_SERVER_CLIENT_ID=your_client_id.apps.googleusercontent.com
API_BASE_URL=http://10.0.2.2:3000
```

The application supports environment-specific files such as:

```text
.env.dev
.env.uat
.env.prod
```

Add the environment files to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - .env.dev
    - .env.uat
    - .env.prod
```

> Do not commit secrets, private credentials, or sensitive production configuration to the repository.

### Google Sign-In Configuration

#### Android

Add the Google services configuration file:

```text
android/app/google-services.json
```

Configure the required:

- SHA-1 fingerprint
- SHA-256 fingerprint
- Google OAuth client configuration

#### iOS

Add the Google services configuration file:

```text
ios/Runner/GoogleService-Info.plist
```

Configure the required URL schemes in:

```text
ios/Runner/Info.plist
```

### Run

Run the application using the development environment:

````sh
flutter run --dart-define=APP_ENV=.env.dev

For UAT:

```sh
flutter run --dart-define=APP_ENV=.env.uat
````

For production:

```sh
flutter run --dart-define=APP_ENV=.env.prod
```

The configured `API_BASE_URL` determines which Rexone Core environment the application communicates with.

## 📁 Project Structure

```text
lib/
├── bindings/             # Dependency injection
│   └── initial_binding.dart
├── config/               # Application configuration
│   ├── app_config.dart
│   └── config.dart
├── constants/            # Application constants and keys
│   ├── app_constants.dart
│   ├── http_status.dart
│   └── locale_constants.dart
├── controllers/          # GetX controllers and business logic
│   ├── auth_controller.dart
│   └── settings_controller.dart
├── design/               # 🎨 Centralized design system
│   ├── components/       # Reusable UI components
│   ├── elements/         # Design tokens
│   ├── extensions/       # Theme-aware extensions
│   └── design.dart       # Single design-system entry point
├── helpers/              # Utility helpers
│   └── flag_helper.dart
├── locales/              # Internationalization
│   └── app_translations.dart
├── models/               # Application and API models
│   ├── api_response.dart
│   └── user_model.dart
├── pages/                # Application screens
│   ├── auth_page.dart
│   ├── home_page.dart
│   ├── settings_page.dart
│   └── splash_page.dart
├── routes/               # Navigation and route configuration
│   ├── app_routes.dart
│   ├── route_guard.dart
│   └── server_routes.dart
└── services/             # API and application services
    ├── api_service.dart
    ├── auth_service.dart
    ├── auth_service_impl.dart
    └── storage_service.dart
```

## 📂 Configuration & Constants

### Config

Application configuration is centralized under:

```text
lib/config/
```

Example:

```dart
import 'package:rexone_mobile/config/config.dart';

// Application configuration
AppConfig().googleServerClientIdKey
AppConfig().apiBaseUrl
```

This keeps environment-specific values away from application logic.

### Constants

Application constants are centralized under:

```text
lib/constants/
```

Example:

```dart
import 'package:rexone_mobile/constants/constants.dart';

// Application constants
Constants.app.name
Constants.app.version

// Locale keys
Constants.locale.welcomeTitle
Constants.locale.signIn
Constants.locale.error
```

### HTTP Status Codes

HTTP status codes are centralized to avoid magic numbers:

```dart
if (response.statusCode == HttpStatus.unauthorized) {
  // Handle unauthorized
}
```

Status helpers can be used when appropriate:

```dart
if (HttpStatusMap.isSuccess(response.statusCode)) {
  // Success!
}
```

Common status constants include:

```dart
HttpStatus.ok                 // 200
HttpStatus.unauthorized       // 401
HttpStatus.tooManyRequests    // 429
```

### Routes

Application navigation and server endpoints are centralized under:

```text
lib/routes/
```

Application navigation:

```dart
import 'package:rexone_mobile/routes/routes.dart';

AppRoutes.toHome();
AppRoutes.toSettings();
AppRoutes.toAuth();
```

Server endpoints:

```dart
ServerRoutes.baseUrl
ServerRoutes.peekUser
ServerRoutes.signIn
```

Keeping routes centralized prevents hardcoded navigation paths and API endpoints from spreading throughout the application.

## 🧪 Testing

Run unit and widget tests:

```sh
flutter test
```

Run integration tests:

```sh
flutter test integration_test/
```

Before creating a production build, ensure the complete test suite passes successfully.

## 📊 Analytics Implementation

### Android APK

```sh
flutter build apk --release
```

### Android App Bundle

```sh
flutter build appbundle --release
```

### iOS

```sh
flutter build ios --release
```

### Web

```sh
flutter build web --release
```

> Production builds should use the appropriate production environment configuration and credentials.

## 📦 Dependencies

| Package              | Purpose                                                |
| -------------------- | ------------------------------------------------------ |
| `get`                | State management, navigation, and dependency injection |
| `get_storage`        | Persistent local storage                               |
| `google_sign_in`     | Google authentication                                  |
| `pin_code_fields`    | Six-digit passcode input                               |
| `flutter_screenutil` | Responsive UI scaling                                  |
| `package_info_plus`  | Application version information                        |
| `flutter_dotenv`     | Environment-specific configuration                     |

# ☕ Support

If you like this project, please consider giving it a star on GitHub and buying me a coffee to support its development: 🌟

[![GitHub Stars](https://img.shields.io/github/stars/rex-9/rexone-mobile.svg?style=social&label=Star)](https://github.com/rex-9/rexone-mobile)

<!-- <div align="center">
  <a href="https://buymeacoffee.com/rex9" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" >
  </a>
</div> -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 👤 Author

**Rex (Rex9)**

- GitHub: [@rex-9](https://github.com/rex-9)
- Portfolio: [rex9.vercel.app](https://rex9.vercel.app)
- Linkedin: [rex9](https://www.linkedin.com/in/rex9/)

_Built with ❤️ by Rex9_
