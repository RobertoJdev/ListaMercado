import 'package:lista_mercado/models/produto.dart';

class ListaMercado {
  late int? id;
  late int userId;
  late double custoTotal;
  late String data;
  late String supermercado;
  late bool finalizada;
  late List<Produto> itens;

  ListaMercado({
    this.id,
    required this.userId,
    required this.custoTotal,
    required this.data,
    required this.supermercado,
    required this.finalizada,
    required this.itens,
  });
}
