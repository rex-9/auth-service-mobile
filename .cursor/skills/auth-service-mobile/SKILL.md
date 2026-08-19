---
name: auth-service-mobile
description: >-
  Flutter GetX auth app conventions: design system, DI, routes, services,
  responsive layout, Firebase/OneSignal. Use when editing lib/, adding pages,
  auth flows, or UI components in auth-service-mobile.
---

# Auth Service Mobile Skill

## When to use

- Adding or editing pages, controllers, or services in this repo
- Auth, settings, splash, push notifications, or analytics work
- Responsive layout (mobile vs tablet/desktop)
- Navigation, route guards, or API integration

## Design system

Read `lib/design/README.md` for full details. Single import:

```dart
import 'package:auth_service_mobile/design/design.dart';
```

| Use | For |
|-----|-----|
| `context.colors.*` | Theme-aware colors |
| `context.typo.*` | Theme-aware text styles |
| `Design.spacing.*` | Spacing tokens |
| `Design.icons.*` | Icon references |
| `Design.theme.light` / `.dark` | App themes |
| `AppPage` | Screen wrapper with app bar |
| `AppButton` | Primary, secondary, google, icon buttons |
| `AppInputField` | Text inputs with label/error |
| `AppPasscodeField` | 6-digit PIN input |
| `AppSnackbar` | Success/error toasts |

Never hardcode `Colors.*`, raw `TextStyle`, or magic spacing numbers.

## Responsive layout

```dart
import 'package:auth_service_mobile/helpers/helpers.dart';

final isMobile = ResponsiveHelper.isMobile(context); // width < 760

Center(
  child: SizedBox(
    width: isMobile ? double.infinity : 200.sp,
    child: /* form content */,
  ),
)
```

Breakpoints (`lib/helpers/responsive.helper.dart`):

- Mobile: &lt; 760
- Tablet: 760–1279
- Desktop: ≥ 1280

## GetX patterns

**Pages:** extend `GetView<AuthController>` (or relevant controller)

```dart
class MyPage extends GetView<AuthController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Obx(() => Text(controller.someValue.value)),
    );
  }
}
```

**Reactive state:** `.obs` + `Obx(() => ...)`

**Navigation:** use `AppRoutes.toHome()`, `AppRoutes.toAuth()`, etc. — not string literals.

## Service pattern

```dart
abstract class FooService extends GetxService {
  Future<ApiResponse<T>> doSomething();
}

class FooServiceImpl extends FooService {
  final ApiService _api = Get.find<ApiService>();
  // ...
}

// initial_binding.dart:
Get.put<FooService>(FooServiceImpl(), permanent: true);
```

Controllers depend on `FooService`, never `FooServiceImpl`.

## Constants and config

```dart
import 'package:auth_service_mobile/constants/constants.dart';
import 'package:auth_service_mobile/config/config.dart';

Constants.locale.welcomeTitle.tr   // translations
AppConfig.apiBaseUrl               // env values
HttpStatus.unauthorized            // status codes
Constants.analytics.eventSignIn    // analytics events
```

## Auth controller conventions

- Validators: `EmailValidator`, `UsernameValidator`, `FullnameValidator`
- After successful auth: `_storeSession` → OneSignal `syncUser` → `requestPermission` → navigate home
- On logout: `clearUser` for OneSignal, clear storage, `AppRoutes.toAuth()`
- Passcode: 6 digits, attempt limiting with cooldown (30s / 60s / 120s)

## Project layout

```
lib/
├── bindings/initial_binding.dart
├── config/app.config.dart
├── constants/
├── controllers/
├── design/          # import design.dart
├── helpers/
├── locales/
├── models/
├── pages/
├── routes/
└── services/
```

## Checklist for new features

- [ ] Page uses `AppPage` + design system components
- [ ] Strings use `Constants.locale.*.tr`
- [ ] Logic in controller, API in service
- [ ] Route added to `app_routes.dart` with helper method
- [ ] Service registered in `initial_binding.dart` if new
- [ ] Responsive layout considered for tablet/desktop
