# auth-service-mobile

<a name="readme-top"></a>

<div align="center">
  <h3><b>Auth Service Mobile</b></h3>
</div>

# 📖 Auth Service Mobile <a name="about-project"></a>

**Auth Service Mobile** is the Flutter client for the Auth Service platform, porting the web auth flow to mobile while keeping the same architecture and API contract. Companion repositories: [Auth Service Web](https://github.com/rex-9/auth-service-web) (client) and [Auth Service Api](https://github.com/rex-9/auth-service-api) (server).

## 🚀 Featuring!

### 🔐 Authentication & Security

- **Email-first auth flow**: One email field decides sign in vs sign up (`/users/peek`).
- **6-digit passcode**: Passcode boxes with auto-submit, create + confirm on signup.
- **Email confirmation**: 6-digit OTP with a 30s resend countdown.
- **Google Authentication**: Google SSO; new Google accounts set a passcode via a challenge token.
- **Forgot & reset passcode**: Email reset link with a 60s resend countdown.
- **Attempt limiting**: Per-email attempt tracking with escalating cooldowns (30s/60s/120s fallback), synced with server retry metadata.
- **One session per platform**: Sends `X-Platform: mobile`; a replaced session signs the user out with a message.

### 🏗️ Design Patterns & Architecture

The `lib/` layout mirrors the web `src/` layout one-to-one:

| Web (`src/`) | Mobile (`lib/`) |
|---|---|
| `AppConfig.tsx` | `app_config.dart` |
| `AppRoutes.ts` | `app_routes.dart` |
| `models/` | `models/` |
| `services/` (axios, auth, user, atomStorage) | `services/` (http, auth, user, storage) |
| `controllers/` | `controllers/` |
| `contexts/` (React Context) | `contexts/` (`ChangeNotifier` + provider) |
| `reducers/googleSso.reducer.ts` | `reducers/google_sso_reducer.dart` |
| `design/atoms` + `design/molecules` + `design/pages` | `design/atoms` + `design/molecules` + `design/pages` |
| `routes/` (RouteManager + guards) | `routes/route_manager.dart` |
| `utils/useCountdown.util.ts` | `utils/countdown.dart` |
| `locales/` | `locales/` |

## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

<details>
  <summary>Mobile</summary>
  <ul>
    <li><a href="https://flutter.dev/">Flutter</a> / <a href="https://dart.dev/">Dart</a></li>
    <li><a href="https://pub.dev/packages/provider">provider</a> (state management)</li>
    <li><a href="https://pub.dev/packages/http">http</a> (API client)</li>
    <li><a href="https://pub.dev/packages/shared_preferences">shared_preferences</a> (persistent storage)</li>
    <li><a href="https://pub.dev/packages/google_sign_in">google_sign_in</a> (Google SSO)</li>
  </ul>
</details>

<details>
  <summary>Server</summary>
  <ul>
    <li><a href="https://rubyonrails.org/">Ruby on Rails</a> (<a href="https://github.com/rex-9/auth-service-api">auth-service-api</a>)</li>
  </ul>
</details>

## 💻 Getting Started <a name="getting-started"></a>

### Prerequisites

Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and check:

```sh
flutter doctor
```

Run the [Auth Service Api](https://github.com/rex-9/auth-service-api) locally (defaults to `http://localhost:3000`).

### Setup

```sh
cd my-folder
git clone git@github.com:rex-9/auth-service-mobile.git
cd auth-service-mobile
flutter pub get
```

### Run

```sh
flutter run
```

Point the app at a different backend or Google client id with dart-defines:

```sh
flutter run \
  --dart-define=SERVER_BASE_URL=http://192.168.1.10:3000 \
  --dart-define=GOOGLE_CLIENT_ID=<your-client-id>.apps.googleusercontent.com
```

> **Note (Android emulator):** use `--dart-define=SERVER_BASE_URL=http://10.0.2.2:3000` to reach a backend on your host machine.

> **Google SSO platform setup:** `google_sign_in` needs per-platform configuration — an OAuth client + SHA-1 fingerprint for Android, and a reversed client id URL scheme in `ios/Runner/Info.plist` for iOS. See the [google_sign_in docs](https://pub.dev/packages/google_sign_in).

### Test

```sh
flutter test
```

### Lint

```sh
flutter analyze
```

# ☕ Support <a name="support"></a>

If you like this project, please consider giving it a star on GitHub and buying me a coffee to support its development: 🌟

[![GitHub Stars](https://img.shields.io/github/stars/rex-9/auth-service-mobile.svg?style=social&label=Star)](https://github.com/rex-9/auth-service-mobile)

<div align="center">
  <a href="https://buymeacoffee.com/rex9" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" >
  </a>
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>
