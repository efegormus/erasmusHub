import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/place.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/star_rating.dart';

/// Compact card for one place, as on wireframe page 11:
/// thumbnail, name, "Category · City" and the star rating with its number.
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
          _Thumbnail(place: place),
          const SizedBox(width: AppSpacing.md),
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

/// 56×56 photo: network image with a spinner while loading and the
/// local logo when the link is missing or fails.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.place});
  final Place place;

  static const _size = 56.0;
  static const _fallback = Image(
    image: AssetImage('assets/images/erasmus_hub_logo.png'),
    fit: BoxFit.contain,
  );

  @override
  Widget build(BuildContext context) {
    final url = place.imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox.square(
        dimension: _size,
        child: ColoredBox(
          color: AppColors.background,
          child: url == null || url.trim().isEmpty
              ? _fallback
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  semanticLabel: 'Photo of ${place.name}',
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                  errorBuilder: (context, error, stack) => _fallback,
                ),
        ),
      ),
    );
  }
}
