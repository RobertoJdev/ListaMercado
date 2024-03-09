import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/util/json_converter.dart';
import 'package:lista_mercado/util/save_file.dart';
import 'package:flutter/services.dart';

Future<bool?> compartilharLista(
    {BuildContext? context, required ListaMercado listaMercado}) async {
  TextEditingController _textEditingController = TextEditingController();
  Completer<bool> completer = Completer();
  bool isButtonEnabled = false;

  //Firebase.initializeApp();

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      'Digite seu email para compartilhar a lista.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      autofocus: true,
                      controller: _textEditingController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (text) {
                        setState(() {
                          isButtonEnabled = text.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple[100],
                          ),
                        ),
                        onPressed: () {
                          //completer.complete(null);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: isButtonEnabled
                                ? MaterialStateProperty.all(Colors.deepPurple)
                                : MaterialStateProperty.all(
                                    Colors.deepPurple[100])),
                        onPressed: isButtonEnabled
                            ? () async {
                                //completer.complete(_textEditingController.text);
                                _textEditingController.text = '';

                                String conteudoArquivo = jsonEncode(
                                    JsonConverter.listaMercadoToJson(
                                        listaMercado));

                                String nomeArquivo = 'lista_mercado.txt';

                                try {
                                  File file =
                                      await SaveFile.salvarEmArquivoArquivo(
                                          nomeArquivo, conteudoArquivo);

                                  //Share.shareFiles(file.path);
                                  //FileShare.shareFile(file, nomeArquivo);

                                  //SaveFile.saveToStorage(
                                  //  nomeArquivo, file.path);

                                  //SaveFile.uploadFileToDrive(file.path);

                                  print(
                                      'Arquivo salvo com sucesso em: ${file.path}');
                                } catch (e) {
                                  print('Erro ao salvar o arquivo: $e');
                                }

                                Navigator.of(context).pop();

                                // return true;
                              }
                            : null,
                        child: const Text(
                          'Enviar',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  //return completer.future;
}
