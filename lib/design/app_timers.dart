// lib/design/app_timers.dart
import 'package:flutter/material.dart';
import 'dart:async';

class AppTimers {
  const AppTimers();

  // Animations
  Duration get animationDuration => Duration(milliseconds: 300);
  Duration get shortAnimationDuration => Duration(milliseconds: 150);

  // ============ DURATIONS ============

  /// Short animations (150ms)
  Duration get short => const Duration(milliseconds: 150);

  /// Medium animations (300ms)
  Duration get medium => const Duration(milliseconds: 300);

  /// Long animations (500ms)
  Duration get long => const Duration(milliseconds: 500);

  /// Extra long animations (800ms)
  Duration get extraLong => const Duration(milliseconds: 800);

  /// Snackbar duration (3 seconds)
  Duration get snackbar => const Duration(seconds: 3);

  /// Debounce duration (500ms)
  Duration get debounce => const Duration(milliseconds: 500);

  /// Throttle duration (300ms)
  Duration get throttle => const Duration(milliseconds: 300);

  /// Resend code cooldown (60 seconds)
  Duration get resendCooldown => const Duration(seconds: 60);

  /// API timeout (30 seconds)
  Duration get apiTimeout => const Duration(seconds: 30);

  /// Splash screen duration (2 seconds)
  Duration get splash => const Duration(seconds: 2);

  /// OTP expiry (10 minutes)
  Duration get otpExpiry => const Duration(minutes: 10);

  /// Session timeout (30 minutes)
  Duration get sessionTimeout => const Duration(minutes: 30);

  // ============ TIMER HELPERS ============

  /// Run a function after a delay
  Timer delayed(Duration duration, VoidCallback callback) {
    return Timer(duration, callback);
  }

  /// Run a function after a short delay (300ms)
  Timer delayedShort(VoidCallback callback) {
    return Timer(short, callback);
  }

  /// Run a function after a medium delay (500ms)
  Timer delayedMedium(VoidCallback callback) {
    return Timer(medium, callback);
  }

  /// Run a function after a long delay (800ms)
  Timer delayedLong(VoidCallback callback) {
    return Timer(long, callback);
  }

  /// Create a periodic timer
  Timer periodic(Duration duration, void Function(Timer) callback) {
    return Timer.periodic(duration, callback);
  }

  /// Create a countdown timer
  Stream<int> countdown(int seconds) async* {
    for (var i = seconds; i >= 0; i--) {
      yield i;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // ============ TIME FORMATTING ============

  /// Format seconds to MM:SS
  String formatSeconds(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format duration to readable string
  String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
    return '${duration.inSeconds}s';
  }

  /// Format milliseconds to seconds with 1 decimal
  String formatMs(int milliseconds) {
    return (milliseconds / 1000).toStringAsFixed(1);
  }

  /// Get elapsed time since a timestamp
  String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    }
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    }
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'just now';
  }

  // ============ ANIMATION CURVES ============

  /// Ease in curve
  Curve get easeIn => Curves.easeIn;

  /// Ease out curve
  Curve get easeOut => Curves.easeOut;

  /// Ease in out curve
  Curve get easeInOut => Curves.easeInOut;

  /// Fast out slow in curve
  Curve get fastOutSlowIn => Curves.fastOutSlowIn;

  /// Bounce curve
  Curve get bounce => Curves.bounceOut;

  /// Elastic curve
  Curve get elastic => Curves.elasticOut;
}
