# Auth Service Mobile

A production-grade Flutter mobile application with enterprise-level architecture, multi-platform support, and comprehensive feature set. Built with clean GetX architecture, atomic design system, and seamless backend integration.

---

## 🎯 Overview

**Auth Service Mobile** is the mobile companion to the Meritbox ecosystem, delivering a secure, responsive, and feature-rich authentication experience. Built with scalability and maintainability in mind, it serves as a reference implementation for modern Flutter applications with complex authentication flows, real-time updates, and robust error handling.

---

## 🚀 Core Capabilities

### 🏗️ Architecture & Design Patterns

- **GetX MVC Pattern**: Clean separation of concerns with reactive state management
- **Interface + Implementation**: Service abstraction for easy testing and swapping
- **Dependency Injection**: Centralized binding with GetX's built-in DI
- **Repository Pattern**: Data layer abstraction for API and local storage
- **Route Guard System**: Protected routes with automatic redirection
- **Singleton Services**: Efficient resource management

### 🔐 Advanced Authentication System

- **Dual-Factor Authentication**: Email + 6-digit passcode with intelligent validation
- **Smart User Detection**: Automatic recognition of existing vs. new users
- **Google OAuth Integration**: Seamless social authentication with platform-specific configuration
- **Session Management**: Single active session enforcement with `X-Platform: mobile` header
- **Adaptive Security**: Passcode attempt tracking with progressive cooldown (30s → 60s → 120s)
- **Self-Service Account Recovery**: Forgot passcode with email reset-link and resend countdown

### 🎨 Enterprise-Grade Design System

- **Atomic Design Architecture**:
  - **Atoms**: Design tokens (colors, typography, spacing)
  - **Molecules**: Component combinations (form groups, cards)
  - **Organisms**: Complex components (auth forms, headers)
  - **Templates**: Page layouts with consistent structure
- **Theme-Aware Components**: Automatic light/dark mode adaptation
- **Responsive Everywhere**: ScreenUtil-powered adaptive layouts for all device sizes
- **Consistent Design Language**: Single source of truth for all UI elements

### 📊 Analytics & Intelligence

- **Google Analytics 4 Integration**: Full GA4 implementation for comprehensive insights
- **User Behavior Tracking**: Screen views, navigation flows, and interaction events
- **Funnel Analysis**: Track user journey through authentication flows
- **Conversion Metrics**: Measure success rates and drop-off points
- **Geographic Insights**: Location-based user distribution and demographics
- **Engagement Scoring**: Real-time user engagement metrics
- **Custom Event Tracking**: Business-specific analytics events
- **Crash Reporting**: Optional Firebase Crashlytics integration

### 🌍 Internationalization

- **Multi-Language Support**: English, Español, Myanmar (မြန်မာ) with more to come
- **Persisted User Preferences**: Language selection survives app restarts
- **RTL/LTR Support**: Ready for bidirectional language support
- **Localization-First**: All UI text sourced from centralized translations

### 🛡️ Security Features

- **JWT Token Management**: Secure storage and automatic refresh
- **Credential Encryption**: GetStorage for secure local data persistence
- **Input Validation**: Client-side validation with immediate feedback
- **Platform-Specific Configuration**: Separate client IDs for Android, iOS, Web
- **Rate Limiting**: Built-in cooldown for failed authentication attempts
- **Session Isolation**: One active session per platform

### 📱 Platform Support

- **Cross-Platform**: iOS, Android, and Web support
- **Native Features**: Full camera, biometric, and push notification support
- **Platform-Specific UI**: Native-looking components for each platform
- **Responsive Web**: Desktop and mobile-optimized web experience

### 🚦 State Management

- **Reactive Programming**: GetX's reactive state management
- **Controller-Based Logic**: All business logic in GetX controllers
- **Async/Await Patterns**: Clean asynchronous code with error handling
- **Debounced Inputs**: Reduced API calls with input debouncing
- **Optimistic Updates**: Immediate UI feedback for better UX

---

## 📁 Architecture Deep Dive

### Project Structure (Clean Architecture)

```

lib/
├── design/ # 🎨 Atomic Design System (Single Source of Truth)
│ ├── atoms/ # Design tokens: colors, typography, spacing
│ ├── molecules/ # Component combinations: form fields, cards
│ ├── organisms/ # Complex components: auth forms, headers
│ └── tokens/ # Design system values
├── services/ # 🔌 Service Layer (Interfaces + Implementations)
│ ├── auth_service.dart # Interface definition
│ ├── auth_service_impl.dart # Implementation
│ ├── api_service.dart # HTTP client with interceptors
│ └── storage_service.dart # Local storage abstraction
├── controllers/ # 🧠 Business Logic (GetX Controllers)
│ ├── auth_controller.dart # Authentication logic
│ └── settings_controller.dart # Theme/locale management
├── bindings/ # 🔗 Dependency Injection
│ └── initial_binding.dart # Service registration
├── routes/ # 🗺️ Navigation + Route Guards
├── pages/ # 📱 UI Screens (Templates)
├── models/ # 📊 Data Models with serialization
├── helpers/ # 🔧 Utility Functions
├── config/ # ⚙️ App Configuration
├── constants/ # 📌 App Constants (No Magic Numbers)
└── locales/ # 🌍 Internationalization

```

### Design System Structure

```

design/
├── tokens/
│ ├── colors.dart # Light/Dark theme colors
│ ├── typography.dart # Text styles
│ ├── spacing.dart # Sizing & spacing tokens
│ └── shadows.dart # Elevation tokens
├── atoms/
│ ├── app_text.dart # Typography components
│ ├── app_button.dart # Button variants
│ └── app_icon.dart # Icon system
├── molecules/
│ ├── app_card.dart # Card components
│ ├── app_form.dart # Form components
│ └── app_input.dart # Input fields
├── organisms/
│ ├── auth_form.dart # Authentication form
│ └── header.dart # Page headers
└── templates/
├── auth_template.dart # Authentication layout
└── settings_template.dart # Settings layout

```

---

## 🚦 Getting Started

### Prerequisites

- Flutter SDK >=3.0.0
- Dart >=3.0.0
- iOS Simulator / Android Emulator
- Firebase Account (for analytics)

### Installation

```bash
# Clone the repository
git clone https://github.com/rex-9/auth_service_mobile.git
cd auth_service_mobile

# Install dependencies
flutter pub get

# Configure Firebase (for analytics)
# Add google-services.json (Android) / GoogleService-Info.plist (iOS)

# Run the app
flutter run
```

### Environment Configuration

```env
# .env.dev
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

### Build Commands

```bash
# Development
flutter run --dart-define=APP_ENV=.env.dev

# Testing
flutter test

# Production Build
flutter build apk --release     # Android
flutter build ios --release     # iOS
flutter build web --release     # Web
```

---

## 📊 Analytics Implementation

### Screen Tracking

- Automatic screen view tracking with GA4
- Custom screen naming for better analysis
- Session duration tracking

### Event Tracking

```dart
// Auth events
analytics.logAuthStart(method: 'email');
analytics.logAuthComplete(method: 'email', success: true);
analytics.logAuthFailed(method: 'email', error: 'Invalid passcode');

// User events
analytics.logUserRegistration(userType: 'new');
analytics.logUserLogin(userType: 'existing');

// Engagement events
analytics.logScreenView(screenName: 'home');
analytics.logButtonClick(buttonName: 'sign_in');
```

---

## 🔐 Security Features in Detail

### Passcode Attempt Management

- Track consecutive failed attempts per user
- Progressive cooldown: 30s → 60s → 120s
- Reset success counter after successful login
- Persistent storage across app sessions

---

## 🏆 Key Achievements

1. **Atomic Design System**: Enterprise-grade UI consistency across all screens
2. **Multi-Platform Support**: Single codebase for iOS, Android, and Web
3. **Analytics-Ready**: Full Google Analytics 4 implementation with custom events
4. **Security-First Architecture**: JWT, session management, rate limiting, cooldowns
5. **Internationalization Ready**: 3+ languages with RTL support
6. **State Management Excellence**: GetX pattern with reactive programming
7. **Design Pattern Mastery**: Interface segregation, dependency injection, repository pattern
8. **Performance Optimized**: Debounced inputs, optimistic updates, lazy loading
9. **Error Handling**: Comprehensive error handling with user-friendly messages
10. **Developer Experience**: Clean code, consistent naming, thorough documentation

---

## 🛠️ Technology Stack

### Core

- **Flutter**: UI framework
- **Dart**: Programming language
- **GetX**: State management, navigation, DI
- **GetStorage**: Local persistence

### Authentication

- **google_sign_in**: Google OAuth
- **JWT**: Token management

### Analytics

- **Firebase Core**: Firebase services
- **Firebase Analytics**: Google Analytics 4
- **Firebase Crashlytics**: Crash reporting (optional)

### UI/UX

- **pin_code_fields**: OTP/passcode input
- **flutter_screenutil**: Responsive design
- **Material Design 3**: Modern UI

### Utilities

- **package_info_plus**: App version info
- **flutter_dotenv**: Environment variables

---

## 🔗 Related Repositories

- **Backend API**: [Meritbox API](https://github.com/rex-9/auth-service-api) - Rails backend with all integrated services
- **Web Frontend**: [Meritbox Web](https://github.com/rex-9/auth-service-web) - React + TypeScript web app
- **Mobile App**: [Auth Service Mobile](https://github.com/rex-9/auth_service_mobile) - You are here! 🎯

---

## 🤝 Contributing

This is a personal project, but feedback and suggestions are welcome! Feel free to open issues or submit PRs.

---

## 📄 License

This project is proprietary and confidential. All rights reserved.

---

## 🙏 Acknowledgments

- Flutter & Dart teams for the amazing framework
- GetX team for excellent state management solution
- Firebase team for analytics and infrastructure

---

## 👤 Author

**Rex (Rex9)**

- 🌐 GitHub: [@rex-9](https://github.com/rex-9)
- 📱 Portfolio: [rex9.vercel.app](https://rex9.vercel.app)
- 💼 LinkedIn: [rex9](https://www.linkedin.com/in/rex9/)

---

**Built with ❤️ by Rex9 | A showcase of enterprise Flutter development**

---

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue.svg" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Dart-3.0+-blue.svg" alt="Dart Version">
  <img src="https://img.shields.io/badge/Architecture-Clean-ff69b4.svg" alt="Architecture">
  <img src="https://img.shields.io/badge/Design-Atomic-00b894.svg" alt="Design System">
  <img src="https://img.shields.io/badge/Analytics-GA4-ff6b6b.svg" alt="Analytics">
  <img src="https://img.shields.io/badge/Security-Enterprise-6c5ce7.svg" alt="Security">
</p>

<p align="right">(<a href="#top">back to top</a>)</p>
