import 'package:erasmus_hub/core/data/place_data.dart';
import 'package:erasmus_hub/features/places/places_store.dart';
import 'package:erasmus_hub/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart' show openApp;

void main() {
  setUp(placesStore.reset);

  void largePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('Places lists cards, filters by category and removes a card', (
    tester,
  ) async {
    largePhone(tester);
    await openApp(tester, path: '/places');
    expect(find.text('Café Linné'), findsOneWidget);

    final study = find.widgetWithText(ChoiceChip, 'Study spot');
    await tester.ensureVisible(study);
    await tester.pumpAndSettle();
    await tester.tap(study);
    await tester.pumpAndSettle();
    expect(find.text('Carolina Rediviva Library'), findsOneWidget);
    expect(find.text('Café Linné'), findsNothing);

    final remove = find.byTooltip('Remove Carolina Rediviva Library');
    await tester.ensureVisible(remove);
    await tester.tap(remove);
    await tester.pumpAndSettle();
    expect(find.text('Carolina Rediviva Library'), findsNothing);
    expect(find.text('No places in this category yet.'), findsOneWidget);
    expect(placesStore.value.length, kPlaceholderPlaces.length - 1);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Carolina Rediviva Library'), findsOneWidget);
  });

  testWidgets('Add place shows inline errors, confirms, then adds the card', (
    tester,
  ) async {
    largePhone(tester);
    final router = await openApp(tester, path: '/places');
    await tester.tap(find.text('Add place'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/places/new');

    final submit = find.widgetWithText(FilledButton, 'Add place');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('This field is required.'), findsWidgets);
    expect(find.text('Choose a category.'), findsOneWidget);
    expect(find.text('Give the place 1 to 5 stars.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Fika Corner');
    await tester.enterText(fields.at(1), 'Uppsala');
    await tester.enterText(fields.at(2), 'Sweden');
    await tester.enterText(fields.at(3), 'Too short');
    await tester.enterText(fields.at(4), 'not a link');
    await tester.tap(find.byType(DropdownButtonFormField<PlaceCategory>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Café').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Rate 4 of 5 stars'));
    await tester.tap(find.byTooltip('Rate 4 of 5 stars'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('Enter at least 10 characters.'), findsOneWidget);
    expect(
      find.text('Enter a link starting with http:// or https://'),
      findsOneWidget,
    );

    await tester.enterText(fields.at(3), 'Great cinnamon buns near campus.');
    await tester.enterText(fields.at(4), '');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('Add this place?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/places/new');

    await tester.tap(submit);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Add place'),
      ),
    );
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/places');
    expect(find.text('Fika Corner'), findsOneWidget);
    expect(placesStore.value.first.name, 'Fika Corner');
  });
}
