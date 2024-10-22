import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CustomButtons {
  static Widget buttomExcluir({
    required Completer completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
        onPressed: () {
          completer.complete(boolComplete);
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple[100]),
            foregroundColor: MaterialStateProperty.all(Colors.deepPurple)),
        child: const Padding(
            padding: EdgeInsets.all(10.0), child: Text(' Excluir ')));
  }

  static Widget buttomCancelar({
    Completer? completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        completer?.complete(boolComplete);
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple[100]),
          foregroundColor: MaterialStateProperty.all(Colors.deepPurple)),
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Cancelar'),
      ),
    );
  }

  static Widget buttomCancelarAlt({
    Completer? completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        completer?.complete(boolComplete);
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Cancelar'),
      ),
    );
  }

  static Widget buttomOK() {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        '     OK     ',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  static Widget buttomSair({
    required BuildContext context,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Text('   Sair   '),
      ),
    );
  }

  static Widget buttomAbrir({
    //completer.complete(false);
    required Completer completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        completer.complete(boolComplete);
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple[100]),
          foregroundColor: MaterialStateProperty.all(Colors.deepPurple)),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Text('    Abrir    '),
      ),
    );
  }

  static Widget buttomAbrirAlt({
    //completer.complete(false);
    required Completer completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        completer.complete(boolComplete);
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Text('    Abrir    '),
      ),
    );
  }

  static Widget buttomReutilizar({
    //completer.complete(false);
    required Completer completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        //completer.complete(true);
        completer.complete(boolComplete);
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Text('Reutilizar'),
      ),
    );
  }

  static Widget buttomSim({
    required Completer completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
        onPressed: () {
          completer.complete(boolComplete);
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple[100]),
            foregroundColor: MaterialStateProperty.all(Colors.deepPurple)),
        child:
            const Padding(padding: EdgeInsets.all(10.0), child: Text(' Sim ')));
  }

  static Widget buttomNao({
    Completer? completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        completer?.complete(boolComplete);
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(' Não '),
      ),
    );
  }

  static Widget buttomSalvar({
    Completer? completer,
    required BuildContext context,
    required bool? boolComplete,
    //required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: () {
        completer?.complete(boolComplete);
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Salvar'),
      ),
    );
  }
}
