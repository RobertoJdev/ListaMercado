import 'dart:math';
import 'package:lista_mercado/models/item_market.dart';

class MarketPopulatorList {
  List<ItemMarket> itens = [];
  bool _isPopulated = false;

  // Singleton instance
  static final MarketPopulatorList _singleton = MarketPopulatorList._internal();

  factory MarketPopulatorList() {
    return _singleton;
  }

  MarketPopulatorList._internal();

  List<ItemMarket> populateList() {
    if (!_isPopulated) {
      final produtos = [
        'Feijão',
        'Arroz',
        'Macarrão',
        'Óleo',
        'Biscoito',
        'Biscoito de Sal',
        'Banana',
        'Maçã',
      ];

      for (var produto in produtos) {
        ItemMarket itemMarket = ItemMarket(
          produto,
          Random().nextInt(10) + 1,
          Random().nextDouble() * 20,
          [10.0, 15.0, 12.5],
          false,
        );

        itens.add(itemMarket);
      }

      print('Teste de exibição lista completa');
      itens.forEach((element) {
        print(element.name);
      });

      _isPopulated = true;
    } else {
      print('A lista já foi populada. Usando dados existentes.');
    }

    return itens;
  }
}
