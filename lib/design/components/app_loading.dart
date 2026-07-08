// lib/design/components/loading.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.size = LoadingSize.medium,
    this.color,
    this.strokeWidth,
    this.type = LoadingType.circular,
  });

  final LoadingSize size;
  final Color? color;
  final double? strokeWidth;
  final LoadingType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoadingType.circular:
        return _buildCircular();
      case LoadingType.dots:
        return _buildDots();
      case LoadingType.pulse:
        return _buildPulse();
      case LoadingType.page:
        return _buildPageLoader();
    }
  }

  Widget _buildCircular() {
    return SizedBox(
      height: size.value,
      width: size.value,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? _getStrokeWidth(),
        color: color ?? Design.colors.primary,
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_buildDot(0), _buildDot(1), _buildDot(2)],
    );
  }

  Widget _buildDot(int index) {
    final delay = Duration(milliseconds: index * 150);
    final size = this.size.value * 0.3;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: Design.timers.medium,
      child: TweenAnimationBuilder<double>(
        duration: Design.timers.medium + delay,
        tween: Tween(begin: 0.3, end: 1.0),
        curve: Design.timers.easeInOut,
        builder: (_, value, _) {
          return Container(
            margin: EdgeInsets.all(Design.spacing.xs * 0.5),
            width: size * value,
            height: size * value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (color ?? Design.colors.primary).withValues(
                alpha: 0.6 + 0.4 * value,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPulse() {
    return TweenAnimationBuilder<double>(
      duration: Design.timers.medium,
      tween: Tween(begin: 0.6, end: 1.0),
      curve: Design.timers.easeInOut,
      builder: (_, value, _) {
        return Container(
          height: size.value,
          width: size.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (color ?? Design.colors.primary).withValues(alpha: 0.1),
            boxShadow: [
              BoxShadow(
                color: (color ?? Design.colors.primary).withValues(
                  alpha: 0.3 * value,
                ),
                blurRadius: 20 * value,
                spreadRadius: 5 * value,
              ),
            ],
          ),
          child: Center(
            child: Container(
              height: size.value * 0.5,
              width: size.value * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color ?? Design.colors.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageLoader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLoading(size: LoadingSize.large, type: LoadingType.pulse),
        SizedBox(height: Design.spacing.xl),
        Text(
          'Loading...',
          style: Design.typography.bodyMedium.copyWith(
            color: Design.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2.0;
      case LoadingSize.medium:
        return 3.0;
      case LoadingSize.large:
        return 4.0;
      case LoadingSize.xlarge:
        return 5.0;
    }
  }

  // ===== OVERLAY HELPERS =====

  static Future<void> showOverlay(
    BuildContext context, {
    String? message,
    LoadingSize size = LoadingSize.medium,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => AppLoadingOverlay(message: message, size: size),
    );
  }

  static void hideOverlay(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }
}

// ===== ENUMS =====

enum LoadingSize {
  small(20),
  medium(32),
  large(48),
  xlarge(64);

  const LoadingSize(this.value);
  final double value;
}

enum LoadingType { circular, dots, pulse, page }

// ===== OVERLAY WIDGET =====

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    this.message,
    this.size = LoadingSize.medium,
  });

  final String? message;
  final LoadingSize size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(Design.spacing.xl),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Design.colors.surfaceDark
              : Design.colors.surface,
          borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
          boxShadow: Design.colors.shadows.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoading(size: size),
            if (message != null) ...[
              SizedBox(height: Design.spacing.lg),
              Text(
                message!,
                style: Design.typography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ===== CONVENIENCE EXTENSIONS =====

extension AppLoadingExtension on BuildContext {
  void showLoading({String? message}) {
    AppLoading.showOverlay(this, message: message);
  }

  void hideLoading() {
    AppLoading.hideOverlay(this);
  }
}
