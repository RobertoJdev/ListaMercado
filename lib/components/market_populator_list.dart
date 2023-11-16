import 'dart:math';
import 'package:lista_mercado/models/produto.dart';

class MarketPopulatorList {
  List<Produto> itens = [];
  bool _isPopulated = false;

  // Singleton instance
  static final MarketPopulatorList _singleton = MarketPopulatorList._internal();

  factory MarketPopulatorList() {
    return _singleton;
  }

  MarketPopulatorList._internal();

  List<Produto> populateList() {
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
