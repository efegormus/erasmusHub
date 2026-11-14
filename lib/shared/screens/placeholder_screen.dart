import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../widgets/app_button.dart';

/// Route scaffolding only. Feature owners replace the body with the PDF screen.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.detail,
    this.links = const {},
    this.fallback = AppRoutes.home,
    this.showBack = true,
  });
  final String title;
  final String? detail;
  final Map<String, String> links;
  final String fallback;
  final bool showBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      leading: showBack
          ? BackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(fallback);
                }
              },
            )
          : null,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'This screen is coming soon.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (detail != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(detail!),
                  ),
                for (final link in links.entries)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: AppButton(
                      label: link.key,
                      outlined: true,
                      onPressed: () => context.push(link.value),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
