import 'package:flutter/material.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

class ItemListMercado extends StatelessWidget {
  ItemListMercado({
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
                color: Colors.amber,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Container(
                            child: Text(listaMercado.data,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )))))),
            const SizedBox(
              width: 10,
            ),
            Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: Container(
                    child: Text(listaMercado.supermercado,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )))),
            const Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Icon(Icons.query_stats_outlined),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                  child: const Icon(Icons.check_box_outline_blank),
                  onTap: () async {}),
            ),
          ])),
      const SizedBox(
        height: 5,
      ),
    ]);
  }
}
