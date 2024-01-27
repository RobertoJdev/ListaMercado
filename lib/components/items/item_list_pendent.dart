import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:lista_mercado/components/modals/modal_screen_confirm_item.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/components/items/item_list_confirmed.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/util/formatValue.dart';

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
        double? confirmedPrice = await confirmItemScreen(context: context);
        if (confirmedPrice != null) {
          item.precoAtual = confirmedPrice;
          moveCallback(item);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        color: Categorias.obterCorPorDescricao(item.categoria),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  FortmatValue.formatDouble(item.quantidade),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  item.descricao,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10),
              child: Text(
                precoController.text == 'R\$ 0,00'
                    ? 'R\$ ---,---'
                    : precoController.text,
                style: precoController.text == 'R\$ 0,00'
                    ? const TextStyle(color: Colors.grey)
                    : const TextStyle(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.query_stats_outlined,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
