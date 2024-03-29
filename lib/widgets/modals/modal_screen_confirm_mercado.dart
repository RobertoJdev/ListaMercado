import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:lista_mercado/widgets/botton/custom_buttons%20.dart';

Future<String?> confirmMercadoScreen({BuildContext? context}) async {
  TextEditingController _textEditingController = TextEditingController();
  Completer<String?> completer = Completer();
  bool isButtonEnabled = false;

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context!,
    builder: (BuildContext content) {
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
                      'Qual é o supermercado?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextField(
                      autofocus: true,
                      controller: _textEditingController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        labelText: 'Supermercado',
                      ),
                      onChanged: (text) {
                        setState(() {
                          isButtonEnabled = text.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtons.buttomCancelar(
                          completer: completer,
                          context: context,
                          boolComplete: null),

                      /*
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple[100],
                          ),
                        ),
                        onPressed: () {
                          completer.complete(null);
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Cancelar'),
                        ),
                      ),
                      */

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
                                completer.complete(_textEditingController.text);
                                _textEditingController.text = '';
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: CustomButtons.buttomOK(),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  return completer.future;
}
