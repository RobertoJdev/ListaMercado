import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/button/custom_buttons.dart';
import 'dart:async';

Future<String?> confirmShareEmailScreen({BuildContext? context}) async {
  TextEditingController _emailController = TextEditingController();
  Completer<String?> completer = Completer();
  bool isButtonEnabled = false;
  bool saveAsPreferred = false;

  Future<void> _savePreferredEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferredEmail', email);
  }

  Future<void> _loadPreferredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final preferredEmail = prefs.getString('preferredEmail');
    if (preferredEmail != null) {
      _emailController.text = preferredEmail;
      saveAsPreferred = true;
    }
  }

  await _loadPreferredEmail();

  await showModalBottomSheet(
    isScrollControlled: true,
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
                    child: Text(
                      'Insira o e-mail para compartilhar:',
                      style: MyTheme.myTextStyleTitleModal,
                    ),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsTextFildItensModal,
                    child: TextField(
                      autofocus: true,
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        //hintText: 'exemplo@dominio.com',
                      ),
                      onChanged: (text) {
                        setState(() {
                          isButtonEnabled = RegExp(
                                  r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                              .hasMatch(
                                  text); // Habilita o botão apenas com e-mail válido
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsTextFildItensModal,
                    child: Row(
                      children: [
                        Checkbox(
                          value: saveAsPreferred,
                          onChanged: (bool? value) {
                            setState(() {
                              saveAsPreferred = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Salvar como e-mail preferencial',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsButtomModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButtons.buttomCancelar(
                          completer: completer,
                          context: context,
                          boolComplete: null,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: isButtonEnabled
                                ? MaterialStateProperty.all(
                                    Colors.deepPurple,
                                  )
                                : MaterialStateProperty.all(
                                    Colors.deepPurple[100],
                                  ),
                          ),
                          onPressed: isButtonEnabled
                              ? () {
                                  final email = _emailController.text.trim();
                                  if (saveAsPreferred) {
                                    _savePreferredEmail(email);
                                  }
                                  completer.complete(email);
                                  _emailController.clear();
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: CustomButtons.buttomOK(),
                        ),
                      ],
                    ),
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
