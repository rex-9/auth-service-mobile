# Meritbox Mobile App

A modern Flutter mobile application for Meritbox platform, featuring secure 6-digit passcode authentication, Google Sign-In, and clean GetX architecture.

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
  - Light/Dark theme support
  - Responsive design with ScreenUtil
  - Smooth animations and transitions

- **Security**
  - JWT token-based authentication
  - Secure local storage with GetStorage
  - 6-digit passcode validation

## 🏗️ Project Structure

```
lib/
├── bindings/           # Dependency injection
│   └── initial_binding.dart
├── controllers/        # Business logic
│   └── auth_controller.dart
├── core/              # Core utilities
│   ├── constants/
│   └── theme/
├── models/            # Data models
│   ├── user_model.dart
│   └── api_response.dart
├── pages/             # UI screens
│   ├── auth_page.dart
│   ├── signin_passcode_page.dart
│   ├── signup_passcode_page.dart
│   ├── signup_info_page.dart
│   ├── verify_email_page.dart
│   └── home_page.dart
├── routes/            # Navigation
│   ├── app_routes.dart
│   └── server_routes.dart
├── services/          # API and business services
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── storage_service.dart
└── widgets/           # Reusable components
    ├── custom_button.dart
    └── custom_textfield.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart (>=3.0.0)
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

Update the base URL in `lib/routes/server_routes.dart`:

```dart
static const String baseUrl = 'https://your-api-server.com'; // Replace with your backend URL
```

4. **Configure Google Sign-In**

#### Android

- Add your `google-services.json` to `android/app/`
- Configure SHA-1 and SHA-256 fingerprints in Google Cloud Console

#### iOS

- Add `GoogleService-Info.plist` to `ios/Runner/`
- Configure URL schemes in `Info.plist`

#### Web

- Configure OAuth 2.0 Client ID in Google Cloud Console
- Update `web/index.html` with your client ID

5. **Run the app**

```bash
flutter run
```

## 🔧 Configuration

### Environment Setup

Create `.env` file (optional for different environments):

```env
API_BASE_URL=https://your-api-server.com
GOOGLE_CLIENT_ID=your_google_client_id
```

### Backend API Endpoints

Make sure your backend has these endpoints configured:

| Endpoint                     | Method | Description            |
| ---------------------------- | ------ | ---------------------- |
| `/users/peek`                | GET    | Check if user exists   |
| `/signin`                    | POST   | Email/Password sign in |
| `/signin/token`              | POST   | Token-based sign in    |
| `/signin/google`             | POST   | Google Sign-In         |
| `/signup`                    | POST   | User registration      |
| `/confirmation/send_code`    | POST   | Send verification code |
| `/confirmation/confirm_code` | POST   | Verify email code      |
| `/password/forgot`           | POST   | Forgot password        |
| `/password/reset`            | PUT    | Reset password         |
| `/users/current`             | GET    | Get current user       |
| `/signout`                   | DELETE | Sign out               |

## 🎨 Design System

### Color Palette

- **Primary**: Indigo (#6366F1)
- **Secondary**: Violet (#8B5CF6)
- **Success**: Emerald (#10B981)
- **Error**: Red (#EF4444)

### Typography

- **Font Family**: Poppins
- **Headlines**: 20-32px, Bold/SemiBold
- **Body**: 12-16px, Regular
- **Buttons**: 14-16px, SemiBold

### Spacing System

- Base unit: 4px
- Screen padding: 20px
- Card padding: 16px
- Button height: 48px

## 📱 App Flow

### Existing User Flow

1. Enter Email → Detected as existing user
2. Enter 6-digit passcode
3. Successful sign in → Redirect to Home

### New User Flow

1. Enter Email → Detected as new user
2. Create 6-digit passcode (confirm twice)
3. Verify email with OTP code
4. Complete profile (Name, Username)
5. Account created → Redirect to Home

### Google Sign-In Flow

1. Tap "Continue with Google"
2. Select Google account
3. Auto-create account or sign in
4. Redirect to Home

## 🛠️ Built With

- **GetX** - State management, navigation, dependency injection
- **GetConnect** - HTTP client
- **GetStorage** - Local storage
- **Google Sign-In** - Social authentication
- **Pin Code Fields** - OTP input
- **ScreenUtil** - Responsive design

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  google_sign_in: ^7.2.0
  pin_code_fields: ^9.0.0
  flutter_screenutil: ^5.9.0
  get_storage: ^2.1.1
  get_connect: ^4.6.6
```

## 🔐 Security

- JWT tokens stored securely using GetStorage
- No sensitive data in URL parameters
- HTTPS enforced in production
- Passcode validated on both client and server
- Automatic sign out on 401 responses

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Generate coverage report
flutter test --coverage
```

## 📱 Building for Production

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS IPA

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is proprietary and confidential.

## 📞 Support

For support, email support@meritbox.com or create an issue in the repository.

## 🎯 Roadmap

- [ ] Biometric authentication (FaceID / Fingerprint)
- [ ] Push notifications
- [ ] Offline mode
- [ ] Social media sharing
- [ ] Dark mode improvements
- [ ] Accessibility enhancements

## 🙏 Acknowledgments

- Flutter team for amazing framework
- GetX team for state management solution
- Google Sign-In team for authentication

---

**Made with ❤️ by Meritbox Team**
