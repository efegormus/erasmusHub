import 'package:erasmus_hub/app.dart';
import 'package:erasmus_hub/core/router/app_router.dart';
import 'package:erasmus_hub/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<GoRouter> openApp(WidgetTester tester, {String path = '/login'}) async {
  final router = createAppRouter(initialLocation: path);
  addTearDown(router.dispose);
  await tester.pumpWidget(ErasmusHubApp(router: router));
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('Login validates inline, toggles visibility and opens Home', (
    tester,
  ) async {
    final router = await openApp(tester);
    expect(find.text('Exchange stories from students'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required.'), findsNWidgets(2));
    await tester.enterText(
      find.byType(TextFormField).first,
      'student@gmail.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'short');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(
      find.text('Please use your university email (.edu or .edu.tr).'),
      findsOneWidget,
    );
    expect(find.text('Enter at least 8 characters.'), findsOneWidget);
    expect(router.state.uri.path, '/login');
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isFalse,
    );
    await tester.enterText(
      find.byType(TextFormField).first,
      ' student@sabanciuniv.edu ',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'prototype-password',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/');
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Find your destination'), findsOneWidget);
  });

  testWidgets('Forgot password and both existing signup steps are connected', (
    tester,
  ) async {
    final router = await openApp(tester);
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(find.text('Forgot password'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'student@mit.edu');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AppRoutes.signUpProfile);
    await tester.tap(find.text('+ University not listed? Add it'));
    await tester.pumpAndSettle();
    expect(find.text('Add university'), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Your profile'), findsOneWidget);
  });

  testWidgets(
    'Shell preserves tab stacks; form overlays hide it; logout returns to login',
    (tester) async {
      final router = await openApp(tester, path: '/');
      await tester.tap(find.text('University detail'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/universities/preview');
      await tester.tap(find.text('Places').last);
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1,
      );
      await tester.tap(find.text('Add place'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
      router.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home').last);
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/universities/preview');
      await tester.tap(find.text('Home').last);
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/');
      await tester.tap(find.text('Matches').last);
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        2,
      );
      await tester.tap(find.text('Profile').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/login');
      expect(find.byType(NavigationBar), findsNothing);
    },
  );

  const routes = {
    '/login': 'ErasmusHub',
    '/forgot-password': 'Forgot password',
    '/sign-up': 'Sign up',
    '/sign-up/profile': 'Your profile',
    '/verify-email': 'Verify your email',
    '/': 'Find your destination',
    '/universities/example': 'University detail',
    '/posts/example': 'Post detail',
    '/posts/new?universityId=example': 'New post',
    '/places': 'Places',
    '/places/new': 'Add place',
    '/matches': 'Matches',
    '/profile': 'Profile',
    '/profile/edit': 'Edit profile',
    '/profile/exchanges/new': 'Add exchange',
    '/add-university': 'Add university',
    '/missing': 'Page not found',
  };
  for (final entry in routes.entries) {
    testWidgets('Direct link ${entry.key} resolves', (tester) async {
      await openApp(tester, path: entry.key);
      expect(find.text(entry.value), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'Login scrolls on small screen with large text, errors and keyboard',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 240);
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await openApp(tester);
      await tester.ensureVisible(find.text('Log in'));
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sign up'));
      expect(tester.takeException(), isNull);
    },
  );
}
