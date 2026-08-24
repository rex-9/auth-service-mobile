// lib/modules/ai/widgets/voice_level_bars.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';

/// Live voice level visualization — animated vertical bars driven by
/// normalized amplitude in the range 0.0–1.0.
class VoiceLevelBars extends StatelessWidget {
  const VoiceLevelBars({
    super.key,
    required this.level,
    this.barCount = AppConstants.chatVoiceLevelBarCount,
  });

  final double level;
  final int barCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final clampedLevel = level.clamp(0.0, 1.0);
    final activeColor = colors.primary;
    final idleColor = colors.primary.withValues(alpha: 0.25);
    final minHeight = Design.spacing.xs;
    final maxHeight = Design.spacing.xxxl;

    return SizedBox(
      height: maxHeight,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(barCount, (index) {
          final phase = (index / barCount) * math.pi * 2;
          final wave = (math.sin(phase) + 1) / 2;
          final barLevel = (clampedLevel * (0.55 + wave * 0.45)).clamp(0.0, 1.0);
          final height = minHeight + (maxHeight - minHeight) * barLevel;
          final isActive = barLevel > 0.08;

          return Expanded(
            child: Center(
              child: AnimatedContainer(
                duration: Design.timers.short,
                curve: Curves.easeOut,
                width: 3,
                height: height,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : idleColor,
                  borderRadius:
                      BorderRadius.circular(Design.spacing.radiusSmall),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
