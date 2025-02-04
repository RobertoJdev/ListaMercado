import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/models/categorias.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/util/decimal_text_input_formatter.dart';
import 'package:lista_mercado/widgets/button/custom_buttons.dart';

Future<Produto> confirmEditItemScreen(
    {BuildContext? context, required Produto itemTemp}) async {
  TextEditingController textEditingControllerEditItem =
      TextEditingController(text: itemTemp.descricao);
  TextEditingController textEditingControllerEditItemQuant =
      TextEditingController(text: itemTemp.quantidade.toString());
  TextEditingController textEditingControllerEditItemValor =
      TextEditingController(text: itemTemp.precoAtual.toString());

  if (textEditingControllerEditItemValor.text == '0.0') {
    textEditingControllerEditItemValor.text = '';
  }

  bool isButtonEnabled = false;
  String selectedCategory = itemTemp.categoria;

  isButtonEnabled = textEditingControllerEditItem.text.isNotEmpty &&
      textEditingControllerEditItemQuant.text.isNotEmpty;

  //FocusNode _focusNodeQuant = FocusNode();

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
                    child: Text('Edite ou confirme o produto.',
                        style: MyTheme.myTextStyleTitleModal),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsTextFildItensModal,
                    child: TextField(
                      //autofocus: true,
                      keyboardType: TextInputType.text,
                      controller: textEditingControllerEditItem,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: 'Produto',
                      ),
                      onChanged: (text) {
                        setState(() {
                          isButtonEnabled =
                              textEditingControllerEditItem.text.isNotEmpty &&
                                  textEditingControllerEditItemQuant
                                      .text.isNotEmpty;

                          selectedCategory = Categorias.defineCategoriaAuto(
                              textEditingControllerEditItem.text);
                        });
                      },

                      onTap: () {
                        // Seleciona todo o conteúdo ao focar no campo
                        textEditingControllerEditItem.selection =
                            TextSelection(
                          baseOffset: 0,
                          extentOffset:
                              textEditingControllerEditItem.text.length,
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
                              DecimalTextInputFormatter(), // Aplicando o formatador personalizado
                            ],
                            //focusNode: _focusNodeQuant,
                            //inputFormatters: [
                            //  FilteringTextInputFormatter.allow(
                            //      RegExp(r'[0-9\.,]')),
                            // ],
                            keyboardType: TextInputType.number,
                            controller: textEditingControllerEditItemQuant,
                            textAlign: TextAlign.center,
                            onChanged: (text) {
                              setState(() {
                                isButtonEnabled = textEditingControllerEditItem
                                        .text.isNotEmpty &&
                                    textEditingControllerEditItemQuant
                                        .text.isNotEmpty;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Quantidade',
                            ),

                            onTap: () {
                              // Seleciona todo o conteúdo ao focar no campo
                              textEditingControllerEditItemQuant.selection =
                                  TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    textEditingControllerEditItemQuant
                                        .text.length,
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 10), // Espaço entre os campos
                        Expanded(
                          child: TextField(
                            autofocus: true,

                            inputFormatters: [
                              DecimalTextInputFormatter(), // Aplicando o formatador personalizado
                            ],

                            // inputFormatters: [
                            //  FilteringTextInputFormatter.allow(
                            //       RegExp(r'[0-9\.,]')),
                            //  ],
                            keyboardType: TextInputType.number,
                            controller: textEditingControllerEditItemValor,
                            textAlign: TextAlign.center,
                            onChanged: (text) {
                              setState(() {
                                isButtonEnabled = textEditingControllerEditItem
                                        .text.isNotEmpty &&
                                    textEditingControllerEditItemQuant
                                        .text.isNotEmpty;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Valor',
                            ),
                            onTap: () {
                              // Seleciona todo o conteúdo ao focar no campo
                              textEditingControllerEditItemValor.selection =
                                  TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    textEditingControllerEditItemValor
                                        .text.length,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lista suspensa de categorias
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
                                  //menuMaxHeight: 100,
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
                                          value: categoria.nomeFormatado,
                                          child: Text(
                                            categoria.nomeFormatado,
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
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsButtomModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButtons.buttomCancelar(
                          context: context,
                          boolComplete: null,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: isButtonEnabled
                                  ? WidgetStateProperty.all(Colors.deepPurple)
                                  : WidgetStateProperty.all(
                                      Colors.deepPurple[100]),
                            ),
                            onPressed: isButtonEnabled
                                ? () {
                                    double? quantidade = double.tryParse(
                                      textEditingControllerEditItemQuant.text
                                          .replaceAll(',', '.'),
                                    );
                                    double? valor = double.tryParse(
                                      textEditingControllerEditItemValor.text
                                          .replaceAll(',', '.'),
                                    );

                                    if (valor == null ||
                                        valor == 0.0 &&
                                            textEditingControllerEditItem
                                                    .text !=
                                                '') {
                                      valor ??= 0.0;
                                      itemTemp.descricao =
                                          textEditingControllerEditItem.text;
                                      itemTemp.quantidade = quantidade!;
                                      itemTemp.precoAtual = valor ?? 0.0;
                                      itemTemp.categoria = selectedCategory;

                                      itemTemp.pendente = true;

                                      //print('${valor} =========================');

                                      Navigator.of(context).pop(itemTemp);
                                    } else if (valor > 0.0 &&
                                        textEditingControllerEditItem.text !=
                                            '') {
                                      itemTemp.descricao =
                                          textEditingControllerEditItem.text;
                                      itemTemp.quantidade = quantidade!;
                                      itemTemp.precoAtual = valor;
                                      itemTemp.categoria = selectedCategory;

                                      itemTemp.pendente = false;

                                      Navigator.of(context).pop(itemTemp);
                                    }
                                  }
                                : null,
                            child: CustomButtons.buttomOK()),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
  //_focusNodeQuant.dispose();
  return itemTemp;
}
