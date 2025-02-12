import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart'; // Ajuste o caminho conforme necessário

void main() {
  setUpAll(() async {
    // Inicializa o SharedPreferences e simula o userId para todos os testes
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_Id', 'test_user_id');  // Simula o userId fixo
  });

  testWidgets('Testa criação de nova lista de mercado', (WidgetTester tester) async {
    // Cria o widget da tela
    await tester.pumpWidget(MaterialApp(
      home: ScreenListasMercado(),
    ));

    // Adicione a interação com o widget, por exemplo, clicar em um botão
    // Exemplo de interação: clicar no botão de criação de lista (ajuste conforme sua interface)
    // await tester.tap(find.byType(ElevatedButton));  // Se o botão for ElevatedButton
    // await tester.pumpAndSettle();  // Aguarda animações e transições

    // Asserção: verificar se a tela está mostrando o conteúdo correto
    // Por exemplo, verificar se o nome de um supermercado está presente
    expect(find.text('Supermercado A'), findsOneWidget);  // Ajuste conforme necessário
  });

  testWidgets('Testa exibição das listas de mercado', (WidgetTester tester) async {
    // Cria o widget da tela
    await tester.pumpWidget(MaterialApp(
      home: ScreenListasMercado(),
    ));

    // Realiza uma interação para verificar a exibição da lista
    // Exemplo de asserção: verificar se o supermercado está visível
    expect(find.text('Supermercado A'), findsOneWidget);  // Ajuste conforme necessário
  });

  testWidgets('Testa exclusão de uma lista de mercado', (WidgetTester tester) async {
    // Cria o widget da tela
    await tester.pumpWidget(MaterialApp(
      home: ScreenListasMercado(),
    ));

    // Realize a interação para excluir a lista (ajuste conforme sua tela)
    // Exemplo de interação: clicar no ícone de excluir (ajuste conforme a UI)
    // await tester.tap(find.byIcon(Icons.delete));  // Se usar um ícone de exclusão
    // await tester.pumpAndSettle();  // Aguarda animações e transições

    // Asserção após a exclusão: verifica se o texto foi removido
    expect(find.text('Supermercado A'), findsNothing);  // Ajuste conforme sua lógica
  });

}
