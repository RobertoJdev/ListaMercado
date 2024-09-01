import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/botton/custom_buttons%20.dart';

Future<bool?> showDeleteItemConfirmationDialog(BuildContext context) async {
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
                    child: Text('Deseja excluir o item da lista?',
                        style: MyTheme.myTextStyleTitleModal),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsButtomModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButtons.buttomNao(
                            completer: completer,
                            context: context,
                            boolComplete: false),
                        CustomButtons.buttomSim(
                            completer: completer,
                            context: context,
                            boolComplete: true),
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
