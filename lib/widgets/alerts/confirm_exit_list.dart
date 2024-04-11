import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/screen_active_list.dart';

import '../botton/custom_buttons .dart';

class ConfirmExitDialog extends StatelessWidget {
  //final VoidCallback onSaveAndExit;

  const ConfirmExitDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      alignment: Alignment.center,
      title: const Text(
        'Confirmar saída',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Tem certeza de que deseja sair?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            '    Cancelar    ',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            if (activeListKey.currentState != null) {
              activeListKey.currentState!.salvarListaTemp();
            } else {
              print('activeListKey.currentState is null');
            }
            // activeListKey.currentState?.salvarListaTemp();
            //Navigator.of(context).pop();
            //Navigator.of(context).pop();            
          },
          child: const Text(
            'Salvar e Sair',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
}
