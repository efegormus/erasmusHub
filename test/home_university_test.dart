import 'package:erasmus_hub/core/data/university_data.dart';
import 'package:erasmus_hub/core/theme/app_theme.dart';
import 'package:erasmus_hub/features/home/add_university_screen.dart';
import 'package:erasmus_hub/features/home/home_screen.dart';
import 'package:erasmus_hub/features/home/university_detail_screen.dart';
import 'package:erasmus_hub/features/home/widgets/university_card.dart';
import 'package:erasmus_hub/models/university.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Mehmet's screens with a small local router, so the tests do not depend
/// on how the shared app router is wired.
Future<GoRouter> openScreens(WidgetTester tester, String path) async {
  final router = GoRouter(
    initialLocation: path,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'universities/:id',
            builder: (context, state) => UniversityDetailScreen(
              universityId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/add-university',
        builder: (context, state) => const AddUniversityScreen(),
      ),
      GoRoute(
        path: '/posts/new',
        builder: (context, state) => const Scaffold(body: Text('New post')),
      ),
      GoRoute(
        path: '/posts/:id',
        builder: (context, state) => const Scaffold(body: Text('Post page')),
      ),
      GoRoute(
        path: '/places',
        builder: (context, state) => const Scaffold(body: Text('Places page')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light, routerConfig: router),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  late List<University> original;
  setUp(() => original = List.of(placeholderUniversities));
  tearDown(
    () => placeholderUniversities
      ..clear()
      ..addAll(original),
  );

  testWidgets('Home lists universities and search narrows the list', (
    tester,
  ) async {
    await openScreens(tester, '/');
    expect(find.text('Find your destination'), findsOneWidget);
    expect(find.byType(UniversityCard), findsWidgets);
    await tester.enterText(find.byType(TextField), 'delft');
    await tester.pumpAndSettle();
    expect(find.byType(UniversityCard), findsOneWidget);
    expect(find.text('TU Delft'), findsOneWidget);
  });

  testWidgets('Home shows empty state that opens Add university', (
    tester,
  ) async {
    final router = await openScreens(tester, '/');
    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('No results for “zzzz”'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Add university'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/add-university');
  });

  testWidgets('Country filter keeps only that country', (tester) async {
    await openScreens(tester, '/');
    await tester.tap(find.text('Country'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sweden').last);
    await tester.pumpAndSettle();
    expect(find.byType(UniversityCard), findsNWidgets(2));
    expect(find.text('Uppsala University'), findsOneWidget);
    expect(find.text('Lund University'), findsOneWidget);
  });

  testWidgets('Tapping a card opens University detail with its posts', (
    tester,
  ) async {
    final router = await openScreens(tester, '/');
    await tester.enterText(find.byType(TextField), 'delft');
    await tester.pumpAndSettle();
    await tester.tap(find.text('TU Delft'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/universities/tu-delft');
    expect(find.text('Delft, Netherlands'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Great courses, hard housing'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Great courses, hard housing'), findsOneWidget);
    await tester.tap(find.text('Write post'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/posts/new');
    expect(router.state.uri.queryParameters['universityId'], 'tu-delft');
  });

  testWidgets('Detail without posts shows the empty state', (tester) async {
    await openScreens(tester, '/universities/ku-leuven');
    await tester.scrollUntilVisible(
      find.textContaining('No posts yet'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      find.text('No posts yet. Be the first to share your experience.'),
      findsOneWidget,
    );
  });

  testWidgets('Unknown university id is recoverable', (tester) async {
    await openScreens(tester, '/universities/nowhere');
    expect(find.text('This university is not available.'), findsOneWidget);
  });

  testWidgets('Add university validates, rejects duplicates and confirms', (
    tester,
  ) async {
    final router = await openScreens(tester, '/');
    router.push('/add-university');
    await tester.pumpAndSettle();
    final submit = find.widgetWithText(FilledButton, 'Add university');

    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('This field is required.'), findsNWidgets(2));
    expect(find.text('Please select a country.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'tu delft');
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('This university is already in the list.'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'University of Graz',
    );
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Austria').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'Graz');
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('University added'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/');
    expect(universityNameExists('University of Graz'), isTrue);
  });

  for (final size in [const Size(320, 568), const Size(360, 640)]) {
    for (final path in ['/', '/universities/tu-delft', '/add-university']) {
      testWidgets('$path fits $size with enlarged text', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await openScreens(tester, path);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
