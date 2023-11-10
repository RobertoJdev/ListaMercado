import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/confirm_item_screen.dart';
import 'package:lista_mercado/components/item_list_confirmed.dart';
import 'package:lista_mercado/models/item_market.dart';

class ItemListPendent extends StatelessWidget {
  ItemListPendent({super.key, required this.item});
  ItemMarket item;

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
                            child: Text(item.quant.toString(),
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
                    child: Text(item.name,
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
                child: Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: GestureDetector(
                        child: const Icon(Icons.check_box_outline_blank),
                        onTap: () async {
                          print('chamada de função confirmar item');
                        }))),
          ])),
      const SizedBox(
        height: 5,
      ),
    ]);
  }
}
