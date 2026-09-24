import 'package:flutter_test/flutter_test.dart';
import 'package:personality/main.dart';

void main() {
  testWidgets('app boots', (tester) async {
    await tester.pumpWidget(const PersonalityApp());
    expect(find.text('Personality'), findsOneWidget);
  });
}
