import 'package:flutter/material.dart';

import '../../core/router/app_routes.dart';
import '../../shared/screens/placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => PlaceholderScreen(
    title: 'Find your destination',
    showBack: false,
    links: {
      'University detail': AppRoutes.university('preview'),
      'Add university': AppRoutes.addUniversity,
    },
  );
}
