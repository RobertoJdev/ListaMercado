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

  static generateListaMercadoExemplo(List<Produto> produtos) {
    ListaMercado listaMercadoTemp = ListaMercado(
      userId: 1,
      custoTotal: 100.0,
      data: '01-01-23',
      supermercado: 'Supermarket Exemplo',
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
        data: '01-01-23',
        supermercado: 'Supermarket Exemplo',
        finalizada: false,
        itens: produtos,
      ));
    }
    return multiListaMercadoTemp;
  }
}
