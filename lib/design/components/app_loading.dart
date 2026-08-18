// lib/design/components/app_loading.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/design/design.dart';

// ===== ENUMS =====

enum LoadingSize {
  small(20),
  medium(32),
  large(48),
  xlarge(64);

  const LoadingSize(this.value);
  final double value;
}

/// Loading animation variants.
/// - [circular] — OS-adaptive spinner (default for global overlay & general use)
/// - [dots]     — Animated 3-dot bounce (used in AI thinking bubble)
/// - [pulse]    — Radial pulse glow (used on Splash screen)
enum LoadingType { circular, dots, pulse }

// ===== WIDGET =====

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

  // ===== GLOBAL LOADING STATE =====
  static final RxBool isGlobalLoading = false.obs;
  static final RxnString globalLoadingMessage = RxnString();
  static int _activeCount = 0;

  static void show([String? message]) {
    _activeCount++;
    globalLoadingMessage.value = message;
    isGlobalLoading.value = true;
  }

  static void hide() {
    if (_activeCount > 0) _activeCount--;
    if (_activeCount <= 0) {
      _activeCount = 0;
      // Defer by one frame — guarantees the overlay renders at least once
      // even when the API response arrives before the next vsync (localhost).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_activeCount <= 0) {
          isGlobalLoading.value = false;
          globalLoadingMessage.value = null;
        }
      });
    }
  }

  /// Mounts the global blocking overlay at the app root.
  /// Use as `GetMaterialApp(builder: AppLoading.builder)`.
  static Widget builder(BuildContext context, Widget? child) {
    return Stack(
      children: [
        ?child,
        Obx(() {
          if (isGlobalLoading.value) {
            return Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.35),
                alignment: Alignment.center,
                child: AppLoadingOverlay(
                  message: globalLoadingMessage.value,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoadingType.circular:
        return _buildCircular(context);
      case LoadingType.dots:
        return _AppLoadingDots(size: size, color: color);
      case LoadingType.pulse:
        return _AppLoadingPulse(size: size, color: color);
    }
  }

  static bool get isIOS => GetPlatform.isIOS;

  Widget _buildCircular(BuildContext context) {
    return SizedBox(
      height: size.value,
      width: size.value,
      child: isIOS
          ? CupertinoActivityIndicator(
              color: color ?? Design.theme.colors.primary,
            )
          : CircularProgressIndicator(
              strokeWidth: strokeWidth ?? _getStrokeWidth(),
              color: color ?? Design.theme.colors.primary,
            ),
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
}

// ===== DOTS ANIMATION (looping) =====
// Used in the AI thinking bubble while waiting for AI response.

class _AppLoadingDots extends StatefulWidget {
  const _AppLoadingDots({this.size = LoadingSize.medium, this.color});
  final LoadingSize size;
  final Color? color;

  @override
  State<_AppLoadingDots> createState() => _AppLoadingDotsState();
}

class _AppLoadingDotsState extends State<_AppLoadingDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });
    _animations = _controllers.map((c) {
      return Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      );
    }).toList();

    // Stagger each dot's loop
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size.value * 0.28;
    final color = widget.color ?? Design.theme.colors.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, _) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: dotSize * 0.2),
              width: dotSize,
              height: dotSize * _animations[i].value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.5 + 0.5 * _animations[i].value),
              ),
            );
          },
        );
      }),
    );
  }
}

// ===== PULSE ANIMATION (looping) =====
// Used on the Splash screen.

class _AppLoadingPulse extends StatefulWidget {
  const _AppLoadingPulse({this.size = LoadingSize.medium, this.color});
  final LoadingSize size;
  final Color? color;

  @override
  State<_AppLoadingPulse> createState() => _AppLoadingPulseState();
}

class _AppLoadingPulseState extends State<_AppLoadingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Design.theme.colors.primary;
    final s = widget.size.value;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          height: s,
          width: s,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3 * _animation.value),
                blurRadius: 24 * _animation.value,
                spreadRadius: 6 * _animation.value,
              ),
            ],
          ),
          child: Center(
            child: Container(
              height: s * 0.5,
              width: s * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.7 + 0.3 * _animation.value),
              ),
            ),
          ),
        );
      },
    );
  }
}

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
          color: Design.theme.colors.surface,
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
                style: context.typo.bodyMedium,
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
  void showLoading([String? message]) => AppLoading.show(message);
  void hideLoading() => AppLoading.hide();
}
