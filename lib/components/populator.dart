import 'dart:math';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

class Populador {
  //List<Produto> produtos = [];
  bool _isPopulated = false;

  // Singleton instance
  static final Populador _singleton = Populador._internal();

  factory Populador() {
    return _singleton;
  }

  Populador._internal();

  static generateProdutoExemplo() {
    Produto produtoExemplo = Produto(
      descricao: 'Arroz',
      barras: '0123456789', // Adicione aspas para tratar como string
      quantidade: 10,
      pendente: true,
      precoAtual: 5,
      historicoPreco: [7, 9, 5],
    );
    return produtoExemplo;
  }

  static generateMultiProdutosExemplo() {
    List<Produto> listExemploProdutos = [];
    final nomesProdutos = [
      'Feijão Mulatinho',
      'Arroz',
      'Macarrão',
      'Óleo',
      'Biscoito',
      'Biscoito de Sal',
      'Banana',
      'Maçã',
    ];

    for (var element in nomesProdutos) {
      Produto produtoTemp = Produto(
          descricao: element,
          barras: '0123456789',
          quantidade: Random().nextInt(10) + 1,
          pendente: true,
          precoAtual: 5,
          historicoPreco: [7, 9, 5]);
      listExemploProdutos.add(produtoTemp);
    }

    return listExemploProdutos;
  }

  static generateListaMercadoExemplo(List<Produto> produtos) {
    ListaMercado listaMercadoTemp = ListaMercado(
      userId: 1,
      custoTotal: 100.0,
      data: '2023-01-01',
      supermercado: 'Supermarket',
      finalizada: false,
      itens: produtos,
    );
    return listaMercadoTemp;
  }

  static generateMultiListasMercadoExemplo(List<Produto> produtos) {
    List<ListaMercado> multiListaMercadoTemp = [];

    for (var i = 0; i < 5; i++) {
      multiListaMercadoTemp.add(ListaMercado(
        userId: 1,
        custoTotal: 100.0,
        data: '2023-01-01',
        supermercado: 'Supermarket',
        finalizada: false,
        itens: produtos,
      ));
    }
    return multiListaMercadoTemp;
  }

  static void populateDB(ListaMercado listaMercado) {
    MarketDB itemMarketDB = MarketDB();
    itemMarketDB.novaListaMercado(listaMercado);
  }
}
