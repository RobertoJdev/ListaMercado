import 'dart:math';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

class Populador {
  //List<Produto> produtos = [];
  final bool _isPopulated = false;

  // Singleton instance
  static final Populador _singleton = Populador._internal();

  factory Populador() {
    return _singleton;
  }

  Populador._internal();

}
