import 'package:lista_mercado/models/produto.dart';
import 'package:uuid/uuid.dart';

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
  late String uniqueKey;

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
    String? uniqueKey,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String(),
        uniqueKey = uniqueKey ?? const Uuid().v4().substring(0, 8);

  // Método para converter ListaMercado em Map<String, dynamic>
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': id ?? 0,
        'userId': userId,
        'userEmail': userEmail,
        'isShared': isShared ? 1 : 0,
        'sharedWithEmail': sharedWithEmail,
        'custoTotal': custoTotal,
        'data': data,
        'supermercado': supermercado,
        'finalizada': finalizada ? 1 : 0,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'isSynced': isSynced ? 1 : 0,
        'uniqueKey': uniqueKey,
        'itens': itens.map((produto) => produto.toMap()).toList(),
      };
    } catch (e) {
      throw Exception("Erro ao converter ListaMercado para Map: $e");
    }
  }

  Map<String, dynamic> toMapSql() {
    try {
      return {
        'userId': userId ?? '',
        'userEmail': userEmail ?? '',
        'isShared': (isShared ?? false) ? 1 : 0,
        'sharedWithEmail': sharedWithEmail ?? '',
        'custoTotal': custoTotal ?? 0.0,
        'data': data ?? '',
        'supermercado': supermercado ?? '',
        'finalizada': (finalizada ?? false) ? 1 : 0,
        'isSynced': (isSynced ?? false) ? 1 : 0,
        'uniqueKey': uniqueKey ?? '',
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
        isShared: (map['isShared'] is int)
            ? map['isShared'] == 1
            : (map['isShared'] as bool? ?? false),
        sharedWithEmail: map['sharedWithEmail'] as String?,
        custoTotal: (map['custoTotal'] as num).toDouble(),
        data: map['data'] as String,
        supermercado: map['supermercado'] as String,
        finalizada: (map['finalizada'] is int)
            ? map['finalizada'] == 1
            : (map['finalizada'] as bool? ?? false),
        createdAt: map['createdAt'] as String,
        updatedAt: map['updatedAt'] as String,
        isSynced: (map['isSynced'] is int)
            ? map['isSynced'] == 1
            : (map['isSynced'] as bool? ?? false),
        uniqueKey: map['uniqueKey'] as String,
        itens: map['itens'] != null && map['itens'] is List
            ? (map['itens'] as List)
                .map((item) => Produto.fromMap(item as Map<String, dynamic>))
                .toList()
            : [],
      );
    } catch (e) {
      throw Exception("Erro ao criar ListaMercado a partir de Map: $e");
    }
  }
}
