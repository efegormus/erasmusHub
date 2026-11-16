import 'package:erasmus_hub/app.dart';
import 'package:erasmus_hub/core/data/profile_data.dart';
import 'package:erasmus_hub/core/router/app_router.dart';
import 'package:erasmus_hub/core/router/app_routes.dart';
import 'package:erasmus_hub/features/profile/profile_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<GoRouter> openProfile(
  WidgetTester tester, {
  Size size = const Size(360, 640),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final router = createAppRouter(initialLocation: AppRoutes.profile);
  addTearDown(router.dispose);
  await tester.pumpWidget(ErasmusHubApp(router: router));
  await tester.pumpAndSettle();
  return router;
}

Future<void> openEdit(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Edit profile'));
  await tester.tap(find.text('Edit profile'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => profileStore.update(kCurrentUser));

  for (final size in const [Size(320, 568), Size(360, 640), Size(430, 932)]) {
    testWidgets('Profile and Edit profile do not overflow at $size', (
      tester,
    ) async {
      await openProfile(tester, size: size, textScale: 1.3);
      expect(tester.takeException(), isNull);
      await openEdit(tester);
      expect(find.text('Save changes'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Removing an experience card works and can be undone', (
    tester,
  ) async {
    await openProfile(tester);
    await openEdit(tester);
    expect(find.text('TU Delft · Fall 2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove experience').first);
    await tester.pumpAndSettle();
    expect(find.text('TU Delft · Fall 2026'), findsNothing);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('TU Delft · Fall 2026'), findsOneWidget);
  });

  testWidgets('Edit form validates inline and confirms before returning', (
    tester,
  ) async {
    final router = await openProfile(tester);
    await openEdit(tester);
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.pump();
    expect(find.text('This field is required.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Ada Lovelace');
    await tester.ensureVisible(find.text('Save changes'));
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Profile updated'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AppRoutes.profile);
    expect(find.text('Ada Lovelace'), findsOneWidget);
  });

  testWidgets('Delete account asks for confirmation first', (tester) async {
    final router = await openProfile(tester);
    await openEdit(tester);
    await tester.ensureVisible(find.text('Delete account'));
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    expect(find.text('Delete your account?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AppRoutes.editProfile);
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AppRoutes.login);
  });
}
