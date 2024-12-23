import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/screen_active_list.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';

import '../button/custom_buttons.dart';

class ConfirmExitDialog extends StatelessWidget {
  //final VoidCallback onSaveAndExit;

  const ConfirmExitDialog({
    Key? key,
  }) : super(key: key);

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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScreenListasMercado()),
                (route) => false,
              );
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.deepPurple[100]),
                foregroundColor: MaterialStateProperty.all(Colors.deepPurple)),
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
              if (activeListKey.currentState != null) {
                activeListKey.currentState!.salvarListaTemp();
              } else {
                print('activeListKey.currentState is null');
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              foregroundColor: MaterialStateProperty.all(Colors.white),
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
