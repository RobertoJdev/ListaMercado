import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

mixin TestePrintMixin {
  static void printListaMercadoInfo(ListaMercado listaMercado) {
    print(
        ' ---------------- Informações da Lista de Mercado: ----------------- ');

    print("Lista.Id:              ${listaMercado.id}");
    print("Lista.userEmail:       ${listaMercado.userEmail}");
    print("Lista.isShared:        ${listaMercado.isShared}");
    print("Lista.sharedWithEmail: ${listaMercado.sharedWithEmail}");
    print("Lista.custoTotal:      ${listaMercado.custoTotal}");
    print("Lista.data:            ${listaMercado.data}");
    print("Lista.supermercado:    ${listaMercado.supermercado}");
    print("Lista.finalizada:      ${listaMercado.finalizada}");
    print("Lista.createdAt:       ${listaMercado.createdAt}");
    print("Lista.updatedAt:       ${listaMercado.updatedAt}");
    print("Lista.isSynced:        ${listaMercado.isSynced}");
    print("Lista.uniqueKey:       ${listaMercado.uniqueKey}");

    for (var produto in listaMercado.itens) {
      print(
        'Item: ${produto.descricao}, Preço Atual: ${produto.precoAtual}, Histórico de Preços: ${[
          ...produto.historicoPreco
        ]}',
      );
    }
  }

  static Future<void> printHistoricoPreco(
      Produto produto, String nomeFuncao) async {
// Imprimir o histórico de preços do produto

    print(
        '++++++++++++++++++++++++++++ $nomeFuncao ++++++++++++++++++++++++++++');

    print('Histórico de Preços para o produto ${produto.descricao}:');

    for (var price in produto.historicoPreco) {
      print('Preço: $price');
    }
  }

  static Future<void> printAllItemsBD(List<ListaMercado> listMarket) async {
    print(
        '********************------------------ PrintAllItemsBD ------------------********************');
    if (listMarket.isNotEmpty) {
      for (var item in listMarket) {
        // Impressão dos dados principais de cada item
        print('ID: ${item.id}');
        print('User ID: ${item.userId}');
        print('Total Cost: ${item.custoTotal}');
        print('Data: ${item.data}');
        print('Supermarket: ${item.supermercado}');
        print('Finished: ${item.finalizada}');
        //print('Shared: ${item.compartilhada}');
        //print('Shared with: ${item.emailCompartilhado}');

        for (var product in item.itens) {
          // Impressão dos dados do produto
          //print('Produto ID: ${product.id}');
          print('Descrição: ${product.descricao}');
          print('Código de Barras: ${product.barras}');
          print('Quantidade: ${product.quantidade}');
          print('Pendente: ${product.pendente}');
          print('Preço Atual: ${product.precoAtual}');
        }
      }
    } else {
      print('A lista de mercado não está vazia.');
    }
  }

  static testeGenerico(String componente, String erro) {
    print(
        "*******************************************************************");
    print("Chamada para teste de: $componente, para correção de erro: $erro");
    print(
        "*******************************************************************");
  }

  static returnFireBase(dynamic snapshot) {
    // Verificar se algum documento foi retornado
    if (snapshot.docs.isNotEmpty) {
      // Iterar sobre os documentos e imprimir seus dados
      snapshot.docs.forEach((doc) {
        // Obter os dados do documento
        var data = doc.data();

        print("userId: ${data['userId']}");
        print("userEmail: ${data['userEmail']}");
        print("isShared: ${data['isShared']}");
        print("sharedWithEmail: ${data['sharedWithEmail']}");
        print("custoTotal: ${data['custoTotal']}");
        print("data: ${data['data']}");
        print("supermercado: ${data['supermercado']}");
        print("finalizada: ${data['finalizada']}");
        print("createdAt: ${data['createdAt']}");
        print("updatedAt: ${data['updatedAt']}");
        print("isSynced: ${data['isSynced']}");
        print("uniqueKey: ${data['uniqueKey']}");

        // Verificar se a lista de itens existe e não é null
        if (data['itens'] != null && data['itens'] is List) {
          // Iterar sobre os itens e imprimir seus dados
          print("Itens da lista:");
          data['itens'].forEach((item) {
            // Aqui, assumimos que cada item é um Map que pode ser convertido para Produto
            //print("Produto ID: ${item['id']}");
            print("Produto Descrição: ${item['descricao']}");
            print("Produto Preço Atual: ${item['precoAtual']}");
            print("Produto Quantidade: ${item['quantidade']}");
            // Adicione outras propriedades do produto conforme necessário
          });
        } else {
          print("Nenhum item encontrado para essa lista.");
        }
      });
    } else {
      print("Nenhuma lista compartilhada encontrada.");
    }
  }

/*
  Future<void> printAllItems(List<Map<String, dynamic>> items) async {
  print(
      '********************------------------ PrintAllItems ------------------********************');
  
  for (var item in items) {
    print('ID: ${item['id']}');
    print('User ID: ${item['userId']}');
    print('Total Cost: ${item['custoTotal']}');
    print('Data: ${item['data']}');
    print('Supermarket: ${item['supermercado']}');
    print('Finished: ${item['finalizada']}');
    
    final products = await _database.query(
      'ListaMercadoProduto',
      where: 'listaMercadoId = ?',
      whereArgs: [item['id']],
    );
    
    for (var product in products) {
      final productInfo = await _database.query(
        'Produto',
        where: 'id = ?',
        whereArgs: [product['produtoId']],
      );
      
      print('Produto ID: ${productInfo[0]['id']}');
      print('Descrição: ${productInfo[0]['descricao']}');
      print('Barras: ${productInfo[0]['barras']}');
      print('Quantidade: ${productInfo[0]['quantidade']}');
      print('Pendente: ${productInfo[0]['pendente']}');
      print('Preço Atual: ${productInfo[0]['precoAtual']}');
    }
  }
  
  print(
      '--------------------------------------------------------------------------------------------------');
}
*/
}
