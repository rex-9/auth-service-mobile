> [!IMPORTANT]
>
> ### 🏛️ The Foundation Creed
>
> **"Clarity before cleverness. Precision before haste. Simplicity without weakness. Strength without spectacle."**
>
> This document defines the non-negotiable architectural laws and engineering standards for **Rexone Mobile** (`rexone_mobile`). Every developer, agent, and contributor must adhere strictly to these rules. Zero exceptions.

---

## 🎨 1. Design System & Layout Doctrine

### 1.1 Zero Ad-Hoc Widgets Outside `lib/design/`

- **Rule**: NEVER create arbitrary `SizedBox(width: 20)`, hardcoded `EdgeInsets.all(16)`, or inline raw styling.
- Strictly use tokens and elements provided by `lib/design/`:
  - `Design.space.xs`, `Design.space.s`, `Design.space.m`, `Design.space.l`, `Design.space.xl`
  - `Design.radius.s`, `Design.radius.m`, `Design.radius.l`, `Design.radius.full`
  - `Design.typography.*` and semantic text styles.
- Reusable UI elements and components live in `lib/design/elements/` and `lib/design/components/`.

### 1.2 Theme-Aware Styling (Light & Dark Modes)

- **Rule**: NEVER hardcode `Color(0xFF...)` or `Colors.white`/`Colors.black` directly in feature widgets.
- ALWAYS access theme tokens through context extensions:
  - `context.colors.primary`, `context.colors.surface`, `context.colors.background`, `context.colors.textPrimary`
  - `context.typography.titleLarge`, `context.typography.bodyMedium`
- Both **Light** and **Dark** themes adapt automatically.

---

## 🖼️ 2. Distributed Centralized Assets Law

- **Rule**: NEVER store raw media URL strings directly in model entities.
- ALL media (avatars, attachments, covers, cards, audio, video, docs) is managed through the backend's distributed centralized `assets` system (`type`, `storage_key`, `resource_model`, `resource_id`).
- When uploading assets (such as user avatars):
  - Pass `{ type: "avatar", resource_model: "user", resource_id: currentUser?.id }`.
  - Display avatars using the semantic design avatar widgets.

---

## 🏗️ 3. Architecture & Layering (GetX MVCS System Architecture)

### 3.1 Server-Business Logic Authority vs. Client-Business Logic

- **Server-Business Logic in Core**: All primary application business logic (or **server-business logic**)—including authorization rules, access lifecycles, pricing, rate limits, payment processing, AI pipelines, and database integrity—is handled exclusively in `rexone-core`.
- **Zero Server-Business Logic Duplication**: The mobile client MUST NEVER duplicate, re-implement, or re-calculate server-business rules. This prevents writing duplicate business logic across Mobile and Web.
- **Client-Business Logic Focus**: The mobile client strictly limits its logic to **client-business logic** (frontend reactive state management (`.obs`), device interaction orchestration, local form controllers, and UI presentation).

### 3.2 Strict GetX Ecosystem Adherence & Zero Redundant Dependencies

- **GetX as the System Foundation**: The entire mobile architecture is built upon the unified GetX ecosystem (`State Management`, `Dependency Injection`, `Route Management`, `GetStorage`, `GetConnect`).
- **Zero Redundant State / Storage / Navigation Packages**:
  - **NEVER** add or use external state managers (`provider`, `bloc`, `flutter_bloc`, `riverpod`, `mobx`, `redux`).
  - **NEVER** add or use external local storage managers (`shared_preferences`, `hive`, `sqflite`) when `GetStorage` natively provides high-performance persistent key-value and JSON caching.
  - **NEVER** add or use external routing managers (`go_router`, `auto_route`) when GetX navigation (`Get.toNamed`, `Get.offNamed`, `Get.offAllNamed`, `Get.back`) is the system standard.
  - **Strict Dependency Rule**: ONLY introduce third-party packages if GetX is fundamentally incapable of providing the capability (e.g., `google_sign_in`, `onesignal_flutter`, `webview_flutter`, `firebase_core`, `package_info_plus`, `flutter_screenutil`).

### 3.3 Strict 4-Tier MVCS Separation of Concerns

```
Model Layer (lib/models/ & lib/modules/*/data/)
       │  (Typed models, JSON serialization toJson/fromJson, request/response envelopes)
View Layer (lib/pages/ or lib/modules/*/pages/ & views/)
       ↓  (Extends GetView<TController>, triggers actions, renders Obx reactive UI)
Controller Layer (lib/modules/*/controllers/*.controller.dart)
       ↓  (Extends GetxController, orchestrates client-business logic, manages .obs state)
Service Layer (lib/services/ & lib/modules/*/services/*.service.dart)
       ↓  (Extends GetxService, formats request payloads & backend API calls)
Transport Layer (lib/services/api.service.dart)
       ↓  (Extends GetConnect, auto JWT/Platform/Locale headers, _withLoading overlay)
```

- **Views / Pages / Modals (`GetView<TController>`)**:
  - **Mandatory `GetView` Extension**: ALL feature pages, screens, modal dialogs, and bottom sheets MUST extend `GetView<TController>` (or `GetWidget<TController>`).
  - **No `StatelessWidget` / `StatefulWidget` for Feature Screens**: Feature views must never use raw `StatelessWidget` or `StatefulWidget` when a `GetView` with `GetxController` and Get lifecycles (`onInit`, `onReady`, `onClose`) is the architectural standard.
  - **Pure Presentation**: Zero direct API calls, zero server-business logic calculations.
  - **Reactive Rendering**: Listen to observable properties strictly via `Obx(() => ...)` or `GetBuilder<TController>` and invoke controller methods.

- **Controllers (`*.controller.dart`)**:
  - **Mandatory `GetxController` Extension**: Manage observable state variables (`final count = 0.obs;`).
  - **Lean Controller Logic Law**: Controller logic must remain lean and minimal — focused on client-business logic (state reactivity, local UI orchestration, and data mapping). Server-business rules stay in Core.
  - **GetX Lifecycles**: Leverage `onInit()`, `onReady()`, and `onClose()` for initialization, subscriptions, worker listeners (`ever()`, `debounce()`), and resource cleanup (e.g. `TextEditingController.dispose()`).
  - **Workflow & UI Coordination**: Coordinate business flows, trigger GetX UI feedback (`AppSnackbar`, `Get.dialog`, `Get.bottomSheet`), and execute GetX route transitions (`Get.toNamed`, `Get.back`).
  - **Service Interaction**: Call Services (`GetxService`) for backend operations and persistence.

- **Services (`*.service.dart`)**:
  - **Mandatory `GetxService` Extension**: Permanent singleton services that remain in memory throughout the application lifecycle.
  - **Shared Services (`lib/services/`)**: Application-wide infrastructure services used by any controller or background workflow (`api.service.dart`, `socket.service.dart`, `storage.service.dart`, `analytics.service.dart`, `log.service.dart`).
  - **Module Services (`lib/modules/*/services/`)**: Domain-specific network clients (`auth.service.dart`, `ai.service.dart`, `payment.service.dart`, `feedback.service.dart`). Can be injected and utilized across controllers via `Get.find<TService>()` whenever cross-domain access is required.
  - **Zero UI in Services**: NEVER trigger UI dialogs, snackbars, or route navigation inside Services.

- **Transport (`api.service.dart`)**:
  - Extends `GetConnect` with automatic `Authorization: Bearer <token>`, `X-Platform: android|ios`, `X-Locale`, and `Accept-Language` headers.
  - Unified loading overlay via `_withLoading()`.

---

## 🗂️ 4. Constants & Enums Law

### 4.1 Zero Loose String Literals or Magic Numbers

- **Rule**: Every status string, API key, storage key, header, and route MUST be centralized in `lib/constants/`:
  - `app_locales.dart` — Centralized namespaced translation keys (`AppLocales.*`) matching web `AppLocales`.
  - `storage_keys.dart` — Centralized local storage keys (`StorageKeys.*`) matching web `StorageKeys` parity.
  - `app.constants.dart` — Platform headers (`AppConstants.platformAndroid`, `AppConstants.platformIos`, `AppConstants.currentPlatform`).
  - `json_keys.dart` — Centralized API request and response JSON envelope keys (`JsonKeys.*`).
  - `log.constants.dart` — Client telemetry constants (`LogConstants.*`).
  - `enums.dart` — Strongly-typed domain enums (`AuthProvider`, `ChatRole`, `ThemePreference`).
  - `server_routes.dart` — Backend API endpoint paths (`ServerRoutes.*`).
  - `app_routes.dart` — Client navigation route strings (`AppRoutes.*`).
  - `asset_keys.dart` — Asset model constants (`AssetKeys.*`).
- Exported cleanly from `lib/constants/constants.dart`.

### 4.2 Cross-Platform Storage Keys Parity Law

- **Rule**: All common local storage keys MUST match `rexone-web` `StorageKeys` exactly (`'token'`, `'user'`, `'locale'`, `'theme'`).
- **Rule**: NEVER pass loose string literals to `GetStorage()` or secure storage. Always use `StorageKeys.*`.

---

## 🔐 5. RBAC & Client-Side Authorization Law

The mobile RBAC system strictly synchronizes with the backend's three-tier administrative hierarchy:

### 5.1 Three-Tier Administrative Hierarchy

1. **`super_admin` (Full System Authority)**:
   - Full access across all administration areas, features, and settings.
2. **`admin` (Standard Administrator)**:
   - Full operational access across domain resources (`feedbacks`, `payments`, `ai`, `assets`, `logs`, `notifications`).
   - **Strict Restriction**: Restricted from `users` and `iam`.
3. **Partial Admin (`*_admin` Suffix Naming Law)**:
   - Users with base `user` role plus specific `*_admin` role (e.g. `feedback_admin`, `payment_admin`).
   - Feature access and navigation are strictly restricted to the read/update actions matching their `*_admin` permissions.

---

## 📄 6. Pagination & Response Handling Law

### 6.1 Mandatory Pagination for All List Endpoints

- **Rule**: ALL collection and list responses from the server MUST be parsed with `parsePaginatedResponse<T>` and return `PaginatedResponse<T>` with `PaginationMeta`.
- Never consume raw unpaginated arrays for list screens.

### 6.2 Mandatory Centralized Response Parsing

- **Rule**: ALWAYS use `ApiService` parsing utilities:
  - `parseResponse<T>(response, fromJson)` — Parses single entity response envelopes.
  - `parsePaginatedResponse<T>(response, fromJson)` — Parses list records with `PaginationMeta`.

---

## 🌍 7. Localization Law

- **Rule**: User-visible strings must NEVER be hardcoded in widgets.
- Define keys in `lib/locales/` (`app_locales.dart` / translation maps).
- Use `AppLocales.someKey.tr` for all UI text.
- Active locale is sent automatically to `rexone-core` via `X-Locale` and `Accept-Language` HTTP headers.

---

## 🧪 8. End-to-End (E2E) Testing Law (Flutter Driver / Integration Test)

- **Rule**: Every core user flow (Authentication, Passcode verification, AI chat, Payment flows) MUST be accompanied by integration and E2E tests in `test/` or `integration_test/`.
- Test suites must run reliably and verify complete end-to-end device journeys.

---

- Shared foundation code lives in `lib/design/`, `lib/services/`, `lib/constants/`, `lib/models/`, `lib/helpers/`, `lib/locales/`, `lib/routes/`.

---

## 📚 10. Documentation Synchronization Law

- **Rule**: After EVERY feature creation, modification, or bugfix:
  - **`README.md`** MUST be updated with newly added screens, user workflows, feature capabilities, or configuration variables.
  - **`ECOSYSTEM.md`** MUST be updated if changes affect cross-platform feature parity, shared contracts, WebSocket events, or communication protocols between Mobile, Web, and Core.
  - **`LAW.md`** represents the non-negotiable constitutional framework; it should ONLY be modified when establishing, refining, or expanding fundamental architectural laws and engineering standards.

---

## ⏰ 11. UTC Transport & Client-Side Local Timezone Law

- **Rule**: The backend API operates exclusively in UTC.
- **Rule**: Mobile client MUST convert user local dates and range boundaries to UTC ISO 8601 strings (`start_date`, `end_date`) before dispatching API requests.
- **Rule**: Mobile client MUST parse and format all UTC timestamps received from the backend into the user's mobile device local timezone for presentation.
