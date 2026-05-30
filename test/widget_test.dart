import 'package:flutter_test/flutter_test.dart';
import 'package:midmaar/main.dart';

void main() {
  testWidgets('shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MidmaarApp());

    expect(find.text('MIDMAAR'), findsOneWidget);
  });
}
