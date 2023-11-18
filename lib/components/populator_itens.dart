import 'dart:math';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

class PopuladorItens {
  List<Produto> itens = [];
  bool _isPopulated = false;

  // Singleton instance
  static final PopuladorItens _singleton = PopuladorItens._internal();

  factory PopuladorItens() {
    return _singleton;
  }

  PopuladorItens._internal();

  static List<ListaMercado> popularListaMercado() {
    Produto produtoTemp = Produto.getProdutoExemplo();
    return [
      ListaMercado.getListaMercadoExemplo([produtoTemp, produtoTemp]),
      ListaMercado.getListaMercadoExemplo([produtoTemp, produtoTemp])
    ];
  }

  List<Produto> popularListaProdutos() {
    if (!_isPopulated) {
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

      for (var produto in nomesProdutos) {
        Produto itemProduto = Produto.newItemList(
          descricao: produto,
          quantidade: Random().nextInt(10) + 1,
        );

        itens.add(itemProduto);
      }

      print('Print: Teste de exibição lista completa');
      itens.forEach((element) {
        print('Print ' + element.descricao);
      });

      _isPopulated = true;
    } else {
      print('Print: A lista já foi populada. Usando dados existentes.');
    }

    return itens;
  }
}
