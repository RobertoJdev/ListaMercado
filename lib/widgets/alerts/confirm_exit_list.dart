import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/screen_active_list.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';

import '../button/custom_buttons.dart';

class ConfirmExitDialog extends StatelessWidget {
  //final VoidCallback onSaveAndExit;

  const ConfirmExitDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.all(0),
      //iconPadding: EdgeInsets.all(10),
      titlePadding:
          const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
      icon: const Icon(
        Icons.warning_outlined,
        color: Colors.red,
        size: 50,
      ),
      shadowColor: Colors.deepPurple,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      alignment: Alignment.center,
      title: const Text(
        'Lista não finalizada!',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Text(
          'Deseja salvar a lista não finalizada?',
          textAlign: TextAlign.center,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed: () {
              //print('Botão NÃO pressionado');
              Navigator.pop(context, false);
            },
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepPurple[100]),
                foregroundColor: WidgetStateProperty.all(Colors.deepPurple)),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('  Não  '),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed: () {
              //print('Botão SALVAR pressionado');
              Navigator.pop(context, true);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Salvar'),
            ),
          ),
        ),
      ],
    );
  }
}
