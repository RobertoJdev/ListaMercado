import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/util/generate_item_list_mixin.dart';

class ListaMercado with GenerateItemListMixin {
  late int? id;
  late String userId;
  late String userEmail;
  bool isShared;
  String? sharedWithEmail;
  late double custoTotal;
  late String data;
  late String supermercado;
  late bool finalizada;
  late List<Produto> itens;

  ListaMercado({
    this.id,
    required this.userId,
    required this.userEmail,
    this.isShared = false,
    this.sharedWithEmail,
    required this.custoTotal,
    required this.data,
    required this.supermercado,
    required this.finalizada,
    required this.itens,
  });
}
