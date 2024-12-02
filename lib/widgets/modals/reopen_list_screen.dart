import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/button/custom_buttons.dart';

Future<bool?> reopenList({BuildContext? context}) async {
  Completer<bool?> completer = Completer();

  showModalBottomSheet(
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.deepPurple
                  ], // Defina as cores do gradiente aqui
                  begin: Alignment.center, // Ponto inicial do gradiente
                  end: Alignment.bottomCenter, // Ponto final do gradiente
                ),
              ),
              //color: MyTheme.modalColorBackground,
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
