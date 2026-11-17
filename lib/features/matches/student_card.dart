import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/student.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/user_avatar.dart';

/// Card for one matched student (wireframe page 13): name, status,
/// "Department · Home university", term and optional contact links.
/// The avatar is a network image with an initials fallback.
class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student, this.onContact});

  final Student student;

  /// Called with the tapped link label ("Instagram", "LinkedIn", "Phone")
  /// and its value.
  final void Function(String label, String value)? onContact;

  @override
  Widget build(BuildContext context) {
    final secondary = AppTextStyles.label.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w400,
    );
    final contacts = {
      'Instagram': student.instagram,
      'LinkedIn': student.linkedin,
      'Phone': student.phone,
    }..removeWhere((_, value) => value.isEmpty);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                name: student.name,
                imageUrl: student.avatarUrl,
                radius: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              student.name,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Chip(
                          label: Text(student.status.label),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    Text(
                      '${student.department} · ${student.homeUniversity}',
                      style: secondary,
                    ),
                    Text(student.term, style: secondary),
                  ],
                ),
              ),
            ],
          ),
          if (contacts.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final entry in contacts.entries)
                  ActionChip(
                    label: Text(entry.key),
                    visualDensity: VisualDensity.compact,
                    onPressed: onContact == null
                        ? null
                        : () => onContact!(entry.key, entry.value),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
