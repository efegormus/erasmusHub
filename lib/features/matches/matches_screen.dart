import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/posts_data.dart';
import '../../core/data/profile_data.dart';
import '../../core/data/student_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/student.dart';
import '../../models/user_profile.dart';
import 'student_card.dart';

/// Matches (12): students with at least one Returned exchange at the chosen
/// host university and the same department (wireframe page 13).
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  static final _universities = [
    for (final university in kHostUniversities) university.name,
  ];
  static final _departments = {
    kCurrentUser.major,
    for (final student in kPlaceholderStudents) student.department,
  }.toList()..sort();

  String _university = _universities.first;
  String _department = kCurrentUser.major;

  List<Student> get _matches => kPlaceholderStudents
      .where(
        (s) =>
            s.status == ExchangeStatus.returned &&
            s.hostUniversity == _university &&
            s.department == _department,
      )
      .toList();

  void _showContact(String label, String value) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label: $value')));
  }

  @override
  Widget build(BuildContext context) {
    final students = _matches;
    return Scaffold(
      appBar: AppBar(title: const Text('Matches')),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _picker(
                      label: 'Host university',
                      value: _university,
                      options: _universities,
                      onChanged: (v) => setState(() => _university = v),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _picker(
                      label: 'Department',
                      value: _department,
                      options: _departments,
                      onChanged: (v) => setState(() => _department = v),
                    ),
                  ],
                ),
              ),
            ),
            if (students.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.groups,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'No returned students from this university and '
                        'department yet.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton(
                        onPressed: () => context.go(AppRoutes.home),
                        child: const Text('Browse other universities'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList.separated(
                  itemCount: students.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: StudentCard(
                        student: students[i],
                        onContact: _showContact,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Contact links are visible to signed-in students only.',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _picker({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label, style: AppTextStyles.label),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: [
          for (final option in options)
            DropdownMenuItem(value: option, child: Text(option)),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    ],
  );
}
