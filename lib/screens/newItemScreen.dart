import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lista_mercado/models/item_market.dart';

Future<ItemMarket?> newItemScreen(BuildContext context) async {
  //Completer<ItemMarket> completer = Completer<ItemMarket>();
  ItemMarket? newItem;

  TextEditingController _textEditingControllerNewItem = TextEditingController();
  TextEditingController _textEditingControllerNewItemQuant =
      TextEditingController();

  await showModalBottomSheet(
    context: context,
    builder: (BuildContext content) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text(
              'Informe o novo item',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _textEditingControllerNewItem,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                labelText: 'Produto',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _textEditingControllerNewItemQuant,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                labelText: 'Quantidade',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  //completer.complete(null); // Completa o Future com null para indicar cancelamento.
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  newItem = ItemMarket(
                    _textEditingControllerNewItem.text.toString(),
                    int.parse(_textEditingControllerNewItemQuant.text),
                    0,
                    [],
                    false,
                  );

                  _textEditingControllerNewItem.text = '';
                  _textEditingControllerNewItemQuant.text = '';

                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          )
        ],
      );
    },
  );

  print(newItem?.name);

  return newItem;
}
