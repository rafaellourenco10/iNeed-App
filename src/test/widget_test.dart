// Teste básico do app iNeed
import 'package:flutter_test/flutter_test.dart';
import 'package:ineed_app/main.dart';

void main() {
  testWidgets('App deve iniciar sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(const INeedApp());
    // Verifica que a tela de onboarding aparece
    expect(find.text('Como podemos ajudar\nvocê hoje?'), findsOneWidget);
  });
}
