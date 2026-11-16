import 'package:flutter/material.dart';

import '../../core/data/profile_data.dart';
import '../../core/data/student_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/student.dart';
import 'student_card.dart';

enum _MatchFilter {
  all('All'),
  destination('Same destination'),
  university('Same university');

  const _MatchFilter(this.label);
  final String label;
}

/// Matches (12): students with the same destination or home university.
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  _MatchFilter _filter = _MatchFilter.all;
  final _requested = <String>{};

  static final _myCities = {
    for (final e in kCurrentUser.experiences) e.city.toLowerCase(),
  };

  static bool _sameDestination(Student s) =>
      _myCities.contains(s.hostCity.toLowerCase());

  static bool _sameUniversity(Student s) =>
      s.homeUniversity == kCurrentUser.homeUniversity;

  List<Student> get _visible => kPlaceholderStudents.where((s) {
    return switch (_filter) {
      _MatchFilter.all => _sameDestination(s) || _sameUniversity(s),
      _MatchFilter.destination => _sameDestination(s),
      _MatchFilter.university => _sameUniversity(s),
    };
  }).toList();

  void _connect(Student student) {
    setState(() => _requested.add(student.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Connection request sent to ${student.name}')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final students = _visible;
    return Scaffold(
      appBar: AppBar(title: const Text('Matches')),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Students going to your cities or from your university.',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    for (final f in _MatchFilter.values)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: ChoiceChip(
                          label: Text(f.label),
                          selected: _filter == f,
                          onSelected: (_) => setState(() => _filter = f),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (students.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'No matches yet. Check back later.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                sliver: SliverList.separated(
                  itemCount: students.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: StudentCard(
                        student: students[i],
                        requested: _requested.contains(students[i].id),
                        onConnect: () => _connect(students[i]),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
