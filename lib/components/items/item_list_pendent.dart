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

// é preciso mapear os dados para o item que retona o modal.

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
        margin: const EdgeInsets.only(top: 2, bottom: 2),
        color: Categorias.obterCorPorDescricao(item.categoria),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                color:
                    Categorias.obterCorSecundariaPorDescricao(item.categoria),
                child: Center(
                  // Alinhe o texto ao centro
                  child: Text(
                    Categoria.abreviarCategoria(item.categoria),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
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
                    ? 'R\$ --,--'
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
