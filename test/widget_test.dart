import 'package:erasmus_hub/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Root route opens the home screen', (tester) async {
    await tester.pumpWidget(const ErasmusHubApp());
    await tester.pumpAndSettle();
    expect(find.text('ErasmusHub'), findsOneWidget);
    expect(find.text('Your exchange journey starts here.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
