import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/place.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/star_rating.dart';

/// Compact card for one place, as on wireframe page 11:
/// name, "Category · City" and the star rating with its number.
/// The remove action covers the "Card with a working remove" requirement.
class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place, this.onRemove});

  final Place place;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${place.category.label} · ${place.city}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StarRating(value: place.rating, size: 18),
                    Text(
                      place.rating.toStringAsFixed(1),
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (place.comment.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '“${place.comment}”',
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              tooltip: 'Remove ${place.name}',
              icon: const Icon(Icons.delete_outline),
              color: AppColors.textSecondary,
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
