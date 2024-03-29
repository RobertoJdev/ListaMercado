import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lista_mercado/widgets/botton/custom_buttons%20.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
  Completer<bool?> completer = Completer();

  showModalBottomSheet(
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Text(
                  'Confirma exclusão da lista?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*
                  ElevatedButton(
                    onPressed: () {
                      completer.complete(false);
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.deepPurple,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Cancelar'),
                    ),
                  ),
                  */
                  CustomButtons.buttomCancelar(
                      completer: completer,
                      context: context,
                      boolComplete: false),
                  CustomButtons.buttomExcluir(
                      completer: completer, context: context, boolComplete: true),

                  /*
                  ElevatedButton(
                    onPressed: () {
                      completer.complete(true);
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.deepPurple[100],
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Colors.deepPurple,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(' Excluir '),
                    ),
                  )
*/
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
