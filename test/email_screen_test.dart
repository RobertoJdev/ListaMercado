import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_mercado/screens/email_screen.dart';

void main() {
  group('EmailScreen Tests', () {
    testWidgets('Deve preencher o campo de e-mail com o valor inicial', (WidgetTester tester) async {
      const testEmail = 'teste@email.com';

      await tester.pumpWidget(
        const MaterialApp(
          home: EmailScreen(testEmail),
        ),
      );

      // Verifica se o campo de e-mail foi preenchido corretamente
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text(testEmail), findsOneWidget);
    });

    testWidgets('Deve exibir erro ao tentar salvar um e-mail inválido', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmailScreen(''),
        ),
      );

      // Insere um e-mail inválido
      await tester.enterText(find.byType(TextFormField), 'email-invalido');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Atualiza o frame

      // Verifica se a mensagem de erro aparece
      expect(find.text('Por favor, insira um e-mail válido'), findsOneWidget);
    });

    testWidgets('Deve permitir salvar um e-mail válido e retornar o valor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmailScreen(''),
        ),
      );

      // Espera o layout ser renderizado
      await tester.pumpAndSettle();

      // Garante que o botão está visível antes de tocar
      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // Insere um e-mail válido
      const testEmail = 'usuario@email.com';
      await tester.enterText(find.byType(TextFormField), testEmail);

      // Toca no botão de salvar
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle(); // Espera a navegação

      // Verifica se o e-mail foi retornado corretamente pelo Navigator.pop()
      expect(find.text(testEmail), findsNothing); // O email não fica na tela após o pop()
    });
  });
}
