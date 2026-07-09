## 🔧 Environment Configuration

### Launch Configurations (`.vscode/launch.json`)

```json
{
  "configurations": [
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define-from-file=.env.dev"]
    },
    {
      "name": "UAT",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define-from-file=.env.uat"]
    },
    {
      "name": "Prod",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define-from-file=.env.prod"]
    }
  ]
}
```

### Environment Files

Create environment-specific `.env` files in the project root:

#### `.env.dev` (Development)

```env
# ============================================================
# MERITBOX MOBILE - DEVELOPMENT
# ============================================================

# Google OAuth 2.0 - Server Client ID (Dev)
GOOGLE_SERVER_CLIENT_ID=your_dev_client_id.apps.googleusercontent.com

# API Base URL - Local Rails server
API_BASE_URL=http://10.0.2.2:3000
```

#### `.env.uat` (User Acceptance Testing)

```env
# ============================================================
# MERITBOX MOBILE - UAT
# ============================================================

# Google OAuth 2.0 - Server Client ID (UAT)
GOOGLE_SERVER_CLIENT_ID=your_uat_client_id.apps.googleusercontent.com

# API Base URL - UAT Server
API_BASE_URL=https://uat-api.meritbox.me
```

#### `.env.prod` (Production)

```env
# ============================================================
# MERITBOX MOBILE - PRODUCTION
# ============================================================

# Google OAuth 2.0 - Server Client ID (Production)
GOOGLE_SERVER_CLIENT_ID=your_prod_client_id.apps.googleusercontent.com

# API Base URL - Production Server
API_BASE_URL=https://api.meritbox.me
```

### App Configuration

```dart
// lib/config/app_config.dart
import 'package:meritbox_mobile/constants/constants.dart';

class AppConfig {
  const AppConfig();

  String get apiBaseUrlKey =>
      String.fromEnvironment(Constants.app.apiBaseUrlKey);

  String get googleServerClientIdKey =>
      String.fromEnvironment(Constants.app.googleServerClientIdKey);
}
```

### Constants

```dart
// lib/constants/app_constants.dart
class AppConstants {
  const AppConstants();

  String get name => 'Meritbox';
  String get version => '1.0.0';

  // Environment keys
  String get apiBaseUrlKey => 'API_BASE_URL';
  String get googleServerClientIdKey => 'GOOGLE_SERVER_CLIENT_ID';
}
```

### Usage in Controllers

```dart
// lib/controllers/auth_controller.dart
final AppConfig _config = AppConfig();

// Use in Google Sign-In
await signIn.initialize(
  serverClientId: _config.googleServerClientIdKey,
);

// Use for API calls
// apiService.baseUrl = _config.apiBaseUrlKey;
```

### Platform-Specific API URLs

| Platform         | API Base URL (Dev)            |
| ---------------- | ----------------------------- |
| Android Emulator | `http://10.0.2.2:3000`        |
| iOS Simulator    | `http://localhost:3000`       |
| Physical Device  | `http://your-ip-address:3000` |
| UAT              | `https://uat-api.meritbox.me` |
| Production       | `https://api.meritbox.me`     |

### Adding `.env` files to `.gitignore`

```gitignore
# Environment variables (never commit these!)
.env
.env.dev
.env.uat
.env.prod
.env.local

# Example file (commit this instead)
.env.example
```

### Example Template (`.env.example`)

```env
# ============================================================
# MERITBOX MOBILE - ENVIRONMENT VARIABLES (TEMPLATE)
# ============================================================
# Copy this to .env.dev, .env.uat, or .env.prod and fill in values
# NEVER commit actual .env files to version control!

# Google OAuth 2.0 - Server Client ID
# Get from: Google Cloud Console > Credentials
GOOGLE_SERVER_CLIENT_ID=your_client_id.apps.googleusercontent.com

# API Base URL
# Dev: http://10.0.2.2:3000 (Android) or http://localhost:3000 (iOS)
# UAT: https://uat-api.meritbox.me
# Prod: https://api.meritbox.me
API_BASE_URL=http://localhost:3000
```

### Switching Environments

1. **VS Code**: Select the desired configuration from the Run & Debug dropdown (Dev / UAT / Prod)
2. **Command Line**:

   ```bash
   # Dev
   flutter run --dart-define-from-file=.env.dev

   # UAT
   flutter run --dart-define-from-file=.env.uat

   # Prod
   flutter run --dart-define-from-file=.env.prod
   ```

---

## 🔐 Google Sign-In Setup

### 1. Get Server Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services > Credentials**
4. Create or select an OAuth 2.0 Client ID
5. Copy the **Client ID** (use the Web/Server type)
6. Add to `.env.dev`, `.env.uat`, or `.env.prod` as `GOOGLE_SERVER_CLIENT_ID`

### 2. Android Setup

Add `google-services.json` to `android/app/`

```gradle
// android/app/build.gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

### 3. iOS Setup

Add `GoogleService-Info.plist` to `ios/Runner/`

```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```
