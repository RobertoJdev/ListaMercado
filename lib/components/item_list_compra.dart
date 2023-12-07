import 'package:flutter/material.dart';
import 'package:lista_mercado/models/data_util.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

class ItemListCompra extends StatelessWidget {
  ItemListCompra({
    super.key,
    required this.listaMercado,
    //required this.moveCallback,
  });
  //final Function(Produto) moveCallback;
  ListaMercado listaMercado;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: Colors.deepPurple[100],
            child: Text(
              DataUtil.returnDataFormatted(listaMercado.data),
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Text(
                listaMercado.supermercado,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Text(
            'R\$ ${listaMercado.custoTotal.toString()}',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Icon(
              Icons.query_stats_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
