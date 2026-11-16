import 'package:erasmus_hub/features/places/places_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart' show openApp;

/// Small (360×640, also 320×568 with large text) and large (430×932) portrait
/// phones must render these screens without overflow errors.
void main() {
  setUp(placesStore.reset);

  const screens = [
    '/places',
    '/places/new',
    '/matches',
    '/forgot-password',
    '/verify-email',
  ];
  const sizes = {
    'small 360x640': (Size(360, 640), 1.0),
    'tiny 320x568 large text': (Size(320, 568), 1.3),
    'large 430x932': (Size(430, 932), 1.0),
  };

  for (final screen in screens) {
    for (final size in sizes.entries) {
      testWidgets('$screen has no overflow on ${size.key}', (tester) async {
        tester.view.physicalSize = size.value.$1;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = size.value.$2;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await openApp(tester, path: screen);
        // Scroll through the whole screen so every card is laid out.
        final scrollable = find.byType(Scrollable).first;
        for (var i = 0; i < 10; i++) {
          await tester.drag(scrollable, const Offset(0, -300));
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Add place errors fit on a small phone', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await openApp(tester, path: '/places/new');
    final submit = find.widgetWithText(FilledButton, 'Add place');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
