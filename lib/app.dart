import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class ErasmusHubApp extends StatelessWidget {
  const ErasmusHubApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'ErasmusHub',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: appRouter,
  );
}
