import 'dart:math';

import 'package:lista_mercado/models/categorias.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/util/teste_print_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin GenerateItemListMixin {
  static generateListaMercadoExemplo([List<Produto>? produtos]) {
    produtos ??= generateMultiProdutosExemplo();

    String? emailUser;

    Future<void> loadEmail() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      emailUser = prefs.getString('user_email');
    }

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
      userEmail: emailUser ?? 'email.exemplo@email.com',
      isShared: false,
      sharedWithEmail: '',
      custoTotal: valorTotal,
      data: DataUtil.getCurrentFormattedDate(),
      supermercado: 'Supermarket Exemplo',
      finalizada: true,
      isSynced: false,
      itens: produtos!,
    );
    TestePrintMixin.testeGenerico(
        " ============ Gerador Lista Inicial ============ ", "");
    //print('teste de valores dentro do gerador de lista na inicialição');
    //TestePrintMixin.printListaMercadoInfo(listaMercadoTemp);
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
