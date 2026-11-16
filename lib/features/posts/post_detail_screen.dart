import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/posts_data.dart';
import '../../core/data/profile_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/comment.dart';
import '../../models/post.dart';
import '../../shared/widgets/app_card.dart';
import 'widgets/comment_tile.dart';
import 'widgets/rating_row.dart';
import 'widgets/report_dialog.dart';

/// Post detail (screen 08): ratings, courses, tip and comments.
class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();
  late final Post? _post = postById(widget.postId);

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool get _canSend => _commentController.text.trim().isNotEmpty;

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _post!.comments.add(
        Comment(
          id: 'c${DateTime.now().microsecondsSinceEpoch}',
          author: kCurrentUser.name,
          text: text,
        ),
      );
      _commentController.clear();
    });
  }

  Future<void> _report() async {
    final reason = await showReportDialog(context);
    if (reason == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thanks. Moderators will review this post.'),
      ),
    );
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
    final post = _post;
    if (post == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _back),
          title: const Text('Post'),
        ),
        body: const Center(child: Text('This post is not available.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _back),
        title: Text(post.universityName),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'More options',
            onSelected: (_) => _report(),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'report', child: Text('Report')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      _PostCard(post: post),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Comments (${post.comments.length})',
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final comment in post.comments)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: CommentTile(comment: comment),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: TextField(
                    controller: _commentController,
                    textInputAction: TextInputAction.send,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _addComment(),
                    decoration: InputDecoration(
                      hintText: 'Write a comment…',
                      filled: true,
                      fillColor: AppColors.surface,
                      suffixIcon: IconButton(
                        tooltip: 'Send comment',
                        icon: const Icon(Icons.send),
                        onPressed: _canSend ? _addComment : null,
                      ),
                    ),
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

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(post.title, style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${post.author} · ${post.term} · ${post.major}',
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final category in RatingCategory.values)
          RatingRow(label: category.label, value: post.ratingFor(category)),
        const SizedBox(height: AppSpacing.sm),
        if (post.courses.isNotEmpty)
          Text(
            'Courses: ${post.courses.join(', ')}',
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
          ),
        if (post.tip.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tip: ${post.tip}',
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    ),
  );
}
