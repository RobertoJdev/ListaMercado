import 'package:flutter/material.dart';
import 'package:lista_mercado/models/lista_mercado.dart';

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
      margin: EdgeInsets.only(bottom: 5),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.deepPurple[100],
            child: Text(
              listaMercado.data,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12),
              child: Text(
                listaMercado.supermercado,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              formatCurrency(listaMercado.custoTotal),
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
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
