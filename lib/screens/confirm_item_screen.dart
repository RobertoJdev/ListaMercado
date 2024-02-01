import 'package:flutter/material.dart';
import 'dart:async';

import 'package:lista_mercado/models/item_market.dart';

Future<double?> ConfirmItemScreen({BuildContext? context}) async {
  TextEditingController _textEditingController = TextEditingController();
  double? price;

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
              keyboardType: TextInputType.number,
              controller: _textEditingController,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                price = double.parse(_textEditingController.text);
                _textEditingController.text = '';
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ])
        ]);
      });

  return price;
}
