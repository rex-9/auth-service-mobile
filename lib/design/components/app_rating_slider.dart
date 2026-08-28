// lib/design/components/app_rating_slider.dart
import 'package:flutter/material.dart';
import 'package:rexone_mobile/design/design.dart';

class AppRatingSlider extends StatelessWidget {
  const AppRatingSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1.0,
    this.max = 10.0,
    this.divisions = 9,
    this.label,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;
  final String? label;

  static (String emoji, String text) getSentiment(int rating) {
    if (rating <= 2) return ('😞', 'Needs Work');
    if (rating <= 4) return ('😕', 'Could Be Better');
    if (rating <= 6) return ('😐', 'Neutral');
    if (rating <= 8) return ('🙂', 'Good');
    return ('🤩', 'Exceptional!');
  }

  @override
  Widget build(BuildContext context) {
    final intRating = value.round();
    final (emoji, sentimentText) = getSentiment(intRating);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (label != null)
              Text(
                label!,
                style: context.typo.caption.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Design.spacing.sm,
                vertical: Design.spacing.xs / 2,
              ),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(Design.spacing.radiusMedium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 14)),
                  SizedBox(width: Design.spacing.xs),
                  Text(
                    '$intRating / ${max.toInt()}',
                    style: context.typo.caption.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: Design.spacing.xs),
                  Text(
                    '($sentimentText)',
                    style: context.typo.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Design.spacing.xs),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: context.colors.primary,
            inactiveTrackColor: context.colors.primary.withValues(alpha: 0.2),
            thumbColor: context.colors.primary,
            overlayColor: context.colors.primary.withValues(alpha: 0.2),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            trackHeight: 6.0,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10.0,
              elevation: 2.0,
            ),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: context.colors.primary,
            inactiveColor: context.colors.primary.withValues(alpha: 0.2),
            thumbColor: context.colors.primary,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Design.spacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${min.toInt()} (Low)',
                style: context.typo.caption.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
              Text(
                '${((min + max) / 2).toInt()}',
                style: context.typo.caption.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
              Text(
                '${max.toInt()} (High)',
                style: context.typo.caption.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
