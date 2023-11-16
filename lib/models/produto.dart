import 'package:uuid/uuid.dart';

class Produto {
  String? _id; // Identificador único (UUID) para cada ItemMarket
  late String descricao;
  late String barras;
  late int quantidade;
  late bool pendente;
  late double precoAtual;
  late List<double> historicoPreco;

  Produto({
    required this.descricao,
    required this.barras,
    required this.quantidade,
    required this.pendente,
    required this.precoAtual,
    required this.historicoPreco,
  }) {
    gerarId();
  }
  Produto.newItemList({
    required this.descricao,
    required this.quantidade,
    this.pendente = true,
  }) {
    gerarId();
  }

  get uuid => null;

  String? getId() {
    return _id;
  }

  String? gerarId() {
    var uuid = const Uuid();
    _id = uuid.v4();
    return _id;
  }

  static getProdutoExemplo() {
    Produto produtoExemplo = Produto(
        descricao: 'Arroz',
        barras: 0123456789.toString(),
        quantidade: 10,
        pendente: true,
        precoAtual: 5,
        historicoPreco: [7, 9, 5]);
    return produtoExemplo;
  }
}
