> [!IMPORTANT]
>
> ### 🏛️ The Foundation Creed & Supreme Motivation
>
> **"Clarity before cleverness. Precision before haste. Simplicity without weakness. Strength without spectacle."**
>
> 📜 **Constitutional Mandate**: Non-negotiable architectural laws and engineering standards for all human engineers and autonomous AI agents on **Rexone Mobile** (`rexone-mobile`). Zero exceptions!!!
>
> This application is built upon the **Rexone Ecosystem** (`rex-9`). These are immutable **Rexone Laws and Protocols** to be strictly observed and enforced without any exception across all human engineers and autonomous AI agents. Developers building on top of this foundation are warmly encouraged to preserve ecosystem credit to support the project.

> > _"If you don't follow These LAWS, u're gay."_
> >
> > — _Newton'z Law_

---

## 🎨 1. Design System & Layout Doctrine

### 1.1 Zero Ad-Hoc Widgets Outside `lib/design/`

- **Rule**: NEVER create arbitrary `SizedBox(width: 20)`, hardcoded `EdgeInsets.all(16)`, or inline raw styling.
- Strictly use tokens and elements provided by `lib/design/`:
  - `Design.space.*` (`xs`, `s`, `m`, `l`, `xl`).
  - `Design.radius.*` (`s`, `m`, `l`, `full`).
  - `Design.typography.*` and semantic text styles.
- Reusable UI elements and components live in `lib/design/elements/` and `lib/design/components/`.

### 1.2 Theme-Aware Styling (Light & Dark Modes)

- **Rule**: NEVER hardcode `Color(0xFF...)` or `Colors.white`/`Colors.black` directly in feature widgets.
- ALWAYS access theme tokens through context extensions (`context.colors.primary`, `context.colors.surface`, `context.colors.background`, `context.colors.textPrimary`, `context.typography.titleLarge`, `context.typography.bodyMedium`).

### 1.3 Mandatory Confirm Dialog for Destructive Actions

- **Rule**: ALL destructive, irreversible, or state-mutating actions (`discard`, `destroy`, `revoke`, `signout`, `reset`, `clear`, `exit`) MUST be gated behind an explicit confirmation dialog before invoking Controller or Service methods.
- **Strict Prohibition of `destroy` in Active Views**: Active views MUST strictly expose `discard` (soft delete). The `destroy` action is strictly confined to the Recycle Bin for destroyable resources.
- **Mandatory Recycle Bin Interface**: Whenever `discard` is supported on a resource, that resource MUST provide an accessible Recycle Bin interface to view discarded records, restore them with `undiscard`, or purge destroyable records.
- **Mandatory `AppDialog.confirm` Usage**: Always use `AppDialog.confirm(context: context, title: ..., message: ..., confirmLabel: ...)` (`lib/design/components/app_dialog.dart`), which adapts automatically to native Cupertino (iOS) and Material (Android) styling.

---

## 🖼️ 2. Distributed Centralized Assets Law

- **Rule**: NEVER store raw media URL strings directly in model entities.
- ALL media is managed through the backend distributed assets system (`type`, `storage_key`, `assetable_type`, `assetable_id`). Pass `{ type: "avatar", assetable_type: "User", assetable_id: currentUser?.id }` for avatar uploads and render using semantic avatar widgets.

---

## 🏗️ 3. Architecture & Layering (Strict GetX MVCS)

### 3.1 Server-Business Logic Authority vs. Client-Business Logic

- **Server Authority**: All domain rules, access lifecycles, pricing, rate limits, payment processing, AI pipelines, and database integrity live exclusively in `rexone-core`.
- **Zero Logic Duplication**: Mobile client NEVER duplicates or recalculates server rules. It strictly manages frontend reactive state (`.obs`), device interactions, local form controllers, and UI presentation.

### 3.2 Strict GetX Ecosystem Adherence & Zero Redundant Packages

- GetX is the system foundation (`State Management`, `Dependency Injection`, `Route Management`, `GetStorage`, `GetConnect`).
- **Forbidden External Packages**: NEVER add external state managers (`provider`, `bloc`, `riverpod`), local storage packages (`shared_preferences`, `hive`, `sqflite`), or routing packages (`go_router`, `auto_route`).
- Only introduce third-party packages if GetX cannot natively provide the capability (e.g. `google_sign_in`, `onesignal_flutter`, `webview_flutter`).

### 3.3 4-Tier MVCS Separation of Concerns

```
Model Layer       (lib/models/ & lib/modules/*/data/)
  ↓ (Typed models, JSON serialization toJson/fromJson, request/response envelopes)
View Layer        (lib/pages/ or lib/modules/*/pages/ & views/)
  ↓ (Extends GetView<TController>, triggers actions, renders Obx reactive UI)
Controller Layer  (lib/modules/*/controllers/*.controller.dart)
  ↓ (Extends GetxController, orchestrates client logic, manages .obs state)
Service Layer     (lib/services/ & lib/modules/*/services/*.service.dart)
  ↓ (Extends GetxService, formats request payloads & backend API calls)
Transport Layer   (lib/services/api.service.dart)
    (Extends GetConnect, auto JWT/Platform/Locale headers, _withLoading overlay)
```

- **Views (`GetView<TController>`)**: Pure presentation. Mandatory `GetView` extension. Zero direct API calls.
- **Controllers (`GetxController`)**: Lean client-business logic. Manages `.obs` state, GetX lifecycles (`onInit`, `onReady`, `onClose`), and UI feedback (`AppSnackbar`, `Get.dialog`).
- **Services (`GetxService`)**: Permanent singleton network clients. Pure transport, zero UI state or dialogs.
- **Transport (`api.service.dart`)**: Auto `Authorization: Bearer <token>`, `X-Platform`, `X-Locale`, and loading overlays.

### 3.4 Client-Business Logic Bifurcation Law

- **Backend-Facing Logic (`Controller` + `Service`)**: API orchestration, remote state, payload formatting, and error mapping flow strictly through `<feature>.controller.dart` and `<feature>.service.dart`.
- **UI-Only Logic (`Workers / UI Controllers / Helpers`)**: Purely clientside behavior (timers, scroll physics, keyboard dismissal, animations, audio playback) is handled by local GetX controllers, workers (`ever`, `debounce`), or UI helpers without network services.

---

## 🗂️ 4. Constants & Enums Law

### 4.1 Zero Loose String Literals or Magic Numbers

- Every status string, API key, storage key, header, and route MUST be centralized in `lib/constants/` (`app_locales.dart`, `storage_keys.dart`, `app.constants.dart`, `json_keys.dart`, `log.constants.dart`, `enums.dart`, `server_routes.dart`, `app_routes.dart`, `asset_keys.dart`).

### 4.2 Cross-Platform Storage Keys Parity

- All local storage keys MUST match `rexone-web` `StorageKeys` exactly (`'token'`, `'user'`, `'locale'`, `'theme'`). Always use `StorageKeys.*`.

---

## 🔐 5. RBAC & Authorization Law

### 5.1 Three-Tier Hierarchy

1. **`super_admin`**: Full system authority across all administration areas and settings.
2. **`admin`**: Operational access across domain resources (`feedbacks`, `payments`, `ai`, `logs`, `notifications`). Restricted from `users` and `iam`.
3. **Partial Admin (`*_admin`)**: Access strictly restricted to actions matching their specific `*_admin` permissions.

---

## 📄 6. Pagination & Response Handling Law

### 6.1 Mandatory Universal Pagy Pagination & Zero "All" Flags

- **Universal Pagy Protocol**: ALL collection and list endpoints return a standard Pagy envelope (`data` array + `meta.pagination`). Parse all collection responses with `parsePaginatedResponse<T>` returning `PaginatedResponse<T>` with `PaginationMeta`. Never consume raw unpaginated arrays.
- **Default Full Collection (Zero Query Params)**: When the mobile client requests a collection without `page` or `limit` parameters, the backend returns ALL records in a single page wrapped in standard Pagy metadata (`current_page: 1`, `total_pages: 1`, `total_count: N`).
- **Prohibition of "all" Query Parameters**: Mobile client MUST NEVER send `limit: "all"` or arbitrary string flags. Omitting `page` and `limit` fetches the full collection cleanly and uniformly through Pagy.

### 6.2 Centralized Response Parsing

- ALWAYS use `ApiService` parsing utilities (`parseResponse`, `parsePaginatedResponse`).

---

## 🌍 7. Localization Law

- User-visible strings must NEVER be hardcoded. Define keys in `lib/locales/` (`app_locales.dart`) and access via `AppLocales.someKey.tr`. Active locale is sent to `rexone-core` via `X-Locale` and `Accept-Language`.

---

## 🧪 8. End-to-End (E2E) Testing Law

- Every core user journey (Auth, Passcode verification, AI chat, Payment) MUST have integration/E2E tests in `integration_test/` or `test/`.

---

## 🧱 9. Module Boundary Law

- Feature domains live inside `lib/modules/<feature_name>/` (`data/`, `controllers/`, `services/`, `pages/`, `widgets/`).
- Shared foundation code lives in `lib/design/`, `lib/services/`, `lib/constants/`, `lib/models/`, `lib/helpers/`, `lib/locales/`, `lib/routes/`.

---

## ⏰ 10. UTC Transport & Client Local Timezone Law

- Backend operates in UTC. Mobile client sends dates in UTC ISO 8601 strings and formats timestamps into the device's local timezone for display.

---

## 📚 11. Documentation Synchronization Law

- After every feature or bugfix, keep documentation synchronized:
  - **`README.md`**: Updated with newly added screens, capabilities, or configuration.
  - **`ECOSYSTEM.md`**: Updated for cross-platform contracts or shared protocols.
  - **`LAW.md`**: Modified only when establishing or refining fundamental architectural laws.
