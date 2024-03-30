import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/botton/custom_buttons%20.dart';

Future<bool?> reabrirListaScreen({BuildContext? context}) async {
  Completer<bool?> completer = Completer();

  showModalBottomSheet(
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              color: MyTheme.modalColorBackground,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: MyTheme.myCustomEdgeInsetsTitleModal,
                    child: Text('Reutilizar ou Abrir a lista?',
                        style: MyTheme.myTextStyleTitleModal),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsButtomModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButtons.buttomReutilizar(
                            completer: completer,
                            context: context,
                            boolComplete: true),
                        CustomButtons.buttomAbrir(
                            completer: completer,
                            context: context,
                            boolComplete: false),
                        /* TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.deepPurple[100],),
                            foregroundColor: MaterialStateProperty.all(Colors.deepPurple,),),
                          onPressed: () {
                            completer.complete(false);
                            Navigator.of(context).pop();},
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text('    Abrir    '),)) */
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
