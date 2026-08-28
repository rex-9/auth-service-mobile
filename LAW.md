> [!IMPORTANT]
> ### 🏛️ The Foundation Creed
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

## 🏗️ 3. Architecture & Layering (GetX MVC)

### 3.1 Strict 4-Tier Separation of Concerns
```
View Layer (lib/pages/ or lib/modules/*/pages)
       ↓  (Triggers actions, displays reactive state)
Controller Layer (lib/controllers/ or lib/modules/*/controllers)
       ↓  (Manages state .obs, shows dialogs/snackbars)
Service Layer (lib/services/ or lib/modules/*/services)
       ↓  (Data formatting & API calls)
Transport Layer (lib/services/api.service.dart)
```

- **Views / Pages**:
  - PURE presentation widgets extending `GetView<TController>` or `StatelessWidget`.
  - Zero direct API calls.
  - Zero raw business calculations.
  - Listen to reactive state with `Obx(() => ...)` and call controller methods.
- **Controllers (`*.controller.dart`)**:
  - Manage observable state (`final count = 0.obs;`).
  - Coordinate workflows, show Snackbars/Dialogs (`Get.snackbar`, `Get.dialog`), navigate routes.
  - Call Services for backend interaction.
- **Services (`*.service.dart`)**:
  - Exclusively perform remote API/WebSocket/persistence calls.
  - NEVER trigger UI, Snackbars, or navigation inside Services.
- **Transport (`api.service.dart`)**:
  - Extends `GetConnect` with automatic `Authorization: Bearer <token>`, `X-Platform: android|ios`, `X-Locale`, and `Accept-Language` headers.
  - Unified loading overlay via `_withLoading()`.

---

## 🗂️ 4. Constants & Enums Law

### 4.1 Zero Loose String Literals or Magic Numbers
- **Rule**: Every status string, API key, storage key, header, and route MUST be centralized in `lib/constants/`:
  - `app.constants.dart` — Storage keys (`Constants.app.storageKey*`), platform headers (`AppConstants.platformAndroid`, `AppConstants.platformIos`, `AppConstants.currentPlatform`).
  - `json_keys.dart` — Centralized API request and response JSON envelope keys (`JsonKeys.*`).
  - `log.constants.dart` — Client telemetry constants (`LogConstants.*`).
  - `enums.dart` — Strongly-typed domain enums (`AuthProvider`, `ChatRole`, `ThemePreference`).
  - `server_routes.dart` — Backend API endpoint paths (`ServerRoutes.*`).
  - `app_routes.dart` — Client navigation route strings (`AppRoutes.*`).
  - `asset_keys.dart` — Asset model constants (`AssetKeys.*`).
- Exported cleanly from `lib/constants/constants.dart`.

### 4.2 Zero Raw Local Storage Keys
- **Rule**: NEVER pass loose string literals to `GetStorage()` or secure storage. Always use `Constants.app.storageKey*`.

---

## 🔐 5. RBAC & Client-Side Authorization Law

- User permissions map to backend resources and actions (`read`, `create`, `update`, `delete`).
- Navigation and feature access are guarded by role and permission checkers:
  - `super_admin`: Full access across all admin features.
  - `admin`: Full access EXCEPT `users` and `iam`.
  - Domain roles: Access strictly granted based on permissions.

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

