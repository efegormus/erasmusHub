import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart' show openApp;

void main() {
  Future<void> pick(WidgetTester tester, int dropdown, String option) async {
    await tester.tap(find.byType(DropdownButtonFormField<String>).at(dropdown));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  testWidgets('Matches shows returned students for university and department', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await openApp(tester, path: '/matches');

    expect(find.text('TU Delft'), findsOneWidget);
    expect(find.text('Computer Science'), findsOneWidget);
    expect(find.text('Rümeysa Ş.'), findsOneWidget);
    expect(find.text('İbrahim Halil A.'), findsOneWidget);
    // Same university, other department.
    expect(find.text('Elif K.'), findsNothing);
    expect(find.text('Returned'), findsNWidgets(2));
    expect(find.text('Phone'), findsOneWidget);
    expect(
      find.text('Contact links are visible to signed-in students only.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Phone'));
    await tester.pumpAndSettle();
    expect(find.text('Phone: +90 555 000 00 01'), findsOneWidget);

    await pick(tester, 0, 'Uppsala University');
    // Mert returned; Can is still planning and is hidden.
    expect(find.text('Mert Y.'), findsOneWidget);
    expect(find.text('Can D.'), findsNothing);

    await pick(tester, 0, 'Lund University');
    expect(
      find.text(
        'No returned students from this university and department yet.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Browse other universities'));
    await tester.pumpAndSettle();
    expect(find.text('Find your destination'), findsOneWidget);
  });
}
