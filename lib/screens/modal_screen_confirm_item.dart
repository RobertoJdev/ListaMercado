import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<double?> confirmItemScreen({BuildContext? context}) async {
  TextEditingController _textEditingController = TextEditingController();
  Completer<double?> completer = Completer();
  bool isButtonEnabled = false;

  showModalBottomSheet(
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Qual o valor do item?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                  ],
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: _textEditingController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                  onChanged: (text) {
                    setState(() {
                      isButtonEnabled = text.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    prefixText: 'R\$ ',
                    prefixStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
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
                            double? price = double.tryParse(
                              _textEditingController.text.replaceAll(',', '.'),
                            );
                            completer.complete(price);
                            _textEditingController.text = '';
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text(
                      '  OK  ',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    },
  );

  return completer.future;
}
