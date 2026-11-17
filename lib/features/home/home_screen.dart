import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/university_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/university_card.dart';

/// Home (screen 06): forum-style list of host universities.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _openUniversity(String id) async {
    await context.push(AppRoutes.university(id));
    // Post counts and ratings may have changed (e.g. a new post).
    if (mounted) setState(() {});
  }

  Future<void> _openAddUniversity() async {
    await context.push(AppRoutes.addUniversity);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final universities = placeholderUniversities;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Find your destination',
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList.separated(
                itemCount: universities.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final university = universities[index];
                  return UniversityCard(
                    key: ValueKey(university.id),
                    university: university,
                    onTap: () => _openUniversity(university.id),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Center(
                  child: TextButton.icon(
                    onPressed: _openAddUniversity,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Can't find your university? Add it",
                      textAlign: TextAlign.center,
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
