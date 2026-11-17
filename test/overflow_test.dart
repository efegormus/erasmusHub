import 'package:erasmus_hub/app.dart';
import 'package:erasmus_hub/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const paths = [
    '/login',
    '/forgot-password',
    '/sign-up',
    '/sign-up/profile',
    '/verify-email',
    '/',
    '/universities/tu-delft',
    '/posts/post1',
    '/posts/new?universityId=tu-delft',
    '/places',
    '/places/new',
    '/matches',
    '/profile',
    '/profile/edit',
    '/profile/exchanges/new',
    '/add-university',
  ];
  for (final size in [
    const Size(320, 568),
    const Size(360, 640),
    const Size(430, 932),
  ]) {
    for (final path in paths) {
      testWidgets('$path fits $size with enlarged text', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final router = createAppRouter(initialLocation: path);
        addTearDown(router.dispose);
        await tester.pumpWidget(ErasmusHubApp(router: router));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
  for (final path in ['/posts/post1', '/posts/new', '/profile/exchanges/new']) {
    testWidgets('$path fits with the keyboard visible', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 240);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final router = createAppRouter(initialLocation: path);
      addTearDown(router.dispose);
      await tester.pumpWidget(ErasmusHubApp(router: router));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
