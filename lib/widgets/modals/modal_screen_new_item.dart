import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:intl/intl.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:path/path.dart';

import '../botton/custom_buttons .dart';

Future<Produto?> newItemScreen(BuildContext context) async {
  Produto? newItem;

  TextEditingController _textEditingControllerNewItem = TextEditingController();
  TextEditingController _textEditingControllerNewItemQuant =
      TextEditingController();
  TextEditingController _textEditingControllerNewItemValor =
      TextEditingController();

  Completer<Produto?> completer = Completer();

  bool isButtonEnabled = false;
  String selectedCategory = Categorias.obterCategoriaAleatoria();

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
                children: [
                  const Padding(
                    padding: MyTheme.myCustomEdgeInsetsTitleModal,
                    child: Text(
                      'Informe o novo item.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsTextFildItensModal,
                    child: TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      controller: _textEditingControllerNewItem,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        labelText: 'Produto',
                      ),
                      onChanged: (text) {
                        setState(
                          () {
                            isButtonEnabled =
                                _textEditingControllerNewItem.text.isNotEmpty &&
                                    _textEditingControllerNewItemQuant
                                        .text.isNotEmpty;
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsTextFildItensModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9\.,]')),
                            ],
                            keyboardType: TextInputType.number,
                            controller: _textEditingControllerNewItemQuant,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            onChanged: (text) {
                              setState(() {
                                isButtonEnabled = _textEditingControllerNewItem
                                        .text.isNotEmpty &&
                                    _textEditingControllerNewItemQuant
                                        .text.isNotEmpty;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Quantidade',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Espaço entre os campos
                        Expanded(
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9\.,]')),
                            ],
                            keyboardType: TextInputType.number,
                            controller: _textEditingControllerNewItemValor,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              labelText: 'Valor',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsTextFildItensModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  MyTheme.myCustomEdgeInsetsTextFildItensModal,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  alignment: Alignment.center,
                                  style: MyTheme.myTextStyleDropDownButton,
                                  value: selectedCategory,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCategory = newValue!;
                                    });
                                  },
                                  items: Categorias.obterTodasCategorias()
                                      .map<DropdownMenuItem<String>>(
                                        (Categoria categoria) =>
                                            DropdownMenuItem<String>(
                                          alignment: Alignment.center,
                                          value: categoria.nome,
                                          child: Text(
                                            categoria.nome,
                                            style: MyTheme
                                                .myTextStyleDropDownButton,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtons.buttomCancelar(
                        context: context,
                        boolComplete: null,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: _textEditingControllerNewItem
                                        .text.isNotEmpty &&
                                    _textEditingControllerNewItemQuant
                                        .text.isNotEmpty
                                ? MaterialStateProperty.all(Colors.deepPurple)
                                : MaterialStateProperty.all(
                                    Colors.deepPurple[100]),
                          ),
                          onPressed: _textEditingControllerNewItem
                                      .text.isNotEmpty &&
                                  _textEditingControllerNewItemQuant
                                      .text.isNotEmpty
                              ? () {
                                  String descricao =
                                      _textEditingControllerNewItem.text;
                                  String quantidadeText =
                                      _textEditingControllerNewItemQuant.text;
                                  String valorText =
                                      _textEditingControllerNewItemValor.text;

                                  // Substituir ',' por '.' antes da conversão
                                  quantidadeText =
                                      quantidadeText.replaceAll(',', '.');
                                  valorText = valorText.replaceAll(',', '.');

                                  double? quantidade =
                                      double.tryParse(quantidadeText);
                                  double? valor = double.tryParse(valorText);

                                  if (quantidade != null) {
                                    newItem = Produto.newItemList(
                                      descricao: descricao,
                                      quantidade: quantidade,
                                      precoAtual: valor ?? 0.0,
                                      categoria: selectedCategory,
                                    );

                                    _textEditingControllerNewItem.text = '';
                                    _textEditingControllerNewItemQuant.text =
                                        '';
                                    _textEditingControllerNewItemValor.text =
                                        '';

                                    completer.complete(newItem);
                                    Navigator.of(context).pop();
                                  } else {
                                    // Trate o caso em que a conversão falhou.
                                    print("Quantidade inválida");
                                  }
                                }
                              : null,
                          child: CustomButtons.buttomOK()),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );

  // Adicione informações padrão ao newItem se necessário
  newItem?.barras = 12345678.toString();
  //newItem?.precoAtual = 0.0;
  newItem?.historicoPreco = [4, 5, 5, 5];

  return completer.future;
}
