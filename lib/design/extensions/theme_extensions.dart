// lib/design/extensions/theme_extensions.dart
import 'package:flutter/material.dart';
import '../design.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension ThemeColors on BuildContext {
  _ThemeColors get colors => _ThemeColors(this);
}

class _ThemeColors {
  const _ThemeColors(this._context);
  final BuildContext _context;

  ColorScheme get colorScheme => _context.theme.colorScheme;

  Color get primary => _context.theme.colorScheme.primary;
  Color get error => _context.theme.colorScheme.error;
  Color get background => _context.theme.scaffoldBackgroundColor;
  Color get surface => _context.theme.colorScheme.surface;
  Color get divider => _context.theme.dividerColor;
  Color get border => _context.theme.colorScheme.outline;
  Color get textPrimary => _context.theme.colorScheme.onSurface;
  Color get textSecondary => _context.theme.colorScheme.onSurfaceVariant;
  Color get textTertiary =>
      _context.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
}

extension ThemeStyles on BuildContext {
  _ThemeStyles get styles => _ThemeStyles(this);
}

class _ThemeStyles {
  const _ThemeStyles(this._context);
  final BuildContext _context;

  // Headlines
  TextStyle get headline1 => Design.typography.headline1.copyWith(
    color: _context.theme.colorScheme.onSurface,
  );

  TextStyle get headline2 => Design.typography.headline2.copyWith(
    color: _context.theme.colorScheme.onSurface,
  );

  TextStyle get headline3 => Design.typography.headline3.copyWith(
    color: _context.theme.colorScheme.onSurface,
  );

  TextStyle get headline4 => Design.typography.headline4.copyWith(
    color: _context.theme.colorScheme.onSurface,
  );

  // Body
  TextStyle get bodyLarge => Design.typography.bodyLarge.copyWith(
    color: _context.theme.colorScheme.onSurface,
  );

  TextStyle get bodyMedium => Design.typography.bodyMedium.copyWith(
    color: _context.theme.colorScheme.onSurfaceVariant,
  );

  TextStyle get bodySmall => Design.typography.bodySmall.copyWith(
    color: _context.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
  );

  // Labels
  TextStyle get labelLarge => Design.typography.labelLarge.copyWith(
    color: _context.theme.colorScheme.onSurface,
  );

  TextStyle get labelMedium => Design.typography.labelMedium.copyWith(
    color: _context.theme.colorScheme.onSurfaceVariant,
  );

  // Buttons
  TextStyle get button => Design.typography.button.copyWith(
    color: _context.theme.colorScheme.onSurface,
  );

  // Caption & Helper
  TextStyle get caption => Design.typography.caption.copyWith(
    color: _context.theme.colorScheme.onSurfaceVariant,
  );

  TextStyle get helper => Design.typography.helper.copyWith(
    color: _context.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
  );

  TextStyle get link => Design.typography.link;
}
