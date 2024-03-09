import 'dart:io';
import 'dart:convert';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:path_provider/path_provider.dart';

class JsonConverter {
  // Método para converter o objeto ListaMercado em um mapa JSON
  static Map<String, dynamic> listaMercadoToJson(ListaMercado listaMercado) {
    print(
        '-------------------------entrada em conversao jon---------------------------');

    List<Map<String, dynamic>> produtos = [];
    for (var produto in listaMercado.itens) {
      produtos.add({
        'descricao': produto.descricao,
        'barras': produto.barras,
        'quantidade': produto.quantidade,
        'pendente': produto.pendente,
        'precoAtual': produto.precoAtual,
        'categoria': produto.categoria,
        'historicoPreco': produto.historicoPreco,
      });
    }

    return {
      'id': listaMercado.id,
      'userId': listaMercado.userId,
      'custoTotal': listaMercado.custoTotal,
      'data': listaMercado.data,
      'supermercado': listaMercado.supermercado,
      'finalizada': listaMercado.finalizada,
      'itens': produtos,
    };
  }

  // Método estático para criar uma instância de ListaMercado a partir de um mapa JSON
  static ListaMercado listaMercadoFromJson(Map<String, dynamic> json) {
    List<dynamic> jsonItens = json['itens'];
    List<Produto> produtos = jsonItens
        .map((item) => Produto(
              descricao: item['descricao'],
              barras: item['barras'],
              quantidade: item['quantidade'],
              pendente: item['pendente'],
              precoAtual: item['precoAtual'],
              categoria: item['categoria'],
              historicoPreco: List<double>.from(item['historicoPreco']),
            ))
        .toList();

    return ListaMercado(
      id: json['id'],
      userId: json['userId'],
      custoTotal: json['custoTotal'],
      data: json['data'],
      supermercado: json['supermercado'],
      finalizada: json['finalizada'],
      itens: produtos,
    );
  }
}
