import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:lista_mercado/models/categorias.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/modals/confirm_edit_item_screen.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/widgets/items/item_list_confirmed.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/util/format_value.dart';
// Import necessário para gráficos
import 'package:fl_chart/fl_chart.dart';
import 'package:lista_mercado/widgets/modals/show_price_history_modal.dart';

class ItemListPendent extends StatelessWidget {
  const ItemListPendent({super.key, required this.item, required this.moveCallback});
  final Produto item;
  final Function(Produto) moveCallback;

  @override
  Widget build(BuildContext context) {
    var precoController = MoneyMaskedTextController(
      decimalSeparator: ',',
      thousandSeparator: '.',
      leftSymbol: 'R\$ ',
    );

    precoController.updateValue(item.precoAtual);
    return GestureDetector(
      onTap: () async {
        Produto temp =
            await confirmEditItemScreen(context: context, itemTemp: item);
        item.precoAtual = temp.precoAtual;
        moveCallback(item);
            },
      onLongPress: () {
        showPriceHistoryModal(context: context, item: item);
      },
      child: Container(
        margin: MyTheme.myCustomEdgeInsetsSpaceExtern,
        color: Categorias.obterCorPorDescricao(item.categoria),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color.fromARGB(0, 255, 255, 255),
              ],
              begin: Alignment.centerLeft, // Início do gradiente
              end: Alignment.center, // Fim do gradiente
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      MyTheme.myCustomEdgeInsetsItemSpaceInternCategoryProduct,
                  color:
                      Categorias.obterCorSecundariaPorDescricao(item.categoria),
                  child: Center(
                    child: Text(Categorias.abreviarCategoria(item.categoria),
                        style: MyTheme.myTextStyleCategoryProduct),
                  ),
                ),
              ),
              Container(
                color: Colors.amber,
                child: Padding(
                  padding: MyTheme.myCustomEdgeInsetsItemSpaceIntern,
                  child: Text(
                    FortmatValue.formatDouble(item.quantidade),
                    style: MyTheme.myTextStyleDescriptionItem,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: MyTheme.myCustomEdgeInsetsItemSpaceIntern,
                  child: Text(
                    item.descricao,
                    style: MyTheme.myTextStyleDescriptionItem,
                  ),
                ),
              ),
              Padding(
                padding: MyTheme.myCustomEdgeInsetsItemPrice,
                child: Column(
                  children: [
                    Text(
                      "R\$ ${item.historicoPreco[item.historicoPreco.length - 1].toString()}",
                      style: precoController.text ==
                              FortmatValue.formatDouble(item.historicoPreco[
                                      item.historicoPreco.length - 1])
                                  .toString()
                          ? const TextStyle(color: Colors.grey)
                          : MyTheme.myTextStylPricePrevious,
                    ),
                    Text(
                      precoController.text == 'R\$ 0,00'
                          ? 'R\$ --,--'
                          : precoController.text,
                      style: precoController.text == 'R\$ 0,00'
                          ? MyTheme.myTextStylePriceNotDefined
                          : MyTheme.myTextStylePrice,
                    ),
                  ],
                ),
              ),
              /*
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.query_stats_outlined,
                  color: Colors.grey,
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
