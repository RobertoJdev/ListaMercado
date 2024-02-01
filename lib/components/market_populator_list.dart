import 'dart:math';
import 'package:lista_mercado/models/item_market.dart';

class MarketPopulatorList {
  List<ItemMarket> itens = [];
  //final MarketDatabase _database;

  //MarketDatabasePopulator(this._database);

  List<ItemMarket> populateList() {
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
      ItemMarket itemMarket = ItemMarket(produto, Random().nextInt(10) + 1,
          Random().nextDouble() * 20, [10.0, 15.0, 12.5], false);

      itens.add(itemMarket);
    }

    print('Teste de exibição list completa');
    itens.forEach((element) {
      print(element.name);
    });

    return itens;
  }
}
