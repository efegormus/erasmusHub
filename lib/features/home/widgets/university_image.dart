import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Network photo of a university with loading and error fallbacks.
class UniversityImage extends StatelessWidget {
  const UniversityImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = 12,
    this.iconSize = 28,
  });

  final String? imageUrl;
  final double borderRadius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(
          Icons.account_balance_outlined,
          size: iconSize,
          color: AppColors.primary,
        ),
      ),
    );
    final url = imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: url == null || url.trim().isEmpty
          ? fallback
          : Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                final total = progress.expectedTotalBytes;
                return ColoredBox(
                  color: AppColors.background,
                  child: Center(
                    child: SizedBox.square(
                      dimension: iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: total == null
                            ? null
                            : progress.cumulativeBytesLoaded / total,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => fallback,
            ),
    );
  }
}
