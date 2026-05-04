import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('Weather app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());
    // Verify the app renders without crashing
    expect(find.text('Weather'), findsOneWidget);
  });
}
