import 'package:erasmus_hub/shared/widgets/app_button.dart';
import 'package:erasmus_hub/shared/widgets/app_card.dart';
import 'package:erasmus_hub/shared/widgets/star_rating.dart';
import 'package:erasmus_hub/shared/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Loading button prevents duplicate taps', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Save',
            isLoading: true,
            onPressed: () => calls++,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(FilledButton));
    expect(calls, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('Card tap and controlled rating input are accessible', (
    tester,
  ) async {
    var taps = 0;
    var rating = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AppCard(onTap: () => taps++, child: const Text('University')),
              StarRating(value: 2, onChanged: (value) => rating = value),
              const StarRating(value: 4.5),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('University'));
    await tester.tap(find.byTooltip('Rate 5 of 5 stars'));
    expect(taps, 1);
    expect(rating, 5);
    expect(find.byIcon(Icons.star_half), findsOneWidget);
  });
  testWidgets(
    'Avatar uses initials, empty-name fallback and failed-image fallback',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                UserAvatar(name: ' Onur Utku Batmaz '),
                UserAvatar(name: '  '),
                UserAvatar(
                  name: 'Efe Görmüş',
                  imageUrl: 'https://invalid.example/avatar.png',
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('OB'), findsOneWidget);
      expect(find.text('?'), findsOneWidget);
      expect(find.text('EG'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
