import 'package:flutter/material.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/my_theme.dart';

class ItemListCompras extends StatelessWidget {
  ItemListCompras({
    Key? key,
    required this.listaMercado,
    // required this.moveCallback,
  }) : super(key: key);

  // final Function(Produto) moveCallback;
  final ListaMercado listaMercado;

  String formatCurrency(double value) {
    // Substituí o ponto por vírgula e usei a função toStringAsFixed para
    // garantir que sempre tenhamos duas casas decimais.
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MyTheme.myCustomEdgeInsetsSpaceExtern,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: MyTheme.myCustomEdgeInsetsItemSpaceIntern,
            color: Colors.deepPurple[100],
            child: Text(
              listaMercado.data,
              style: MyTheme.myTextStyleDateListMarket,
            ),
          ),
          Expanded(
            child: Padding(
              padding: MyTheme.myCustomEdgeInsetsItemSpaceIntern,
              child: Text(
                listaMercado.supermercado,
                style: MyTheme.myTextStyleDescriptionItem,
              ),
            ),
          ),
          Padding(
            padding: MyTheme.myCustomEdgeInsetsItemSpaceInternRight2,
            child: Text(
              formatCurrency(listaMercado.custoTotal),
              style: MyTheme.myTextStylePrice,
            ),
          ),
          /*
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.query_stats_outlined,
              color: Colors.grey,
            ),
          ),
            */
        ],
      ),
    );
  }
}
