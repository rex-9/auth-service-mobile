## 🎨 Design System (IMPORTANT)

**⚠️ CRITICAL: ALWAYS USE THE DESIGN SYSTEM. NEVER HARDCODE COLORS, SPACING, OR TEXT STYLES.**

### 📂 Design Folder Structure

```
lib/design/
├── design.dart              # Single entry point - import this!
├── elements/                # Design tokens (never used directly)
│   ├── app_colors.dart      # All color definitions
│   ├── app_typography.dart  # Base text styles (no colors)
│   ├── app_spacing.dart     # All spacing values
│   ├── app_styles.dart      # Component styles (buttons, inputs)
│   ├── app_icons.dart       # All icon references
│   ├── app_media.dart       # Asset paths
│   ├── app_timers.dart      # Durations & animations
│   └── app_theme.dart       # Light/Dark themes
├── components/              # Reusable UI components
│   ├── app_button.dart
│   ├── app_input_field.dart
│   ├── app_passcode_field.dart
│   ├── app_loading.dart
│   ├── app_snackbar.dart
│   ├── app_dialog.dart
│   └── app_page.dart        # Page layout wrapper
└── extensions/              # Theme-aware extensions
    └── theme_extensions.dart # context.colors & context.typo
```

### 🎯 How to Use the Design System

#### 1. Import the Design System

```dart
import 'package:meritbox_mobile/design/design.dart';
```

#### 2. Theme-Aware Colors & Typography (Use `context.colors` & `context.typo`)

```dart
@override
Widget build(BuildContext context) {
  return AppPage(
    backgroundColor: context.colors.background,      // Theme-aware color
    body: Text(
      'Hello World',
      style: context.typo.headline1,                  // Theme-aware text
    ),
    Divider(color: context.colors.divider),          // Theme-aware divider
  );
}
```

| Extension                      | Usage     | Description            |
| ------------------------------ | --------- | ---------------------- |
| `context.colors.background`    | Color     | Theme-aware background |
| `context.colors.surface`       | Color     | Theme-aware surface    |
| `context.colors.textPrimary`   | Color     | Primary text color     |
| `context.colors.textSecondary` | Color     | Secondary text color   |
| `context.colors.divider`       | Color     | Divider color          |
| `context.colors.primary`       | Color     | Primary brand color    |
| `context.colors.error`         | Color     | Error color            |
| `context.typo.headline1`       | TextStyle | Large title            |
| `context.typo.headline2`       | TextStyle | Medium title           |
| `context.typo.headline3`       | TextStyle | Small title            |
| `context.typo.headline4`       | TextStyle | Extra small title      |
| `context.typo.bodyLarge`       | TextStyle | Large body text        |
| `context.typo.bodyMedium`      | TextStyle | Medium body text       |
| `context.typo.bodySmall`       | TextStyle | Small body text        |
| `context.typo.labelLarge`      | TextStyle | Large label            |
| `context.typo.labelMedium`     | TextStyle | Medium label           |
| `context.typo.button`          | TextStyle | Button text            |
| `context.typo.caption`         | TextStyle | Caption text           |

#### 3. Static Design Tokens (Use `Design.xxx`)

```dart
// Spacing
SizedBox(height: Design.spacing.lg)   // 16px
Padding(padding: EdgeInsets.all(Design.spacing.screenPadding))

// Icons
Icon(Design.icons.settings)
Icon(Design.icons.logout)

// Media
Image.asset(Design.media.googleLogo)

// Timers
await Future.delayed(Design.timers.medium)
```

| Token                          | Usage    | Description   |
| ------------------------------ | -------- | ------------- |
| `Design.spacing.xs`            | double   | 4px           |
| `Design.spacing.sm`            | double   | 8px           |
| `Design.spacing.md`            | double   | 12px          |
| `Design.spacing.lg`            | double   | 16px          |
| `Design.spacing.xl`            | double   | 20px          |
| `Design.spacing.xxl`           | double   | 24px          |
| `Design.spacing.xxxl`          | double   | 32px          |
| `Design.spacing.screenPadding` | double   | 20px          |
| `Design.spacing.buttonHeight`  | double   | 48px          |
| `Design.timers.short`          | Duration | 150ms         |
| `Design.timers.medium`         | Duration | 300ms         |
| `Design.timers.long`           | Duration | 500ms         |
| `Design.icons.xxx`             | IconData | Various icons |
| `Design.media.googleLogo`      | String   | Asset path    |

#### 4. Components (Use directly)

```dart
// Buttons
AppButton(
  text: 'Continue',
  onPressed: () {},
  type: ButtonType.primary,  // primary | secondary | text | google
  isLoading: false,
)

// Input Fields
AppInputField(
  label: 'Email',
  hint: 'your@email.com',
  onChanged: (value) => email = value,
  error: emailError,
)

// Passcode Field
AppPasscodeField(
  pinController: pinController,
  onCompleted: (pin) => Code(pin),
)

// Page Layout
AppPage(
  title: 'Settings',
  showBackButton: true,
  child: Column(...),
)

// Loading
AppLoading()
AppLoading(size: LoadingSize.large, type: LoadingType.pulse)

// Snackbar
AppSnackbar.success('Operation completed!')
AppSnackbar.error('Something went wrong')

// Dialog
AppDialog.success(
  context: context,
  title: 'Success',
  message: 'Account created!',
)
```

### ❌ What NOT To Do

```dart
// ❌ NEVER hardcode colors
Container(color: Colors.blue)
Text('Hello', style: TextStyle(color: Colors.black))

// ❌ NEVER hardcode spacing
SizedBox(height: 16)
Padding(padding: EdgeInsets.all(20))

// ❌ NEVER hardcode text styles
Text('Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))

// ❌ NEVER create random widgets without using design system
// Always use AppButton, AppInputField, etc.
```

### ✅ Correct Usage Examples

```dart
// ✅ Theme-aware colors & typography
Container(color: context.colors.surface)
Text('Hello', style: context.typo.headline1)

// ✅ Design system spacing
SizedBox(height: Design.spacing.lg)

// ✅ Design system components
AppButton(text: 'Continue', onPressed: () {})
AppInputField(label: 'Email', hint: 'your@email.com', onChanged: (v) {})
```
