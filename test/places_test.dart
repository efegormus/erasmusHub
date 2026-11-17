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

  Future<void> pickFromDropdown<T>(
    WidgetTester tester,
    Finder dropdown,
    String option,
  ) async {
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  testWidgets('Places filters by city and category and removes a card', (
    tester,
  ) async {
    largePhone(tester);
    await openApp(tester, path: '/places');
    expect(find.text('Dok Coffee'), findsOneWidget);
    expect(find.text('Café · Delft'), findsWidgets);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('Café Linné'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Sights'));
    await tester.pumpAndSettle();
    expect(find.text('Oude Kerk'), findsOneWidget);
    expect(find.text('Dok Coffee'), findsNothing);

    await tester.tap(find.byTooltip('Remove Oude Kerk'));
    await tester.pumpAndSettle();
    expect(find.text('Oude Kerk'), findsNothing);
    expect(find.text('No Sights places rated in Delft yet.'), findsOneWidget);
    expect(placesStore.value.length, kPlaceholderPlaces.length - 1);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Oude Kerk'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await pickFromDropdown<String>(
      tester,
      find.byType(DropdownButtonFormField<String>),
      'Uppsala',
    );
    expect(find.text('Café Linné'), findsOneWidget);
    expect(find.text('Dok Coffee'), findsNothing);

    await pickFromDropdown<String>(
      tester,
      find.byType(DropdownButtonFormField<String>),
      'Lund',
    );
    expect(find.text('No places rated in Lund yet.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.widgetWithText(OutlinedButton, 'Add place'), findsOneWidget);
  });

  testWidgets('Add place shows inline errors, then a Place added dialog', (
    tester,
  ) async {
    largePhone(tester);
    final router = await openApp(tester, path: '/places');
    await tester.tap(find.text('Add place'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/places/new');

    final save = find.widgetWithText(FilledButton, 'Save place');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Place name is required.'), findsOneWidget);
    expect(find.text('Choose a city.'), findsOneWidget);
    expect(find.text('Choose a category.'), findsOneWidget);
    expect(find.text('Give 1 to 5 stars.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(find.byType(TextFormField).first, 'Fika Corner');
    await pickFromDropdown<String>(
      tester,
      find.byType(DropdownButtonFormField<String>),
      'Uppsala',
    );
    await pickFromDropdown<PlaceCategory>(
      tester,
      find.byType(DropdownButtonFormField<PlaceCategory>),
      'Café',
    );
    await tester.ensureVisible(find.byTooltip('Rate 4 of 5 stars'));
    await tester.tap(find.byTooltip('Rate 4 of 5 stars'));
    await tester.enterText(find.byType(TextFormField).last, 'Cinnamon buns');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('Place added'), findsOneWidget);
    expect(
      find.text('Thanks! Your rating is now on the Uppsala list.'),
      findsOneWidget,
    );
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/places');
    expect(find.text('Fika Corner'), findsOneWidget);
    expect(find.text('Café · Uppsala'), findsWidgets);
    expect(placesStore.value.first.comment, 'Cinnamon buns');
  });
}
