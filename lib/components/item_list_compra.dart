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
    return Column(children: [
      Container(
          color: Colors.grey[200],
          child: Row(children: [
            Container(
                color: Colors.deepPurple[100],
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Text(
                            DataUtil.returnDataFormatted(listaMercado.data),
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              //fontSize: 18,
                            ))))),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      listaMercado.supermercado,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'R\$ ${listaMercado.custoTotal.toString()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Icon(Icons.query_stats_outlined),
            ),
          ])),
      const SizedBox(
        height: 5,
      ),
    ]);
  }
}
