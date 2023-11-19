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

  static ListaMercado getListaMercadoExemplo(List<Produto> produto) {
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
}
