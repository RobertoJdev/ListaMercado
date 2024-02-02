import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/models/produto.dart';

Future<Produto> confirmEditItemScreen(
    {BuildContext? context, required Produto itemTemp}) async {
  TextEditingController _textEditingControllerEditItem =
      TextEditingController(text: itemTemp.descricao);
  TextEditingController _textEditingControllerEditItemQuant =
      TextEditingController(text: itemTemp.quantidade.toString());
  TextEditingController _textEditingControllerEditItemValor =
      TextEditingController(text: itemTemp.precoAtual.toString());

  if (_textEditingControllerEditItemValor.text == null ||
      _textEditingControllerEditItemValor.text == '0.0') {
    _textEditingControllerEditItemValor.text = '';
  }

  bool isButtonEnabled = false;
  String selectedCategory = itemTemp.categoria;

  isButtonEnabled = _textEditingControllerEditItem.text.isNotEmpty &&
      _textEditingControllerEditItemQuant.text.isNotEmpty;

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
                      'Edite ou confirme o produto.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      //autofocus: true,
                      keyboardType: TextInputType.text,
                      controller: _textEditingControllerEditItem,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        labelText: 'Produto',
                      ),
                      onChanged: (text) {
                        setState(() {
                          isButtonEnabled =
                              _textEditingControllerEditItem.text.isNotEmpty &&
                                  _textEditingControllerEditItemQuant
                                      .text.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            controller: _textEditingControllerEditItemQuant,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            onChanged: (text) {
                              setState(() {
                                isButtonEnabled = _textEditingControllerEditItem
                                        .text.isNotEmpty &&
                                    _textEditingControllerEditItemQuant
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
                            autofocus: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9\.,]')),
                            ],
                            keyboardType: TextInputType.number,
                            controller: _textEditingControllerEditItemValor,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            onChanged: (text) {
                              setState(() {
                                isButtonEnabled = _textEditingControllerEditItem
                                        .text.isNotEmpty &&
                                    _textEditingControllerEditItemQuant
                                        .text.isNotEmpty;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Valor',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Adicione esta parte para a lista suspensa de categorias
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
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
                                    child: Text(categoria.nome),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
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
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: isButtonEnabled
                              ? MaterialStateProperty.all(Colors.deepPurple)
                              : MaterialStateProperty.all(
                                  Colors.deepPurple[100]),
                        ),
                        onPressed: isButtonEnabled
                            ? () {
                                double? quantidade = double.tryParse(
                                  _textEditingControllerEditItemQuant.text
                                      .replaceAll(',', '.'),
                                );
                                double? valor = double.tryParse(
                                  _textEditingControllerEditItemValor.text
                                      .replaceAll(',', '.'),
                                );

                                if (valor == null ||
                                    valor == 0.0 &&
                                        _textEditingControllerEditItem.text !=
                                            '') {
                                  if (valor == null) {
                                    valor = 0.0;
                                  }
                                  itemTemp.descricao =
                                      _textEditingControllerEditItem.text;
                                  itemTemp.quantidade = quantidade!;
                                  itemTemp.precoAtual = valor ?? 0.0;
                                  itemTemp.categoria = selectedCategory;

                                  itemTemp.pendente = true;

                                  //print('${valor} =========================');

                                  Navigator.of(context).pop(itemTemp);
                                } else if (valor != null &&
                                    valor > 0.0 &&
                                    _textEditingControllerEditItem.text != '') {
                                  itemTemp.descricao =
                                      _textEditingControllerEditItem.text;
                                  itemTemp.quantidade = quantidade!;
                                  itemTemp.precoAtual = valor;
                                  itemTemp.categoria = selectedCategory;

                                  itemTemp.pendente = false;

                                  //print('${valor} ***************************');

                                  Navigator.of(context).pop(itemTemp);
                                }
                              }
                            : null,
                        child: const Text(
                          '  OK  ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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

  return itemTemp;
}
