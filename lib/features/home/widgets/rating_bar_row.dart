import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// "Housing ▬▬▬▬░░ 2.6" row for the University detail average ratings.
class RatingBarRow extends StatelessWidget {
  const RatingBarRow({super.key, required this.label, required this.average});

  final String label;

  /// 1–5 average, or null when no one rated this category yet.
  final double? average;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final value = average;
    return Semantics(
      label: value == null
          ? '$label: not rated yet'
          : '$label: ${value.toStringAsFixed(1)} out of 5',
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs / 2),
          child: Row(
            children: [
              Expanded(flex: 5, child: Text(label, style: textStyle)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  child: LinearProgressIndicator(
                    value: (value ?? 0) / 5,
                    minHeight: 6,
                    color: AppColors.primary,
                    backgroundColor: AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                value == null ? '–' : value.toStringAsFixed(1),
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
