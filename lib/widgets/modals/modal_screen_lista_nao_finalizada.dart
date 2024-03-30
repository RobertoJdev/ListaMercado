import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/botton/custom_buttons%20.dart';

Future<bool?> abrirListaNaoFinalizada(BuildContext? context) async {
  Completer<bool?> completer = Completer();

  showModalBottomSheet(
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: MyTheme.modalColorBackground,
            child: Column(
              children: [
                const Padding(
                  padding: MyTheme.myCustomEdgeInsetsTitleModal,
                  child: Text('Há uma lista não concluída. O que deseja fazer?',
                      style: MyTheme.myTextStyleTitleModal),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtons.buttomExcluir(
                        completer: completer,
                        context: context,
                        boolComplete: true),
                    CustomButtons.buttomAbrir(
                        completer: completer,
                        context: context,
                        boolComplete: false),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );

  return completer.future;
}
