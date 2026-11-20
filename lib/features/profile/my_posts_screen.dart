import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/posts_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/profile/profile_store.dart';

/// Shows posts created by the currently signed-in profile.
class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = profileStore.value;
    final posts = placeholderPosts
        .where((post) => post.authorId == profile.id)
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: const Text('My posts')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: posts.isEmpty
                ? const Center(
                    child: Text('You have not published any posts yet.'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        child: ListTile(
                          title: Text(post.title),
                          subtitle: Text(
                            '${post.universityName} · ${post.term}\n'
                            '${post.program.label} · '
                            '${post.comments.length} comments',
                          ),
                          isThreeLine: true,
                          onTap: () => context.push(AppRoutes.post(post.id)),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
