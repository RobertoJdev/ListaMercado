import 'dart:math';
import 'package:flutter/material.dart';

class Categoria {
  final String nome;
  final Color cor;
  final Color corSecundaria;

  Categoria(
      {required this.nome, required this.cor, required this.corSecundaria});

  static String abreviarCategoria(String nomeCategoria) {
    return nomeCategoria.substring(0, 5).toUpperCase();
  }
}

class Categorias {
  static final Categoria carnes = Categoria(
      nome: 'Carnes', cor: Colors.pink[50]!, corSecundaria: Colors.pink[200]!);

  static final Categoria hortifruti = Categoria(
      nome: 'Hortifruti',
      cor: Colors.green[50]!,
      corSecundaria: Colors.green[200]!);
  static final Categoria padaria = Categoria(
      nome: 'Padaria',
      cor: Colors.brown[50]!,
      corSecundaria: Colors.brown[200]!);
  static final Categoria laticinios = Categoria(
      nome: 'Laticínios',
      cor: Colors.blue[50]!,
      corSecundaria: Colors.blue[200]!);
  static final Categoria frios = Categoria(
      nome: 'Frios', cor: Colors.red[50]!, corSecundaria: Colors.red[200]!);

  static final Categoria limpeza = Categoria(
      nome: 'Limpeza',
      cor: Colors.orange[50]!,
      corSecundaria: Colors.orange[200]!);

  static final Categoria higienePessoal = Categoria(
      nome: 'Higiene Pessoal',
      cor: Colors.purple[50]!,
      corSecundaria: Colors.purple[200]!);

  static final Categoria bebidas = Categoria(
      nome: 'Bebidas', cor: Colors.teal[50]!, corSecundaria: Colors.teal[200]!);

  static final Categoria mercearia = Categoria(
      nome: 'Mercearia',
      cor: Colors.yellow[50]!,
      corSecundaria: Colors.yellow[200]!);

  static obterCategoriaAleatoria() {
    final List<Categoria> todasCategorias = [
      carnes,
      hortifruti,
      padaria,
      laticinios,
      frios,
      limpeza,
      higienePessoal,
      bebidas,
      //cereais,
      //molhos,
      //snacks,
      //produtosBebe,
      //limpezaDomestica,
      mercearia,
    ];

    final Random random = Random();
    final int indiceAleatorio = random.nextInt(todasCategorias.length);

    return todasCategorias[indiceAleatorio].nome.toString();
  }

  static Color obterCorPorDescricao(String descricao) {
    final Map<String, Categoria> mapaCategorias = {
      'Carnes': carnes,
      'Hortifruti': hortifruti,
      'Padaria': padaria,
      'Laticínios': laticinios,
      'Frios': frios,
      //'Congelados': congelados,
      'Limpeza': limpeza,
      'Higiene Pessoal': higienePessoal,
      'Bebidas': bebidas,
      //'Cereais e Grãos': cereais,
      //'Molhos e Condimentos': molhos,
      //'Snacks e Aperitivos': snacks,
      //'Produtos de Bebê': produtosBebe,
      //'Limpeza Doméstica': limpezaDomestica,
      'Mercearia': mercearia,
    };

    return mapaCategorias[descricao]?.cor ?? Colors.grey[50]!;
  }

  static Color obterCorSecundariaPorDescricao(String descricao) {
    final Map<String, Categoria> mapaCategorias = {
      'Carnes': carnes,
      'Hortifruti': hortifruti,
      'Padaria': padaria,
      'Laticínios': laticinios,
      'Frios': frios,
      //'Congelados': congelados,
      'Limpeza': limpeza,
      'Higiene Pessoal': higienePessoal,
      'Bebidas': bebidas,
      //'Cereais e Grãos': cereais,
      //'Molhos e Condimentos': molhos,
      //'Snacks e Aperitivos': snacks,
      //'Produtos de Bebê': produtosBebe,
      //'Limpeza Doméstica': limpezaDomestica,
      'Mercearia': mercearia,
    };

    return mapaCategorias[descricao]?.corSecundaria ?? Colors.grey[200]!;
  }

  static obterTodasCategorias() {
    final List<Categoria> todasCategorias = [
      carnes,
      hortifruti,
      padaria,
      laticinios,
      frios,
      //congelados,
      limpeza,
      higienePessoal,
      bebidas,
      //cereais,
      //molhos,
      //snacks,
      //produtosBebe,
      //limpezaDomestica,
      mercearia,
    ];

    return todasCategorias;
  }
}
