import 'package:flutter_test/flutter_test.dart';
import 'package:smartlib/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartLibApp());
    expect(find.text('Home'), findsOneWidget);
  });
}
