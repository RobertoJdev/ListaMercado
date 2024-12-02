import 'dart:math';
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
    required this.categoria,
  }) : historicoPreco = [] {
    gerarId();
  }

  String? getId() => _id;

  void gerarId() {
    _id = const Uuid().v4();
  }

  /// Converte Produto para Map<String, dynamic> (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'descricao': descricao,
      'barras': barras,
      'quantidade': quantidade,
      'pendente': pendente,
      'precoAtual': precoAtual,
      'categoria': categoria,
      'historicoPreco': historicoPreco, // Lista de preços será armazenada
    };
  }

  /// Cria um Produto a partir de Map<String, dynamic> (para Firestore)
  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      descricao: map['descricao'] as String,
      barras: map['barras'] as String,
      quantidade: (map['quantidade'] as num).toDouble(),
      pendente: map['pendente'] as bool,
      precoAtual: (map['precoAtual'] as num).toDouble(),
      categoria: map['categoria'] as String,
      historicoPreco: (map['historicoPreco'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(), // Converte a lista de preços
    ).._id = map['id'] as String?; // Restaura o ID
  }

  static List<Produto> ordenarItens(List<Produto> listaProdutos) {
    return listaProdutos
      ..sort((a, b) {
        final categoriaComparison =
            a.categoria.toLowerCase().compareTo(b.categoria.toLowerCase());
        if (categoriaComparison != 0) {
          return categoriaComparison;
        }
        return a.descricao.toLowerCase().compareTo(b.descricao.toLowerCase());
      });
  }
}
