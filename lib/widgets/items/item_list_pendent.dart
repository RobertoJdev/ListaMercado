import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_confirm_item.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/widgets/items/item_list_confirmed.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/util/format_value.dart';

class ItemListPendent extends StatelessWidget {
  ItemListPendent({super.key, required this.item, required this.moveCallback});
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
        if (temp.precoAtual != null) {
          item.precoAtual = temp.precoAtual;
          moveCallback(item);
        }
      },
      child: Container(
        margin: MyTheme.myCustomEdgeInsetsSpaceExtern,
        color: Categorias.obterCorPorDescricao(item.categoria),
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
                  // Alinhe o texto ao centro
                  child: Text(Categoria.abreviarCategoria(item.categoria),
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
              padding: MyTheme.myCustomEdgeInsetsItemSpaceInternRight,
              child: Text(
                precoController.text == 'R\$ 0,00'
                    ? 'R\$ --,--'
                    : precoController.text,
                style: precoController.text == 'R\$ 0,00'
                    ? const TextStyle(color: Colors.grey)
                    : MyTheme.myTextStylePrice,
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
    );
  }
}
