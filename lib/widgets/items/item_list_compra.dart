import 'package:flutter/material.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/my_theme.dart';

class ItemListCompras extends StatelessWidget {
  const ItemListCompras({
    super.key,
    required this.listaMercado,
    // required this.moveCallback,
  });

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
      color: listaMercado.isShared ? Colors.yellow[200] : Colors.grey[200],
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
            /*  Padding(
                padding: MyTheme.myCustomEdgeInsetsItemSpaceInternRight2,
                child: Icon(Icons.share)), */
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
      ),
    );
  }
}
