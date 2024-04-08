import 'package:flutter/material.dart';

enum Categoria {
  carnes,
  hortifruti,
  padaria,
  laticinios,
  frios,
  limpeza,
  higienePessoal,
  bebidas,
  mercearia,
}

extension CategoriaExtension on Categoria {
  String get nomeFormatado {
    switch (this) {
      case Categoria.carnes:
        return 'Carnes';
      case Categoria.hortifruti:
        return 'Hortifruti';
      case Categoria.padaria:
        return 'Padaria';
      case Categoria.laticinios:
        return 'Laticínios';
      case Categoria.frios:
        return 'Frios';
      case Categoria.limpeza:
        return 'Limpeza';
      case Categoria.higienePessoal:
        return 'Higiene Pessoal';
      case Categoria.bebidas:
        return 'Bebidas';
      case Categoria.mercearia:
        return 'Mercearia';
    }
  }

  Color get cor {
    switch (this) {
      case Categoria.carnes:
        return Colors.pink[50]!;
      case Categoria.hortifruti:
        return Colors.green[50]!;
      case Categoria.padaria:
        return Colors.brown[50]!;
      case Categoria.laticinios:
        return Colors.blue[50]!;
      case Categoria.frios:
        return Colors.blueGrey[50]!;
      case Categoria.limpeza:
        return Colors.deepOrange[50]!;
      case Categoria.higienePessoal:
        return Colors.deepPurple[50]!;
      case Categoria.bebidas:
        return Colors.teal[50]!;
      case Categoria.mercearia:
        return Colors.yellow[50]!;
    }
  }

  Color get corSecundaria {
    switch (this) {
      case Categoria.carnes:
        return Colors.pink[200]!;
      case Categoria.hortifruti:
        return Colors.green[200]!;
      case Categoria.padaria:
        return Colors.brown[200]!;
      case Categoria.laticinios:
        return Colors.blue[200]!;
      case Categoria.frios:
        return Colors.blueGrey[200]!;
      case Categoria.limpeza:
        return Colors.orange[200]!;
      case Categoria.higienePessoal:
        return Colors.purple[200]!;
      case Categoria.bebidas:
        return Colors.teal[200]!;
      case Categoria.mercearia:
        return Colors.yellow[200]!;
    }
  }
}
