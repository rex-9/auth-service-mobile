// lib/design/components/app_snackbar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import '../design.dart';

class AppSnackbar {
  AppSnackbar._();

  static void error(String message, {dynamic e, StackTrace? stk}) {
    _logError(message, e, stk);
    _show(
      title: Constants.locale.error.tr,
      message: message,
      background: Design.colors.error.withValues(alpha: 0.12),
      foreground: Design.colors.errorDark,
      icon: Design.icons.error,
    );
  }

  static void success(String message) {
    _show(
      title: Constants.locale.success.tr,
      message: message,
      background: Design.colors.success.withValues(alpha: 0.12),
      foreground: Design.colors.successDark,
      icon: Design.icons.check,
    );
  }

  static void warning(String message) {
    _show(
      title: Constants.locale.warning.tr,
      message: message,
      background: Design.colors.warning.withValues(alpha: 0.12),
      foreground: Design.colors.warningDark,
      icon: Design.icons.warning,
    );
  }

  static void info(String message) {
    _show(
      title: Constants.locale.info.tr,
      message: message,
      background: Design.colors.primary.withValues(alpha: 0.12),
      foreground: Design.colors.primaryDark,
      icon: Design.icons.info,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color background,
    required Color foreground,
    required IconData icon,
  }) {
    AppPlatform.snackbar(
      title: title,
      message: message,
      background: background,
      foreground: foreground,
      icon: icon,
    );
  }

  // ===== PRIVATE LOGGING =====
  static void _logError(String message, dynamic e, StackTrace? stk) {
    final buffer = StringBuffer();
    buffer.writeln(
      '═══════════════════════════════════════════════════════════',
    );
    buffer.writeln('❌ ERROR ===> $message');
    buffer.writeln(
      '───────────────────────────────────────────────────────────',
    );

    buffer.writeln('📦 Error ===> $e');
    buffer.writeln('📦 Type ===> ${e.runtimeType}');

    if (stk != null) {
      buffer.writeln(
        '───────────────────────────────────────────────────────────',
      );
      buffer.writeln('📚 Stack Trace:');
      buffer.writeln(stk.toString());
    }

    // Print to console
    debugPrint(buffer.toString());

    // Optional: Send to crash reporting service
    // Crashlytics.instance.recordError(e, stk, reason: message);
  }
}
