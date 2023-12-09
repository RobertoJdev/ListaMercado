import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

Future<String?> confirmMercadoScreen({BuildContext? context}) async {
  TextEditingController _textEditingController = TextEditingController();
  Completer<String?> completer = Completer();
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
                  'Qual é o supermercado?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  autofocus: true,
                  controller: _textEditingController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
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
                            completer.complete(_textEditingController.text);
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
