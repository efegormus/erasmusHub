import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_profile.dart';
import '../../shared/widgets/user_avatar.dart';
import 'profile_store.dart';
import 'widgets/experience_card.dart';

/// Profile (view mode): details, experiences and contact links.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ValueListenableBuilder<UserProfile>(
          valueListenable: profileStore,
          builder: (context, profile, _) {
            String shown(String value) => value;
            final contacts = <String>[
              'Instagram: ${shown(profile.instagram)}',
              'LinkedIn: ${shown(profile.linkedin)}',
              'Phone: ${shown(profile.phone)}',
            ];
            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          UserAvatar(name: profile.name, radius: 32),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.name, style: AppTextStyles.title),
                                const SizedBox(height: AppSpacing.xs),
                                Chip(label: Text(profile.status.label)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _InfoRow(
                        label: 'Home university',
                        value: profile.homeUniversity,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(
                        label: 'Major · Double major / minor',
                        value: profile.minor.isEmpty
                            ? profile.major
                            : '${profile.major} · ${profile.minor}',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Erasmus+/Exchange Experiences',
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (profile.experiences.isEmpty)
                        Text(
                          'No experiences yet.',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                      else
                        for (final experience in profile.experiences)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: ExperienceCard(experience: experience),
                          ),
                      if (contacts.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text('Contact links', style: AppTextStyles.title),
                        const SizedBox(height: AppSpacing.sm),
                        for (final line in contacts)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: Text(line, style: AppTextStyles.body),
                          ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton(
                        onPressed: () => context.push(AppRoutes.editProfile),
                        child: const Text('Edit profile'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'My posts will be available later.',
                                ),
                              ),
                            ),
                        child: const Text('My posts'),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}
