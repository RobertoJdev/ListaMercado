import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/models/categorias.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/util/format_value.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_confirm_item.dart';

class ItemListConfirmed extends StatelessWidget {
  ItemListConfirmed(
      {super.key, required this.item, required this.moveCallback});
  Produto item;
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
      child: Container(
        margin: MyTheme.myCustomEdgeInsetsSpaceExtern,
        color: Colors.green[50],
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
                  child: Text(
                    Categorias.abreviarCategoria(item.categoria),
                    style: MyTheme.myTextStyleCategoryProduct,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.green,
              child: Padding(
                padding: MyTheme.myCustomEdgeInsetsItemSpaceIntern,
                child: Text(
                  FortmatValue.formatDouble(item.quantidade),
                  style: MyTheme.myTextStyleQuantItem,
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
              padding: MyTheme.myCustomEdgeInsetsItemSpaceInternRight,
              child: Text(precoController.text),
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
    );
  }
}
