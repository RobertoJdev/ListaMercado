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
  static const Categoria indefinido = Categoria.indefinido;

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

    List<String> carnes = [
      'alcatra',
      'bacon',
      'bisteca',
      'carne',
      'carne seca',
      'carne moida',
      'carne moída',
      'carne de sol',
      'cavala',
      'coxao mole',
      'coxão mole',
      'coxao duro',
      'coxão duro',
      'cupim',
      'costela',
      'costela de boi',
      'frango',
      'fraldinha',
      'hamburguer',
      'hambúrguer',
      'linguica',
      'linguiça',
      'lingua',
      'língua',
      'maminha',
      'mortadela',
      'paleta',
      'picanha',
      'presunto',
      'rabada',
      'salame',
      'salsicha',
      'tartaruga',
      'tripas',
      'vitela',
      'peixe',
      'file de peixe',
      'filé de peixe',
      'pintado',
      'truta',
      'solha',
      'tainha',
      'tambaqui',
      'polvo',
      'escabeche',
      'mocoto',
      'mocotó',
      'ossobuco',
      'javali',
      'morcela',
      'miudos',
      'miúdos',
      'bochecha de boi',
      'buchada',
      'cabrito',
      'capitao'
    ];

    List<String> hortifruti = [
      'alface',
      'abacaxi',
      'abóbora',
      'abobora',
      'abobrinha',
      'acerola',
      'banana',
      'batata',
      'batata-baroa',
      'batata-doce',
      'batata inglesa',
      'berinjela',
      'beterraba',
      'bolo',
      'bolo de chocolate',
      'bolo de cenoura',
      'bolo de fubá',
      'bolo de laranja',
      'bolo de milho',
      'bolo de rolo',
      'brownie',
      'brócolis',
      'brocolis',
      'brioche',
      'babka',
      'bagel',
      'baguete',
      'baguete integral',
      'biscoito',
      'biscoito amanteigado',
      'biscoito de doce',
      'biscoito de maizena',
      'biscoito de sal',
      'biscoito doce',
      'biscoito salgado',
      'bochecha de boi',
      'biscoito doce',
      'biscoito salgado',
      'bolo',
      'bolo de chocolate',
      'bolo de cenoura',
      'bolo de fubá',
      'bolo de milho',
      'bolo de rolo',
      'brownie',
      'brócolis',
      'brocolis',
      'brioche',
      'babka',
      'bagel',
      'baguete',
      'baguete integral',
      'biscoito',
      'biscoito amanteigado',
      'biscoito de doce',
      'biscoito de maizena',
      'biscoito de sal',
      'biscoito doce',
      'biscoito salgado',
      'bolo',
      'bolo de chocolate',
      'bolo de cenoura',
      'bolo de fubá',
      'bolo de milho',
      'bolo de rolo',
      'brownie',
      'brócolis',
      'brocolis',
      'brioche',
      'babka',
      'bagel',
      'baguete',
      'baguete integral',
      'biscoito',
      'biscoito amanteigado',
      'biscoito de doce',
      'biscoito de maizena',
      'biscoito de sal',
      'biscoito doce',
      'biscoito salgado',
      'bolo',
      'bolo de chocolate',
      'bolo de cenoura',
      'bolo de fubá',
      'bolo de milho',
      'bolo de rolo',
      'brownie',
      'brócolis',
      'brocolis',
      'brioche',
      'babka',
      'bagel',
      'baguete',
      'baguete integral',
      'biscoito',
      'biscoito amanteigado',
      'biscoito de doce'
    ];

    List<String> padaria = [
      'pao',
      'pão',
      'baguete',
      'croissant',
      'pao de forma',
      'pão de forma',
      'pao de queijo',
      'pão de queijo',
      'bisnaguinha',
      'pao integral',
      'pão integral',
      'rosca',
      'pao sirio',
      'pão sírio',
      'pao de centeio',
      'pão de centeio',
      'broa',
      'focaccia',
      'ciabatta',
      'torta',
      'bolo',
      'brownie',
      'bolacha',
      'sonho',
      'pao doce',
      'pão doce',
      'muffin',
      'cupcake',
      'torrada',
      'bagel',
      'donut',
      'churro',
      'mil folhas',
      'croissant de chocolate',
      'croissant de queijo',
      'quiche',
      'empada',
      'esfirra',
      'pastel',
      'pao frances',
      'pão francês',
      'pao de leite',
      'pão de leite',
      'pao de alho',
      'pão de alho',
      'pizza',
      'fatia de bolo',
      'pave',
      'pavê',
      'trufa',
      'eclair',
      'profiterole',
      'choux',
      'merengue',
      'suspiro',
      'torrone',
      'tarte',
      'creme brulee',
      'crème brûlée',
      'baba de camelo',
      'rabanada',
      'brioche',
      'baguete integral',
      'pao australiano',
      'pão australiano',
      'bolo de rolo',
      'bolo de laranja',
      'bolo de chocolate',
      'bolo de fubá',
      'bolo de milho',
      'bolo de cenoura',
      'suflê',
      'cannoli',
      'biscotti',
      'cantuccini',
      'beignet',
      'pandoro',
      'panetone',
      'colomba pascal',
      'babka',
      'strudel',
      'cronut'
    ];

    List<String> laticinios = [
      'leite',
      'queijo',
      'manteiga',
      'iogurte',
      'creme de leite',
      'coalhada',
      'leite condensado',
      'leite em po',
      'leite em pó',
      'creme de leite fresco',
      'requeijao',
      'requeijão',
      'queijo minas',
      'queijo coalho',
      'queijo prato',
      'queijo ricota',
      'queijo gorgonzola',
      'queijo parmesao',
      'queijo parmesão',
      'queijo cottage',
      'queijo roquefort',
      'queijo brie',
      'queijo camembert',
      'leite desnatado',
      'leite integral',
      'leite semidesnatado',
      'leite de cabra',
      'leite de soja',
      'leite de amêndoas',
      'leite de coco',
      'leite de arroz',
      'leite de aveia',
      'leite de castanha',
      'leite de avelã',
      'nata',
      'creme de leite sem lactose',
      'leite fermentado',
      'leite fermentado probiotico',
      'leite fermentado probiótico',
      'queijo mussarela',
      'queijo provolone',
      'queijo cheddar',
      'queijo estepe',
      'queijo gruyere',
      'queijo gruyère',
      'queijo edam',
      'queijo emmental',
      'queijo de cabra',
      'queijo de ovelha',
      'queijo tipo suíço',
      'queijo tipo suico',
      'queijo tipo reino',
      'queijo cottage desnatado',
      'ricota fresca',
      'queijo feta',
      'queijo mascarpone',
      'queijo azul',
      'queijo tipo boursin',
      'creme de queijo',
      'manteiga sem sal',
      'manteiga com sal',
      'margarina',
      'margarina light',
      'creme vegetal',
      'chantilly',
      'nata fresca',
      'nata batida',
      'leite condensado diet',
      'leite condensado sem lactose',
      'leite condensado de soja',
      'leite evaporado',
      'leite condensado de coco',
      'leite de kefir',
      'leite de kefir desnatado',
      'leite de kefir integral',
      'iogurte natural',
      'iogurte natural desnatado',
      'iogurte natural integral',
      'iogurte de frutas',
      'iogurte com mel',
      'iogurte com cereais',
      'coalhada seca',
      'cream cheese',
      'creme fraiche',
      'crème fraîche',
      'queijo de cabra fresco',
      'queijo de cabra curado',
      'queijo cottage com ervas',
      'queijo cottage com frutas'
    ];

    List<String> frios = [
      'presunto',
      'mortadela',
      'salame',
      'patê',
      'peito de peru',
      'blanquet de peru',
      'salaminho',
      'linguiça calabresa',
      'presunto parma',
      'salchicha',
      'salsicha',
      'linguiça toscana',
      'linguiça portuguesa',
      'frango defumado',
      'lombo canadense',
      'presunto cozido',
      'presunto cru',
      'pastrami',
      'roast beef',
      'bacon',
      'bacon em tiras',
      'bacon em cubos',
      'presunto de frango',
      'presunto de porco',
      'queijo de Minas',
      'queijo prato',
      'queijo mussarela',
      'queijo parmesão',
      'queijo ricota',
      'queijo gorgonzola',
      'queijo feta',
      'queijo gruyère',
      'queijo camembert',
      'queijo brie',
      'queijo roquefort',
      'queijo cheddar',
      'queijo de cabra',
      'queijo cottage',
      'cream cheese',
      'queijo provolone',
      'salsichão',
      'salame italiano',
      'mortadela italiana',
      'mortadela com pistache',
      'presunto defumado',
      'presunto de Parma',
      'presunto de peito de frango',
      'presunto de peito de peru'
    ];

    List<String> limpeza = [
      'sabão em pó', 'sabao em po', // Com e sem acento
      'amaciante',
      'limpa vidros',
      'água sanitária', 'agua sanitária', // Com e sem acento
      'desinfetante',
      'esponja',
      'lustra móveis', 'lustra moveis', // Com e sem acento
      'álcool', 'alcool', // Com e sem acento
      'pano de chão', 'pano de chao', // Com e sem acento
      'desengordurante',
      'limpador multiuso',
      'limpador perfumado',
      'tira manchas',
      'sabão de coco', 'sabao de coco', // Com e sem acento
      'água desmineralizada', 'agua desmineralizada', // Com e sem acento
      'limpador de banheiro',
      'limpador de cozinha',
      'limpador de vidros',
      'detergente',
      'desengordurante',
      'álcool em gel', 'alcool em gel', // Com e sem acento
      'desinfetante hospitalar',
      'produto anti-bacteriano',
      'produto anti-séptico',
      'limpeza pesada',
      'cleaner',
      'remover manchas',
      'desengordurante de cozinha',
      'neutralizador de odores',
      'desinfetante de banheiro',
      'desinfetante de cozinha',
      'limpador de estofados',
      'desengordurante para forno',
      'produto de limpeza ecológico',
      'spray de limpeza',
      'desinfetante para piso',
      'limpador de carpetes',
      'produto de limpeza multiuso',
      'amaciador de roupas',
      'sabão líquido',
      'desinfetante concentrado',
      'desinfetante suave',
      'limpador de vidros e espelhos',
      'detergente neutro',
      'limpador de superfícies',
      'limpador de janelas',
      'produto de limpeza rápida'
    ];

    List<String> higienePessoal = [
      'shampoo', 'xampu', // Com e sem acento
      'shampoo anticaspa',
      'shampoo infantil',
      'sabonete',
      'pasta de dente',
      'desodorante',
      'cotonete',
      'condicionador',
      'creme hidratante',
      'gel de banho',
      'fio dental',
      'perfume',
      'hidratante facial',
      'loção corporal', 'locao corporal', // Com e sem acento
      'protetor solar',
      'desodorante roll-on',
      'desodorante aerossol',
      'desodorante sem perfume',
      'desodorante em creme',
      'desodorante em spray',
      'desodorante em bastão',
      'desodorante em gel',
      'hidratante para as mãos',
      'hidratante para o corpo',
      'hidratante para o rosto',
      'loção para o corpo',
      'loção para o rosto',
      'creme para os pés',
      'creme para as mãos',
      'gel para cabelo',
      'pomada para cabelo',
      'manteiga corporal',
      'sabonete líquido',
      'sabonete em barra',
      'esfoliante corporal',
      'esfoliante facial',
      'tonificante facial',
      'creme anti-idade',
      'creme para olhos',
      'creme para lábios',
      'protetor solar facial',
      'protetor solar corporal',
      'protetor labial',
      'creme de barbear',
      'gel pós-barba',
      'loção pós-barba',
      'creme de depilação',
      'óleo para cabelo',
      'óleo corporal',
      'óleo facial',
      'máscara facial',
      'máscara capilar',
      'creme revitalizante',
      'creme suavizante'
    ];

    List<String> bebidas = [
      'água', 'agua', // Com e sem acento
      'refrigerante',
      'suco',
      'energético',
      'chá', 'cha', // Com e sem acento
      'cerveja',
      'vinho',
      'vodca', 'vodka', // Versões com e sem acento
      'rum',
      'whisky',
      'gin',
      'tequila',
      'licor',
      'espumante',
      'sidra',
      'vermute',
      'conhaque',
      'brandy',
      'saquê', 'sake', // Com e sem acento
      'aguardente',
      'cachaça',
      'licor de frutas',
      'cider', // Alternativa para sidra
      'champanhe', 'champagne', // Alternativas para espumante
      'aperitivo',
      'sangria',
      'vermouth',
      'mate', 'chá mate', // Alternativas para chá
      'agua com gás', 'água com gás', // Com e sem acento
      'suco de laranja',
      'suco de maçã', 'suco de maca', // Com e sem acento
      'suco de abacaxi', 'suco de abacaxi', // Com e sem acento
      'suco de morango',
      'suco de uva',
      'agua de coco', 'água de coco', // Com e sem acento
      'suco de caju',
      'suco de maracujá', 'suco de maracuja', // Com e sem acento
      'suco de limão', 'suco de limao', // Com e sem acento
      'refresco',
      'bebida energética',
      'bebida isotônica'
    ];

    List<String> mercearia = [
      'açúcar', 'acucar', // Com e sem acento
      'arroz',
      'azeite',
      'biscoito',
      'biscoito amanteigado',
      'biscoito de doce',
      'biscoito de maizena', 'biscoito de maisena', // Com e sem acento
      'biscoito de sal',
      'biscoito doce',
      'biscoito salgado',
      'café', 'cafe', // Com e sem acento
      'caldo de carne',
      'caldo de galinha',
      'cereal',
      'chocolate',
      'cookie',
      'cookie de aveia',
      'cookie de chocolate',
      'cookie integral',
      'farinha',
      'feijão', 'feijao', // Com e sem acento
      'feijão azuki', 'feijao azuki', // Com e sem acento
      'feijão branco', 'feijao branco', // Com e sem acento
      'feijão carioca', 'feijao carioca', // Com e sem acento
      'feijão fradinho', 'feijao fradinho', // Com e sem acento
      'feijão jalo', 'feijao jalo', // Com e sem acento
      'feijão preto', 'feijao preto', // Com e sem acento
      'feijão roxo', 'feijao roxo', // Com e sem acento
      'feijão verde', 'feijao verde', // Com e sem acento
      'feijão bolinha', 'feijao bolinha', // Com e sem acento
      'feijão rajado', 'feijao rajado', // Com e sem acento
      'feijão moyashi', 'feijao moyashi', // Com e sem acento
      'feijão mulatinho', 'feijao mulatinho', // Com e sem acento
      'gelatina',
      'macarrão', 'macarrao', // Com e sem acento
      'maionese',
      'margarina',
      'molho de tomate',
      'óleo', 'oleo', // Com e sem acento
      'pipoca',
      'sequilhos',
      'vinagre',
      'açúcar mascavo', 'acucar mascavo', // Com e sem acento
      'açúcar refinado', 'acucar refinado', // Com e sem acento
      'amido de milho',
      'pasta de dente', 'pasta de dentes', // Adicional
      'creme de leite',
      'leite condensado',
      'farinha de trigo',
      'açúcar cristal', 'acucar cristal', // Com e sem acento
      'açúcar de confeiteiro', 'acucar de confeiteiro', // Com e sem acento
      'farinha de rosca',
      'polvilho doce',
      'polvilho azedo',
      'manteiga',
      'mel',
      'geleia',
      'margarina culinária',
      'soro de leite',
      'creme de arroz',
      'creme de milho',
      'creme de soja',
      'farinha de mandioca',
      'farinha de milho',
      'farinha de coco',
      'flocos de milho',
      'granola',
      'aveia em flocos',
      'aveia instantânea',
      'leite em pó',
      'café solúvel',
      'café em grão',
      'leite condensado diet',
      'leite condensado sem lactose',
      'leite evaporado',
      'leite de amêndoas', 'leite de amendoas', // Com e sem acento
      'leite de soja',
      'leite de coco',
      'leite de arroz',
      'leite de aveia',
      'leite de castanha',
      'leite de avelã', 'leite de avela', // Com e sem acento
      'açúcar orgânico', 'acucar organico', // Com e sem acento
      'farinha integral',
      'farinha de trigo integral',
      'flocos de arroz',
      'farinha de grão-de-bico',
      'farinha de grao-de-bico' // Com e sem acento
          'leite de amêndoas',
      'leite de amendoas', // Com e sem acento
      'geleia de frutas',
      'geleia de morango',
      'geleia de uva',
      'geleia de pêssego', 'geleia de pessego', // Com e sem acento
      'melado de cana',
      'açúcar de coco', 'acucar de coco', // Com e sem acento
      'xarope de bordo',
      'xarope de agave',
      'compota de frutas',
      'conserva de legumes',
      'presunto em conserva',
      'bacon',
      'carne seca',
      'salame',
      'salsicha',
      'mortadela'
    ];

    // Verificar o produto
    if (carnes.contains(nomeProduto.toLowerCase())) {
      return Categoria.carnes.nomeFormatado;
    } else if (hortifruti.contains(nomeProduto.toLowerCase())) {
      return Categoria.hortifruti.nomeFormatado;
    } else if (padaria.contains(nomeProduto.toLowerCase())) {
      return Categoria.padaria.nomeFormatado;
    } else if (laticinios.contains(nomeProduto.toLowerCase())) {
      return Categoria.laticinios.nomeFormatado;
    } else if (frios.contains(nomeProduto.toLowerCase())) {
      return Categoria.frios.nomeFormatado;
    } else if (limpeza.contains(nomeProduto.toLowerCase())) {
      return Categoria.limpeza.nomeFormatado;
    } else if (higienePessoal.contains(nomeProduto.toLowerCase())) {
      return Categoria.higienePessoal.nomeFormatado;
    } else if (bebidas.contains(nomeProduto.toLowerCase())) {
      return Categoria.bebidas.nomeFormatado;
    } else if (mercearia.contains(nomeProduto.toLowerCase())) {
      return Categoria.mercearia.nomeFormatado;
    } else {
      return Categoria.indefinido.nomeFormatado;
    }
  }
}

/* 
      default:
        return obterCategoriaAleatoria().nomeFormatado;
*/