import 'dart:math';
import 'package:flutter/material.dart';

class Categoria {
  final String nome;
  final Color cor;

  Categoria({required this.nome, required this.cor});
}

class Categorias {
  static final Categoria frutas =
      Categoria(nome: 'Frutas e Vegetais', cor: Colors.green[50]!);
  static final Categoria padaria =
      Categoria(nome: 'Padaria', cor: Colors.brown[50]!);
  static final Categoria laticinios =
      Categoria(nome: 'Laticínios', cor: Colors.blue[50]!);
  static final Categoria carnes =
      Categoria(nome: 'Carnes', cor: Colors.red[50]!);
  static final Categoria congelados =
      Categoria(nome: 'Congelados', cor: Colors.cyan[50]!);
  static final Categoria produtosLimpeza =
      Categoria(nome: 'Produtos de Limpeza', cor: Colors.orange[50]!);
  static final Categoria higienePessoal =
      Categoria(nome: 'Higiene Pessoal', cor: Colors.purple[50]!);
  static final Categoria bebidas =
      Categoria(nome: 'Bebidas', cor: Colors.teal[50]!);
  static final Categoria cereais =
      Categoria(nome: 'Cereais e Grãos', cor: Colors.amber[50]!);
  static final Categoria molhos =
      Categoria(nome: 'Molhos e Condimentos', cor: Colors.pink[50]!);
  static final Categoria snacks =
      Categoria(nome: 'Snacks e Aperitivos', cor: Colors.yellow[50]!);
  static final Categoria produtosBebe =
      Categoria(nome: 'Produtos de Bebê', cor: Colors.lightBlue[50]!);
  static final Categoria limpezaDomestica =
      Categoria(nome: 'Limpeza Doméstica', cor: Colors.indigo[50]!);

  static obterCategoriaAleatoria() {
    final List<Categoria> todasCategorias = [
      frutas,
      padaria,
      laticinios,
      carnes,
      congelados,
      produtosLimpeza,
      higienePessoal,
      bebidas,
      cereais,
      molhos,
      snacks,
      produtosBebe,
      limpezaDomestica,
    ];

    final Random random = Random();
    final int indiceAleatorio = random.nextInt(todasCategorias.length);

    return todasCategorias[indiceAleatorio].nome.toString();
  }

  static Color obterCorPorDescricao(String descricao) {
    final Map<String, Categoria> mapaCategorias = {
      'Frutas e Vegetais': frutas,
      'Padaria': padaria,
      'Laticínios': laticinios,
      'Carnes': carnes,
      'Congelados': congelados,
      'Produtos de Limpeza': produtosLimpeza,
      'Higiene Pessoal': higienePessoal,
      'Bebidas': bebidas,
      'Cereais e Grãos': cereais,
      'Molhos e Condimentos': molhos,
      'Snacks e Aperitivos': snacks,
      'Produtos de Bebê': produtosBebe,
      'Limpeza Doméstica': limpezaDomestica,
    };

    return mapaCategorias[descricao]?.cor ?? Colors.grey[50]!;
  }


static obterTodasCategorias() {
    final List<Categoria> todasCategorias = [
      frutas,
      padaria,
      laticinios,
      carnes,
      congelados,
      produtosLimpeza,
      higienePessoal,
      bebidas,
      cereais,
      molhos,
      snacks,
      produtosBebe,
      limpezaDomestica,
    ];

    return todasCategorias;
  }

}
