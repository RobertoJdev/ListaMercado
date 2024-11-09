import 'dart:ffi';
import 'dart:math';

import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/models/categorias.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

mixin GenerateItemListMixin {
  static generateListaMercadoExemplo([List<Produto>? produtos]) {
    produtos ??= generateMultiProdutosExemplo();

    if (produtos!.isEmpty) {
      produtos = generateMultiProdutosExemplo();
    }

    double valorTotal = 0.0;

    if (produtos != null && produtos.isNotEmpty) {
      for (var produto in produtos) {
        valorTotal += produto.precoAtual;
      }
    }

    ListaMercado listaMercadoTemp = ListaMercado(
      userId: '99List99',
      userEmail: 'email.teste@email.com',
      isShared: false,
      sharedWithEmail: '',
      custoTotal: valorTotal,
      data: '01-01-24',
      supermercado: 'Supermarket Exemplo',
      finalizada: false,
      itens: produtos!,
    );
    return listaMercadoTemp;
  }

  static generateMultiProdutosExemplo() {
    precoAleatorioDuasCasaDecimais() {
      double precoDuasCasaDecimais =
          double.parse((Random().nextDouble() * 50).toStringAsFixed(2));
      return precoDuasCasaDecimais;
    }

    List<Produto> listExemploProdutos = [];

    final nomesProdutos = [
      'Carne',
      'Frango',
      'Alface',
      //'Tomate',
      'Pão de forma',
      //'Pão de queijo',
      //'Queijo coalho',
      //'Queijo prato',
      //'Mortadela',
      //'Salame',
      //'Desinfetante',
      //'Esponja',
      //'Shampoo',
      //'Sabonete',
      //'Rum',
      'Whisky',
      //'Açúcar',
      //'Arroz',
    ];

    for (var element in nomesProdutos) {
      Produto produtoTemp = Produto(
        descricao: element,
        barras: '0123456789',
        quantidade: Random().nextInt(10) + 1,
        pendente: true,
        precoAtual: precoAleatorioDuasCasaDecimais(),
        categoria: Categorias.defineCategoriaAuto(element),
        historicoPreco: [
          precoAleatorioDuasCasaDecimais(),
          precoAleatorioDuasCasaDecimais(),
          precoAleatorioDuasCasaDecimais(),
        ],
      );
      listExemploProdutos.add(produtoTemp);
    }

    return listExemploProdutos;
  }

  static generateProdutoExemplo() {
    List Produtos = generateMultiProdutosExemplo();
    return Produtos[Random().nextInt(Produtos.length)];
  }
}
