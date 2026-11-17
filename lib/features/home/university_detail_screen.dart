import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/university_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/post.dart';
import '../../models/university.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/star_rating.dart';
import 'widgets/rating_bar_row.dart';
import 'widgets/university_image.dart';

/// University detail (screen 07): banner, average ratings per category.
class UniversityDetailScreen extends StatefulWidget {
  const UniversityDetailScreen({super.key, required this.universityId});

  final String universityId;

  @override
  State<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final university = universityById(widget.universityId);
    if (university == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _back),
          title: const Text('University detail'),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: EmptyState(
                icon: Icons.account_balance_outlined,
                message: 'This university is not available.',
                actionLabel: 'Back to Home',
                onAction: () => context.go(AppRoutes.home),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _back),
        title: Text(university.name),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [_Header(university: university)],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    final average = overallAverage(university.id);
    final postCount = postsForUniversity(university.id).length;
    final secondary = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: UniversityImage(imageUrl: university.imageUrl, iconSize: 48),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(university.location, style: secondary),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              average == null ? '–' : average.toStringAsFixed(1),
              style: AppTextStyles.heading.copyWith(
                fontSize: 32,
                color: AppColors.textPrimary,
              ),
            ),
            StarRating(value: average ?? 0, size: 20),
            Text(
              postCount == 1 ? '· 1 post' : '· $postCount posts',
              style: secondary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final category in RatingCategory.values)
          RatingBarRow(
            label: category.label,
            average: categoryAverage(university.id, category),
          ),
      ],
    );
  }
}
