import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/star_rating.dart';

/// A rating category with its stars.
///
/// Read-only (label left, stars right) when [onChanged] is null.
/// As an input the label sits above the stars so five tappable stars
/// never overflow a narrow phone.
class RatingRow extends StatelessWidget {
  const RatingRow({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (onChanged == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.body)),
            const SizedBox(width: AppSpacing.sm),
            StarRating(value: value.toDouble(), size: 18),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body),
        StarRating(value: value.toDouble(), onChanged: onChanged),
      ],
    );
  }
}
