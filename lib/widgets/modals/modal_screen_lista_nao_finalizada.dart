import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/my_theme.dart';

Future<bool?> abrirListaNaoFinalizada(BuildContext? context) async {
  Completer<bool?> completer = Completer();

  showModalBottomSheet(
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              const Padding(
                padding: MyTheme.myCustomEdgeInsetsTitleModal,
                child: Text(
                    'Existe uma lista não finalizada. O que deseja fazer?',
                    style: MyTheme.myTextStyleTitleModal),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.deepPurple[100],
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Colors.deepPurple,
                      ),
                    ),
                    onPressed: () {
                      completer.complete(true);
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text('    Excluir    '),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.deepPurple,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Colors.white,
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
