import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:intl/intl.dart';

Future<Produto?> newItemScreen(BuildContext context) async {
  Produto? newItem;

  TextEditingController _textEditingControllerNewItem = TextEditingController();
  TextEditingController _textEditingControllerNewItemQuant =
      TextEditingController();

  Completer<Produto?> completer = Completer();

  bool isButtonEnabled = false;

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      'Informe o novo item',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      autofocus: true,
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                      ],
                      keyboardType: TextInputType.number,
                      controller: _textEditingControllerNewItemQuant,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      onChanged: (text) {
                        setState(() {
                          isButtonEnabled = text.isNotEmpty;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple[100],
                          ),
                        ),
                        onPressed: () {
                          completer.complete(null);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: isButtonEnabled
                              ? MaterialStateProperty.all(
                                  Colors.deepPurple,
                                )
                              : MaterialStateProperty.all(
                                  Colors.deepPurple[100],
                                ),
                        ),
                        onPressed: isButtonEnabled
                            ? () {
                                String quantidadeText =
                                    _textEditingControllerNewItemQuant.text;

                                // Substituir ',' por '.' antes da conversão
                                quantidadeText =
                                    quantidadeText.replaceAll(',', '.');
                                double? quantidade =
                                    double.tryParse(quantidadeText);

                                if (quantidade != null) {
                                  newItem = Produto.newItemList(
                                    descricao:
                                        _textEditingControllerNewItem.text,
                                    quantidade: quantidade,
                                  );

                                  _textEditingControllerNewItem.text = '';
                                  _textEditingControllerNewItemQuant.text = '';

                                  completer.complete(newItem);
                                  Navigator.of(context).pop();
                                } else {
                                  // Trate o caso em que a conversão falhou, por exemplo, exibindo uma mensagem de erro.
                                  print("Quantidade inválida");
                                }
                              }
                            : null,
                        child: const Text(
                          '  OK  ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );

  // Adicione informações padrão ao newItem se necessário
  newItem?.barras = 12345678.toString();
  newItem?.precoAtual = 5.0;
  newItem?.historicoPreco = [4, 5, 5, 5];

  return completer.future;
}
