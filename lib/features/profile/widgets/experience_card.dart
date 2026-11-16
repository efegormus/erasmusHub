import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/exchange_experience.dart';
import '../../../shared/widgets/app_card.dart';

/// Card showing one Erasmus+/Exchange experience.
/// Edit / remove buttons appear only when the callbacks are given.
class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    super.key,
    required this.experience,
    this.onEdit,
    this.onDelete,
  });

  final ExchangeExperience experience;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${experience.hostUniversity} · ${experience.term}',
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${experience.program.label} · ${experience.status.label}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              tooltip: 'Edit experience',
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
          if (onDelete != null)
            IconButton(
              tooltip: 'Remove experience',
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
