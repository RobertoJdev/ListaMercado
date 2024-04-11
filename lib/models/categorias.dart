import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lista_mercado/models/categoria.dart';

class Categorias {
  static const Categoria carnes = Categoria.carnes;
  static const Categoria hortifruti = Categoria.hortifruti;
  static const Categoria padaria = Categoria.padaria;
  static const Categoria laticinios = Categoria.laticinios;
  static const Categoria frios = Categoria.frios;
  static const Categoria limpeza = Categoria.limpeza;
  static const Categoria higienePessoal = Categoria.higienePessoal;
  static const Categoria bebidas = Categoria.bebidas;
  static const Categoria mercearia = Categoria.mercearia;

  static Categoria obterCategoriaAleatoria() {
    final List<Categoria> todasCategorias = [
      carnes,
      hortifruti,
      padaria,
      laticinios,
      frios,
      limpeza,
      higienePessoal,
      bebidas,
      mercearia,
    ];

    final Random random = Random();
    final int indiceAleatorio = random.nextInt(todasCategorias.length);

    return todasCategorias[indiceAleatorio];
  }

  static Color obterCorPorDescricao(String descricao) {
    final Map<String, Categoria> mapaCategorias = {
      'Carnes': carnes,
      'Hortifruti': hortifruti,
      'Padaria': padaria,
      'Laticínios': laticinios,
      'Frios': frios,
      'Limpeza': limpeza,
      'Higiene Pessoal': higienePessoal,
      'Bebidas': bebidas,
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
      'Limpeza': limpeza,
      'Higiene Pessoal': higienePessoal,
      'Bebidas': bebidas,
      'Mercearia': mercearia,
    };

    return mapaCategorias[descricao]?.corSecundaria ?? Colors.grey[200]!;
  }

  static List<Categoria> obterTodasCategorias() {
    return [
      carnes,
      hortifruti,
      padaria,
      laticinios,
      frios,
      limpeza,
      higienePessoal,
      bebidas,
      mercearia,
    ];
  }

  static String abreviarCategoria(String nomeCategoria) {
    return nomeCategoria.substring(0, 5).toUpperCase();
  }

  static String defineCategoriaAuto(String nomeProduto) {
    //print(nomeProduto);
    //print('********************************************************');
    nomeProduto = nomeProduto.trim();
    //print(nomeProduto);
    switch (nomeProduto.toLowerCase()) {
      case 'carne':
      case 'frango':
      case 'carne moída':
      case 'peixe':
      case 'linguiça':
      case 'costela':
      case 'porco':
      case 'coração de frango':
      case 'picanha':
      case 'filé de peixe':
      case 'fraldinha':
      case 'cupim':
      case 'contra filé':
      case 'maminha':
      case 'alcatra':
      case 'paleta':
      case 'pernil':
      case 'coxão mole':
      case 'coxão duro':
      case 'patinho':
        return Categoria.carnes.nomeFormatado;
      case 'alface':
      case 'tomate':
      case 'cenoura':
      case 'banana':
      case 'maçã':
      case 'laranja':
      case 'abacaxi':
      case 'uva':
      case 'abóbora':
      case 'melancia':
      case 'morango':
      case 'couve':
      case 'beterraba':
      case 'cebola':
      case 'batata':
      case 'chuchu':
      case 'quiabo':
      case 'pimentão':
      case 'abobrinha':
      case 'berinjela':
        return Categoria.hortifruti.nomeFormatado;
      case 'pão':
      case 'baguete':
      case 'croissant':
      case 'pão de forma':
      case 'pão de queijo':
      case 'bisnaguinha':
      case 'pão integral':
      case 'rosca':
      case 'pão sírio':
      case 'pão de centeio':
      case 'broa':
      case 'focaccia':
      case 'ciabatta':
      case 'torta':
      case 'bolo':
      case 'brownie':
      case 'bolacha':
      case 'sonho':
      case 'pão doce':
        return Categoria.padaria.nomeFormatado;
      case 'leite':
      case 'queijo':
      case 'manteiga':
      case 'iogurte':
      case 'creme de leite':
      case 'coalhada':
      case 'leite condensado':
      case 'leite em pó':
      case 'creme de leite fresco':
      case 'requeijão':
      case 'queijo minas':
      case 'queijo coalho':
      case 'queijo prato':
      case 'queijo ricota':
      case 'queijo gorgonzola':
      case 'queijo parmesão':
      case 'queijo cottage':
      case 'queijo roquefort':
      case 'queijo brie':
      case 'queijo camembert':
        return Categoria.laticinios.nomeFormatado;
      case 'presunto':
      //case 'queijo prato':
      case 'mortadela':
      case 'salame':
      case 'patê':
      case 'peito de peru':
      case 'blanquet de peru':
      case 'salaminho':
      case 'linguiça calabresa':
      case 'presunto parma':
      case 'salchicha':
      case 'salsicha':
      case 'linguiça toscana':
      case 'linguiça portuguesa':
      case 'peperroni':
      case 'paio':
      case 'salame italiano':
      case 'salaminho italiano':
      case 'mortadela defumada':
        return Categoria.frios.nomeFormatado;
      case 'detergente':
      case 'sabão em pó':
      case 'amaciante':
      case 'limpa vidros':
      case 'água sanitária':
      case 'desinfetante':
      case 'esponja':
      case 'lustra móveis':
      case 'álcool':
      case 'pano de chão':
      case 'desengordurante':
      case 'limpador multiuso':
      case 'limpador perfumado':
      case 'tira manchas':
      case 'sabão de coco':
      case 'água desmineralizada':
      case 'limpador de banheiro':
      case 'limpador de cozinha':
      case 'limpador de vidros':
        return Categoria.limpeza.nomeFormatado;
      case 'shampoo':
      case 'sabonete':
      case 'pasta de dente':
      case 'desodorante':
      case 'cotonete':
      case 'condicionador':
      case 'creme hidratante':
      case 'gel de banho':
      case 'fio dental':
      case 'perfume':
      case 'hidratante facial':
      case 'loção corporal':
      case 'protetor solar':
      case 'desodorante roll-on':
      case 'desodorante aerossol':
      case 'desodorante sem perfume':
      case 'xampu':
      case 'xampu anticaspa':
      case 'xampu infantil':
        return Categoria.higienePessoal.nomeFormatado;
      case 'água':
      case 'refrigerante':
      case 'suco':
      case 'energético':
      case 'chá':
      case 'cerveja':
      case 'vinho':
      case 'vodca':
      case 'rum':
      case 'whisky':
      case 'gin':
      case 'tequila':
      case 'licor':
      case 'espumante':
      case 'sidra':
      case 'vermute':
      case 'conhaque':
      case 'brandy':
      case 'saquê':
      case 'aguardente':
        return Categoria.bebidas.nomeFormatado;
      case 'açúcar':
      case 'arroz':
      case 'azeite':
      case 'biscoito':
      case 'biscoito amanteigado':
      case 'biscoito de doce':
      case 'biscoito de maizena':
      case 'biscoito de sal':
      case 'biscoito doce':
      case 'biscoito salgado':
      case 'café':
      case 'caldo de carne':
      case 'caldo de galinha':
      case 'cereal':
      case 'chocolate':
      case 'cookie':
      case 'cookie de aveia':
      case 'cookie de chocolate':
      case 'cookie integral':
      case 'farinha':
      case 'feijão':
      case 'feijão azuki':
      case 'feijão branco':
      case 'feijão carioca':
      case 'feijão fradinho':
      case 'feijão jalo':
      case 'feijão preto':
      case 'feijão roxo':
      case 'feijão verde':
      case 'feijão bolinha':
      case 'feijão rajado':
      case 'feijão moyashi':
      case 'feijão mulatinho':
      case 'gelatina':
      case 'macarrão':
      case 'maionese':
      case 'margarina':
      case 'molho de tomate':
      case 'óleo':
      case 'pipoca':
      case 'sequilhos':
      case 'vinagre':
        return Categoria.mercearia.nomeFormatado;
      default:
        return obterCategoriaAleatoria().nomeFormatado;
    }
  }
}
