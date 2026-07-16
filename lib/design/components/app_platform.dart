// lib/helpers/platform_helper.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppPlatform {
  static bool get isIOS => GetPlatform.isIOS;
  static bool get isAndroid => GetPlatform.isAndroid;

  // ===== SCAFFOLD =====
  static Widget scaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Color? backgroundColor,
    bool resizeToAvoidBottomInset = true,
  }) {
    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar as CupertinoNavigationBar?,
        backgroundColor: backgroundColor ?? CupertinoColors.systemBackground,
        child: SafeArea(
          child: Stack(
            children: [
              body,
              if (bottomNavigationBar != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: bottomNavigationBar,
                ),
              if (floatingActionButton != null)
                Positioned(bottom: 80, right: 20, child: floatingActionButton),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor ?? Colors.white,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  // ===== LISTTILE =====
  static Widget listTile({
    required Widget leading,
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    if (isIOS) {
      return CupertinoListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        backgroundColor: backgroundColor ?? CupertinoColors.white,
      );
    }
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      tileColor: backgroundColor,
    );
  }

  // ===== TOGGLE =====
  static Widget toggle({
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
    Color? trackColor,
  }) {
    if (isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: activeColor ?? CupertinoColors.systemBlue,
        inactiveTrackColor: trackColor ?? CupertinoColors.systemGrey4,
      );
    }
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeColor,
      trackColor: trackColor != null
          ? WidgetStateProperty.all(trackColor)
          : null,
    );
  }

  // ===== TEXTFIELD =====
  static Widget textField({
    TextEditingController? controller,
    FocusNode? focusNode,
    bool autofocus = false,
    bool obscureText = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
    int? minLines,
    bool enabled = true,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? hint,
    String? error,
    String? helper,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    if (isIOS) {
      return CupertinoTextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        minLines: minLines,
        enabled: enabled,
        placeholder: hint,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: error != null
                ? CupertinoColors.systemRed
                : CupertinoColors.systemGrey4,
          ),
        ),
      );
    }
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      textCapitalization: textCapitalization,
      decoration: Design.styles.input(
        hint: hint,
        error: error,
        helper: helper,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  // ===== BUTTONS =====
  static Widget elevatedButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: CupertinoColors.systemBlue,
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: Design.styles.buttonPrimary,
      child: child,
    );
  }

  static Widget outlinedButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: Design.styles.buttonSecondary,
      child: child,
    );
  }

  static Widget textButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: child,
      );
    }
    return TextButton(
      onPressed: onPressed,
      style: Design.styles.buttonText,
      child: child,
    );
  }

  static Widget iconButton({
    required VoidCallback? onPressed,
    required IconData icon,
    String? tooltip,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Icon(icon),
      );
    }
    return IconButton(onPressed: onPressed, icon: Icon(icon), tooltip: tooltip);
  }

  static Widget googleButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      );
    }
    return SizedBox(
      height: Design.spacing.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: Design.styles.buttonGoogle,
        child: child,
      ),
    );
  }

  // ===== DIALOG =====
  static Future<T?> dialog<T>({
    required Widget title,
    required Widget content,
    required List<Widget> actions,
    Color? backgroundColor,
  }) {
    if (isIOS) {
      return Get.dialog<T>(
        CupertinoAlertDialog(
          title: title,
          content: content,
          actions: actions.map((action) {
            if (action is TextButton) {
              return CupertinoDialogAction(
                onPressed: action.onPressed,
                isDestructiveAction:
                    action.style?.foregroundColor?.resolve({}) == Colors.red,
                child: action.child ?? const Text(''),
              );
            }
            return CupertinoDialogAction(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            );
          }).toList(),
        ),
      );
    }
    return Get.dialog<T>(
      AlertDialog(
        backgroundColor: backgroundColor ?? Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  // ===== SNACKBAR =====
  static void snackbar({
    required String title,
    required String message,
    required Color background,
    required Color foreground,
    required IconData icon,
    Duration? duration,
  }) {
    if (isIOS) {
      _showCupertinoSnackbar(
        title: title,
        message: message,
        background: background,
        foreground: foreground,
        icon: icon,
        duration: duration,
      );
    } else {
      _showMaterialSnackbar(
        title: title,
        message: message,
        background: background,
        foreground: foreground,
        icon: icon,
        duration: duration,
      );
    }
  }

  static void _showCupertinoSnackbar({
    required String title,
    required String message,
    required Color background,
    required Color foreground,
    required IconData icon,
    Duration? duration,
  }) {
    final context = Get.context;
    if (context == null) return;

    Get.closeAllSnackbars();

    Get.rawSnackbar(
      titleText: Row(
        children: [
          Icon(icon, color: foreground, size: 20),
          SizedBox(width: Design.spacing.sm),
          Expanded(
            child: Text(
              title,
              style: Design.typo.labelLarge.copyWith(color: foreground),
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: Design.typo.bodyMedium.copyWith(color: foreground),
      ),
      backgroundColor: background,
      margin: EdgeInsets.all(Design.spacing.lg),
      borderRadius: Design.spacing.radiusMedium,
      duration: duration ?? Design.timers.snackbar,
      padding: EdgeInsets.symmetric(
        horizontal: Design.spacing.lg,
        vertical: Design.spacing.md,
      ),
      borderColor: foreground.withValues(alpha: 0.25),
      borderWidth: 1,
    );
  }

  static void _showMaterialSnackbar({
    required String title,
    required String message,
    required Color background,
    required Color foreground,
    required IconData icon,
    Duration? duration,
  }) {
    final context = Get.context;
    if (context == null) return;

    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: background,
      colorText: foreground,
      margin: EdgeInsets.all(Design.spacing.lg),
      borderRadius: Design.spacing.radiusMedium,
      duration: duration ?? Design.timers.snackbar,
      icon: Icon(icon, color: foreground),
      borderColor: foreground.withValues(alpha: 0.25),
      borderWidth: 1,
      titleText: Text(
        title,
        style: Design.typo.labelLarge.copyWith(color: foreground),
      ),
      messageText: Text(
        message,
        style: Design.typo.bodyMedium.copyWith(color: foreground),
      ),
    );
  }
}
