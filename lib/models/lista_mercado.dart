import 'package:lista_mercado/models/produto.dart';

class ListaMercado {
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
  late String createdAt;
  late String updatedAt;
  bool isSynced;

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
    String? createdAt,
    String? updatedAt,
    this.isSynced = false,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  // Método para converter ListaMercado em Map<String, dynamic>
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': id,
        'userId': userId,
        'userEmail': userEmail,
        'isShared': isShared,
        'sharedWithEmail': sharedWithEmail,
        'custoTotal': custoTotal,
        'data': data,
        'supermercado': supermercado,
        'finalizada': finalizada,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'isSynced': isSynced,
        'itens': itens.map((produto) => produto.toMap()).toList(),
      };
    } catch (e) {
      throw Exception("Erro ao converter ListaMercado para Map: $e");
    }
  }

  // Método para criar ListaMercado a partir de Map<String, dynamic>
  factory ListaMercado.fromMap(Map<String, dynamic> map) {
    try {
      return ListaMercado(
        id: map['id'] as int?,
        userId: map['userId'] as String,
        userEmail: map['userEmail'] as String,
        isShared: map['isShared'] as bool? ?? false,
        sharedWithEmail: map['sharedWithEmail'] as String?,
        custoTotal: (map['custoTotal'] as num).toDouble(),
        data: map['data'] as String,
        supermercado: map['supermercado'] as String,
        finalizada: map['finalizada'] as bool? ?? false,
        // Verifica se o campo 'itens' existe e não é null
        itens: map['itens'] != null && map['itens'] is List
            ? (map['itens'] as List)
                .map((item) => Produto.fromMap(item as Map<String, dynamic>))
                .toList()
            : [], // Se 'itens' for null ou não for uma lista, retorna uma lista vazia
        createdAt: map['createdAt'] as String,
        updatedAt: map['updatedAt'] as String,
        isSynced: map['isSynced'] as bool? ?? false,
      );
    } catch (e) {
      throw Exception("Erro ao criar ListaMercado a partir de Map: $e");
    }
  }
}
