import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/botton/custom_buttons%20.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
  Completer<bool?> completer = Completer();

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              color: MyTheme.modalColorBackground,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: MyTheme.myCustomEdgeInsetsTitleModal,
                    child: Text('Confirma exclusão da lista?',
                        style: MyTheme.myTextStyleTitleModal),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsButtomModal,
                    child: Row(
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
                        CustomButtons.buttomCancelarAlt(
                            completer: completer,
                            context: context,
                            boolComplete: false),
                        CustomButtons.buttomExcluir(
                            completer: completer,
                            context: context,
                            boolComplete: true),

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
                  ),
                  const SizedBox(
                    height: 300,
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
