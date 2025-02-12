import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lista_mercado/models/categorias.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/util/teste_print_mixin.dart';
import 'package:lista_mercado/util/generate_item_list_mixin.dart';

void main() {
  test('Teste de geração de lista de mercado', () async {
    // Chama o método para gerar uma lista de mercado de exemplo
    ListaMercado listaMercado = await GenerateItemListMixin.generateListaMercadoExemplo();

    // Verifica se a lista de produtos não está vazia
    expect(listaMercado.itens.isNotEmpty, true);

    // Verifica se o valor total da lista foi calculado corretamente
    double valorTotalCalculado = 0.0;
    for (var produto in listaMercado.itens) {
      valorTotalCalculado += produto.precoAtual;
    }

    expect(listaMercado.custoTotal, valorTotalCalculado);

    // Verifica se o e-mail do usuário foi carregado corretamente
    expect(listaMercado.userEmail, 'email.exemplo@email.com');

    // Verifica se o supermercado está correto
    expect(listaMercado.supermercado, 'Supermarket Exemplo');

    // Verifica se o ID do usuário está presente e é o esperado
    expect(listaMercado.userId, '99List99');
  });

  test('Teste de produto gerado', () {
    // Chama o método para gerar um produto de exemplo
    Produto produto = GenerateItemListMixin.generateProdutoExemplo();

    // Verifica se o produto gerado possui uma descrição
    expect(produto.descricao.isNotEmpty, true);

    // Verifica se o preço do produto está dentro de um intervalo válido
    expect(produto.precoAtual >= 0.0 && produto.precoAtual <= 50.0, true);

    // Verifica se o código de barras do produto está correto
    expect(produto.barras.length, 10); // Espera-se um código de barras com 10 dígitos
  });
}
