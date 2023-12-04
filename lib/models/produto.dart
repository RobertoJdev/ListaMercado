import 'package:uuid/uuid.dart';

class Produto {
  String? _id;
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
  })  : precoAtual = 0,
        historicoPreco = [] {
    gerarId();
  }

  String? getId() => _id;

  void gerarId() {
    _id = const Uuid().v4();
  }

  static Produto getProdutoExemplo() => Produto(
        descricao: 'Arroz',
        barras: '0123456789',
        quantidade: 10,
        pendente: true,
        precoAtual: 5,
        historicoPreco: [7, 9, 5],
      );
}
