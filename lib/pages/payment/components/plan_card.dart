import 'package:flutter/material.dart';
import 'package:rexone_mobile/design/design.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.periodLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String description;
  final String price;
  final String periodLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Design.spacing.lg),
      child: Material(
        color: isSelected
            ? context.colors.primary.withValues(alpha: 0.06)
            : context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Design.spacing.md),
          side: BorderSide(
            color: isSelected ? context.colors.primary : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Design.spacing.md),
          child: Padding(
            padding: EdgeInsets.all(Design.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(name, style: context.typo.headline4)),
                    if (isSelected)
                      Icon(
                        Design.icons.check,
                        color: context.colors.primary,
                        size: Design.spacing.iconMedium,
                      ),
                  ],
                ),
                SizedBox(height: Design.spacing.sm),
                Text(
                  description,
                  style: context.typo.bodyMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Design.spacing.lg),
                Text(
                  price,
                  style: context.typo.headline2.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                SizedBox(height: Design.spacing.xs),
                Text(
                  periodLabel,
                  style: context.typo.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
