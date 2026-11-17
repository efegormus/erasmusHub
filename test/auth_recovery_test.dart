import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart' show openApp;

void main() {
  testWidgets('Forgot password goes through its three states', (tester) async {
    await openApp(tester, path: '/forgot-password');
    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    expect(find.text('This field is required.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'me@gmail.com');
    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    expect(
      find.text('Please use your university email (.edu or .edu.tr).'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byType(TextFormField),
      'utku.batmaz@sabanciuniv.edu',
    );
    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    // State 2: link sent, resend locked.
    expect(find.text('Check your email'), findsOneWidget);
    expect(find.text('utku.batmaz@sabanciuniv.edu'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(find.text('03:00'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('02:59'), findsOneWidget);
    await tester.tap(find.text('Resend link'));
    await tester.pump();
    expect(find.text('A new reset link was sent.'), findsNothing);

    // State 3: resend available after three minutes.
    await tester.pump(const Duration(minutes: 3));
    expect(
      find.text('Did not get it? You can send the link again.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Resend link'));
    await tester.pump();
    expect(find.text('A new reset link was sent.'), findsOneWidget);
    expect(find.text('03:00'), findsOneWidget);
  });

  testWidgets('Verify email: waiting, not verified, resend and Home', (
    tester,
  ) async {
    final router = await openApp(
      tester,
      path: '/verify-email?email=utku.batmaz%40sabanciuniv.edu',
    );
    expect(find.text('utku.batmaz@sabanciuniv.edu'), findsOneWidget);
    expect(find.text('You can request a new link in 03:00'), findsOneWidget);

    await tester.tap(find.text('I verified my email'));
    await tester.pump();
    expect(
      find.text(
        'Your email is not verified yet. Please open the link we sent.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('You can request a new link'), findsNothing);

    await tester.tap(find.text('Resend link'));
    await tester.pump();
    expect(find.text('A new verification link was sent.'), findsOneWidget);
    expect(find.text('Verification link sent to'), findsOneWidget);

    await tester.tap(find.text('I verified my email'));
    await tester.pump();
    await tester.tap(find.text('I verified my email'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/');
  });

  testWidgets('Verify email: Change email goes back to sign up', (
    tester,
  ) async {
    final router = await openApp(tester, path: '/verify-email');
    expect(find.text('your university email'), findsOneWidget);
    await tester.tap(find.text('Change email'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/sign-up');
  });
}
