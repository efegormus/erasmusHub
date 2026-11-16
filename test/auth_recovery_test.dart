import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart' show openApp;

void main() {
  testWidgets('Forgot password validates email and locks resend for 3 min', (
    tester,
  ) async {
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
      'rumeysa@sabanciuniv.edu',
    );
    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    expect(find.textContaining('If an account exists'), findsOneWidget);
    expect(find.text('Resend in 3:00'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Resend in 2:59'), findsOneWidget);
    await tester.pump(const Duration(minutes: 3));
    expect(find.text('Resend link'), findsOneWidget);
  });

  testWidgets('Verify email resends with cooldown and opens Home', (
    tester,
  ) async {
    final router = await openApp(
      tester,
      path: '/verify-email?email=rumeysa%40sabanciuniv.edu',
    );
    expect(find.textContaining('rumeysa@sabanciuniv.edu'), findsOneWidget);

    await tester.tap(find.text('Resend email'));
    await tester.pump();
    expect(find.text('Verification email sent again.'), findsOneWidget);
    expect(find.text('Resend in 1:00'), findsOneWidget);
    await tester.pump(const Duration(seconds: 61));
    expect(find.text('Resend email'), findsOneWidget);

    await tester.tap(find.text("I've verified my email"));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/');
  });
}
