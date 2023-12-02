import 'dart:math';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

class Populador {
  List<Produto> itens = [];
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
        barras: 0123456789.toString(),
        quantidade: 10,
        pendente: true,
        precoAtual: 5,
        historicoPreco: [7, 9, 5]);
    return produtoExemplo;
  }

  static generateListaProdutosExemplo(int quantidade) {
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
      Produto produtoExemplo = Produto(
          descricao: element,
          barras: 0123456789.toString(),
          quantidade: Random().nextInt(10) + 1,
          pendente: true,
          precoAtual: 5,
          historicoPreco: [7, 9, 5]);
      listExemploProdutos.add(produtoExemplo);
    }

    return listExemploProdutos;
  }

  static generateListaMercadoExemplo(List<Produto> produto) {
    ListaMercado listaMercadoTemp = ListaMercado(
      userId: 1,
      custoTotal: 100.0,
      data: '2023-01-01',
      supermercado: 'Test Supermarket',
      finalizada: false,
      itens: produto,
    );
    return listaMercadoTemp;
  }

  static generateVariasListasMercadoExemplo(List<Produto> produto) {
    List<ListaMercado> variasListaMercadoTemp = [];
    ListaMercado listaMercadoTemp = ListaMercado(
      userId: 1,
      custoTotal: 100.0,
      data: '2023-01-01',
      supermercado: 'Test Supermarket',
      finalizada: false,
      itens: produto,
    );
    return listaMercadoTemp;
  }

  static List<ListaMercado> popularListaMercado() {
    Produto produtoTemp = Populador.generateProdutoExemplo();
    return [
      generateListaMercadoExemplo([produtoTemp, produtoTemp]),
      generateListaMercadoExemplo([produtoTemp, produtoTemp])
    ];
  }

  void _populateDB(List<Produto> produtos) {
    for (var element in produtos) {
      var itemMarketDB;
      var lmercadot;
      itemMarketDB.insertItem(lmercadot, element);
    }
  }
}
