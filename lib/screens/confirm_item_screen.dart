import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lista_mercado/models/produto.dart';

Future<double?> confirmItemScreen({BuildContext? context}) async {
  TextEditingController _textEditingController = TextEditingController();
  Completer<double?> completer = Completer();

  showModalBottomSheet(
    context: context!,
    builder: (BuildContext content) {
      return Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            'Qual o valor do item?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            controller: _textEditingController,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.deepPurple[100], // Substitua pelo nome da cor desejada
              ),
            ),
            onPressed: () {
              completer
                  .complete(null); // Completa o Future com null (cancelado)
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.deepPurple, // Substitua pelo nome da cor desejada
              ),
            ),
            onPressed: () {
              double? price = double.tryParse(_textEditingController.text);
              completer
                  .complete(price); // Completa o Future com o preço inserido
              _textEditingController.text = '';
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          )
        ])
      ]);
    },
  );

  return completer.future;
}
