# Auth Service Mobile — Agent Instructions

## Stack

Flutter 3.11+, GetX, ScreenUtil, flutter_dotenv, Firebase Analytics, OneSignal, Google Sign-In.

## Architecture rules

1. **Pages = UI only.** Extend `GetView<XController>`. No API calls in pages.
2. **Business logic** lives in `lib/controllers/`.
3. **API / storage / integrations** live in `lib/services/`.
4. Use the **`AuthService` interface** in controllers — never `AuthServiceImpl` directly.
5. Register new services and controllers in `lib/bindings/initial_binding.dart`.
6. Add routes in `lib/routes/app_routes.dart`. Use `RouteGuard` for auth-required screens.
7. Put API paths in `lib/routes/server_routes.dart` — no hardcoded endpoint strings.
8. Env key names go in `lib/constants/app.constants.dart`; read values via `AppConfig`, not `dotenv` in pages/controllers.

## UI rules (mandatory)

- Import `package:auth_service_mobile/design/design.dart`
- Use `context.colors.*` and `context.typo.*` for theme-aware styling
- Use `Design.spacing.*`, `Design.icons.*`, `Design.theme.*` for tokens
- Use design components: `AppPage`, `AppButton`, `AppInputField`, `AppPasscodeField`, `AppSnackbar`, `AppDialog`
- Never hardcode colors, spacing, or text styles
- All user-facing text: `Constants.locale.*.tr` (add keys in `locale.constants.dart` + `app_translations.dart`)
- Responsive layout: `ResponsiveHelper.isMobile(context)` — width &lt; 760px is mobile

## Responsive pattern

```dart
final isMobile = ResponsiveHelper.isMobile(context);

Center(
  child: SizedBox(
    width: isMobile ? double.infinity : 200.sp,
    child: Column(/* ... */),
  ),
)
```

## File naming

- snake_case with dot suffix: `auth.controller.dart`, `app.config.dart`, `user.model.dart`
- Barrel exports: `controllers.dart`, `services.dart`, `pages.dart`, `design.dart`

## Page feature folders

```
lib/pages/<feature>/
├── <feature>.page.dart       # e.g. product.page.dart → ProductPage
├── <feature>s.dart           # barrel export, e.g. products.dart
└── components/               # optional — page-only widgets
    └── products_card.dart
```

Example: `lib/pages/products/product.page.dart`, barrel `products.dart`.

## Component placement rule

| Location | Use when |
|----------|----------|
| `lib/design/components/` | App-wide reusable UI (`AppButton`, `AppPage`, `AppInputField`, …) |
| `lib/pages/<feature>/components/` | Widget used by **one feature/page only** (e.g. `ProductsCard`) |

Page-local components still import `design/design.dart` for tokens. Do **not** export page-local components from `design/components/components.dart`.

## API response models

Use feature-specific response classes with existing `parseResponse` when `body.data` is a **Map**:

```dart
// data: { "products": [...] }
return _api.parseResponse<ProductsResponse>(
  response,
  (data) => ProductsResponse.fromJson(data),
);
```

Same pattern as `AuthResponse`, `SignInResponse`. Controllers depend on **service interfaces** (`PaymentService`), never `PaymentServiceImpl`.

## Adding a new screen

1. Create `lib/pages/<feature>/<feature>.page.dart`
2. Add `lib/pages/<feature>/<feature>s.dart` barrel
3. If page-only widgets needed → `lib/pages/<feature>/components/`
4. Export barrel in `lib/pages/pages.dart`
5. Add route constant + `GetPage` in `app_routes.dart`
6. Add navigation helper `AppRoutes.toX()`
7. Add locale keys in `locale.constants.dart` and `app_translations.dart`
8. If auth required, add `middlewares: [RouteGuard()]`

## Adding a new service

1. Define abstract class extending `GetxService` in `lib/services/`
2. Implement in `*.impl.dart` or sibling file
3. Export in `services.dart`
4. Register in `initial_binding.dart`: `Get.put<FooService>(FooServiceImpl(), permanent: true)`

Controllers use `Get.find<FooService>()`, never the `*Impl` class.

## Auth flow reference

- Entry: `AuthPage` → email or Google
- Existing user: passcode sign-in
- New user: create passcode → confirm → profile info → email OTP
- On success: store session → OneSignal sync → request push permission → `AppRoutes.toHome()`
- Logout: clear session + OneSignal + Google sign-out if applicable

## Key files

| Task | File |
|------|------|
| App entry | `lib/main.dart` |
| DI | `lib/bindings/initial_binding.dart` |
| Routes | `lib/routes/app_routes.dart` |
| Route guard | `lib/routes/route_guard.dart` |
| API paths | `lib/routes/server_routes.dart` |
| Auth logic | `lib/controllers/auth.controller.dart` |
| Settings (theme/locale) | `lib/controllers/settings.controller.dart` |
| Env config | `lib/config/app.config.dart` |
| Translations | `lib/locales/app_translations.dart` |
| Design system docs | `lib/design/README.md` |

## iOS / native notes

- Bundle ID: `com.rex9.auth`
- Firebase: use Flutter plugins (CocoaPods) only — do not add Firebase via Xcode SPM
- OneSignal NSE: separate top-level Podfile target; do not nest inside `Runner`
- `GoogleService-Info.plist` must be in Xcode Copy Bundle Resources

## Do not

- Commit `.env.dev`, `.env.uat`, `.env.prod` (secrets)
- Hardcode API URLs, colors, spacing, or text styles
- Call `AuthServiceImpl` from controllers
- Put business logic in pages
- Use raw `Get.toNamed('/path')` — use `AppRoutes` helpers
