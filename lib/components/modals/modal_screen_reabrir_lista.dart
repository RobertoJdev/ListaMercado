import 'dart:async';
import 'package:flutter/material.dart';

Future<bool?> reabrirListaScreen({BuildContext? context}) async {
  Completer<bool?> completer = Completer();

  showModalBottomSheet(
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Text(
                  'Reutilizar ou Abrir a lista?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.deepPurple,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      completer.complete(true);
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text('Reutilizar'),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.deepPurple[100],
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Colors.deepPurple,
                      ),
                    ),
                    onPressed: () {
                      completer.complete(false);
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text('    Abrir    '),
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
