import 'package:flutter/material.dart';

import '../botton/custom_buttons .dart';

class ConfirmExitDialog extends StatelessWidget {
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
            'Cancelar',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text(
            '   Sair   ',
             style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
}
