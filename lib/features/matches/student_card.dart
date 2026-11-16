import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/student.dart';
import '../../models/user_profile.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/user_avatar.dart';

/// Card for one student: network avatar (initials when it fails),
/// home university, destination, term, status and a connect button.
class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    this.requested = false,
    this.onConnect,
  });

  final Student student;

  /// True after the user tapped Connect; the button then shows "Requested".
  final bool requested;
  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context) {
    final secondary = AppTextStyles.label.copyWith(
      color: AppColors.textSecondary,
    );
    final returned = student.status == ExchangeStatus.returned;
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
                radius: 28,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: AppTextStyles.title),
                    Text(
                      '${student.department} · ${student.homeUniversity}',
                      style: secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(icon: Icons.school_outlined, text: student.hostUniversity),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(
            icon: Icons.place_outlined,
            text: '${student.hostCity}, ${student.hostCountry}',
          ),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(icon: Icons.event_outlined, text: student.term),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              Chip(
                avatar: Icon(
                  returned ? Icons.flight_land : Icons.flight_takeoff,
                  size: 18,
                ),
                label: Text(student.status.label),
                visualDensity: VisualDensity.compact,
              ),
              if (onConnect != null)
                requested
                    ? OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check),
                        label: const Text('Requested'),
                      )
                    : FilledButton.icon(
                        onPressed: onConnect,
                        icon: const Icon(Icons.person_add_alt_1_outlined),
                        label: const Text('Connect'),
                      ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18, color: AppColors.secondary),
      const SizedBox(width: AppSpacing.sm),
      Expanded(child: Text(text, style: AppTextStyles.label)),
    ],
  );
}
