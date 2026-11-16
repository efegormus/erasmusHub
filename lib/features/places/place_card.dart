import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/place.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/star_rating.dart';

/// Card for one place: network photo (local logo as fallback), name,
/// category, city, rating, description and a remove action.
class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place, this.onRemove});

  final Place place;
  final VoidCallback? onRemove;

  static const _fallbackAsset = 'assets/images/erasmus_hub_logo.png';

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(aspectRatio: 16 / 9, child: _photo()),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(place.name, style: AppTextStyles.title),
                      ),
                    ),
                    if (onRemove != null)
                      IconButton(
                        tooltip: 'Remove ${place.name}',
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                        onPressed: onRemove,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      label: Text(place.category.label),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text(
                      '${place.city}, ${place.country}',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                StarRating(value: place.rating, size: 18),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: Text(place.description, style: AppTextStyles.body),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Added by ${place.addedBy}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photo() {
    const fallback = ColoredBox(
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Image(
          image: AssetImage(_fallbackAsset),
          fit: BoxFit.contain,
        ),
      ),
    );
    final url = place.imageUrl;
    if (url == null || url.trim().isEmpty) return fallback;
    return Image.network(
      url,
      fit: BoxFit.cover,
      semanticLabel: 'Photo of ${place.name}',
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const ColoredBox(
              color: AppColors.background,
              child: Center(child: CircularProgressIndicator()),
            ),
      errorBuilder: (context, error, stack) => fallback,
    );
  }
}
