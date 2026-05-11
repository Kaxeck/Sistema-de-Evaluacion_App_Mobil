import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_de_evaluacion/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EvaluacionApp());

    // Verify that the app starts successfully by finding the title.
    expect(find.text('Sistema de Evaluación'), findsOneWidget);
  });
}
