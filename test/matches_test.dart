import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart' show openApp;

void main() {
  testWidgets('Matches filters students and sends a connection request', (
    tester,
  ) async {
    await openApp(tester, path: '/matches');
    expect(find.text('Elif Kaya'), findsOneWidget);
    expect(find.text('Can Demir'), findsOneWidget);
    // Bilkent student going to Uppsala: same destination as the user.
    await tester.scrollUntilVisible(
      find.text('Ayşe Çelik'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Ayşe Çelik'), findsOneWidget);
    // Koç student going to Barcelona matches neither filter.
    expect(find.text('Zeynep Arslan'), findsNothing);
    await tester.scrollUntilVisible(
      find.widgetWithText(ChoiceChip, 'Same university'),
      -300,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Same university'));
    await tester.pumpAndSettle();
    expect(find.text('Can Demir'), findsOneWidget);
    expect(find.text('Elif Kaya'), findsNothing);

    await tester.tap(find.text('Connect').first);
    await tester.pumpAndSettle();
    expect(find.text('Requested'), findsOneWidget);
    expect(find.textContaining('Connection request sent'), findsOneWidget);
  });
}
