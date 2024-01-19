import 'dart:math';
import 'package:lista_mercado/models/categoria.dart';
import 'package:uuid/uuid.dart';

class Produto {
  String? _id;
  late String descricao;
  late String barras;
  late double quantidade;
  late bool pendente;
  late double precoAtual;
  late String categoria;
  late List<double> historicoPreco;

  Produto({
    required this.descricao,
    required this.barras,
    required this.quantidade,
    required this.pendente,
    required this.precoAtual,
    required this.categoria,
    required this.historicoPreco,
  }) {
    gerarId();
  }

  Produto.newItemList({
    required this.descricao,
    required this.quantidade,
    this.pendente = true,
    this.precoAtual = 0,
  }) : historicoPreco = [] {
    gerarId();
  }

  String? getId() => _id;

  void gerarId() {
    _id = const Uuid().v4();
  }

  static generateProdutoExemplo() {
    Produto produtoExemplo = Produto(
      descricao: 'Arroz',
      barras: '0123456789',
      quantidade: 10,
      pendente: true,
      precoAtual: 5,
      categoria: Categorias.obterCategoriaAleatoria().nome,
      historicoPreco: [7, 9, 5],
    );
    return produtoExemplo;
  }

  static generateMultiProdutosExemplo() {
    List<Produto> listExemploProdutos = [];
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

    for (var element in nomesProdutos) {
      Produto produtoTemp = Produto(
        descricao: element,
        barras: '0123456789',
        quantidade: Random().nextInt(10) + 1,
        pendente: true,
        precoAtual: 5,
        categoria: Categorias.obterCategoriaAleatoria().nome,
        historicoPreco: [7, 9, 5],
      );
      listExemploProdutos.add(produtoTemp);
    }

    return listExemploProdutos;
  }
}
