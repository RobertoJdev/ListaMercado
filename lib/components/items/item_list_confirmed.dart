import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/util/format_value.dart';

class ItemListConfirmed extends StatelessWidget {
  ItemListConfirmed({super.key, required this.item});
  Produto item;

  @override
  Widget build(BuildContext context) {
    var precoController = MoneyMaskedTextController(
      decimalSeparator: ',',
      thousandSeparator: '.',
      leftSymbol: 'R\$ ',
    );

    precoController.updateValue(item.precoAtual);

    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      color: Colors.green[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              color: Categorias.obterCorSecundariaPorDescricao(item.categoria),
              child: Center(
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
            color: Colors.green,
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
            child: Text(precoController.text),
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
    );
  }
}
