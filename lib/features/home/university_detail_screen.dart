import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/university_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/post.dart';
import '../../models/university.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/star_rating.dart';
import 'widgets/rating_bar_row.dart';
import 'widgets/university_image.dart';

/// University detail (screen 07): banner, average ratings per category,
/// posts about the university and a "Write post" action.
class UniversityDetailScreen extends StatefulWidget {
  const UniversityDetailScreen({super.key, required this.universityId});

  final String universityId;

  @override
  State<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  bool _showPlaces = false;

  Future<void> _openPost(String postId) async {
    await context.push(AppRoutes.post(postId));
    // Comment counts may have changed on the post page.
    if (mounted) setState(() {});
  }

  Future<void> _writePost() async {
    await context.push(AppRoutes.newPost(widget.universityId));
    // A published post is inserted into placeholderPosts.
    if (mounted) setState(() {});
  }

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
    final posts = postsForUniversity(university.id);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _back),
        title: Text(university.name),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _writePost,
        icon: const Icon(Icons.add),
        label: const Text('Write post'),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              // Bottom padding keeps the last card above the FAB.
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xxl * 2,
              ),
              children: [
                _Header(university: university),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    ChoiceChip(
                      label: const Text('Posts'),
                      selected: !_showPlaces,
                      onSelected: (_) => setState(() => _showPlaces = false),
                    ),
                    ChoiceChip(
                      label: const Text('Places'),
                      selected: _showPlaces,
                      onSelected: (_) => setState(() => _showPlaces = true),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_showPlaces)
                  EmptyState(
                    icon: Icons.place_outlined,
                    message:
                        'Cafés, food and sights in ${university.city} '
                        'are rated on the Places tab.',
                    actionLabel: 'Open Places',
                    onAction: () => context.go(AppRoutes.places),
                  )
                else if (posts.isEmpty)
                  const EmptyState(
                    icon: Icons.edit_note,
                    message: 'No posts yet. Be the first to share your '
                        'experience.',
                  )
                else
                  for (final post in posts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _PostSummaryCard(
                        post: post,
                        onTap: () => _openPost(post.id),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Great courses, hard housing / Onur · Fall 2025 · 2 comments"
class _PostSummaryCard extends StatelessWidget {
  const _PostSummaryCard({required this.post, required this.onTap});

  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final comments = post.comments.length;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${post.author} · ${post.term} · '
            '${comments == 1 ? '1 comment' : '$comments comments'}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
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
