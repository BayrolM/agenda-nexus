import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('App should render', (WidgetTester tester) async {
    await tester.pumpWidget(const AgendaNexusApp());
    expect(find.byType(AgendaNexusApp), findsOneWidget);
  });
}
