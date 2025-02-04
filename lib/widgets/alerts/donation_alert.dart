import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_mercado/my_theme.dart';

class DonationAlert extends StatelessWidget {
  final String pixKey;

  const DonationAlert({super.key, this.pixKey = 'roberto.dev.apps@gmail.com'});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyTheme.alertColorBackground,
      alignment: Alignment.center,
      title: const Text(
        textAlign: TextAlign.center,
        'Faça uma Doação!',
        style: TextStyle(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            color: Colors.deepPurpleAccent,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              textAlign: TextAlign.center,
              'Gostou do aplicativo?\n Considere fazer uma doação para o desenvolvedor e apoiar o seu trabalho.',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          const SizedBox(height: 18.0),
          ElevatedButton(
            style: MyTheme.chavePixButton,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: pixKey));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Chave PIX copiada para a área de transferência.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
            child: const Text('Copiar Chave PIX'),
          ),
          Text('Chave pix: $pixKey'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
