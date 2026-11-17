import 'package:flutter/material.dart';

import '../../../core/data/university_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/university.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/star_rating.dart';
import 'university_image.dart';

/// Home list card: photo, name, location, average stars and post count.
class UniversityCard extends StatelessWidget {
  const UniversityCard({super.key, required this.university, this.onTap});

  final University university;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final average = overallAverage(university.id);
    final postCount = postsForUniversity(university.id).length;
    final postLabel = postCount == 1 ? '1 post' : '$postCount posts';
    final secondary = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary);
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 64,
            child: UniversityImage(imageUrl: university.imageUrl),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(university.location, style: secondary),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (average != null) StarRating(value: average, size: 16),
                    Text(
                      average == null
                          ? 'No reviews yet'
                          : '${average.toStringAsFixed(1)} · $postLabel',
                      style: secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
