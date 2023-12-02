import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/screen_confirm_item.dart';
import 'package:lista_mercado/components/item_list_confirmed.dart';
import 'package:lista_mercado/models/produto.dart';

class ItemListPendent extends StatelessWidget {
  ItemListPendent({super.key, required this.item, required this.moveCallback});
  final Produto item;
  final Function(Produto) moveCallback;

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
                            child: Text(item.quantidade.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                )))))),
            const SizedBox(
              width: 10,
            ),
            Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: Container(
                    child: Text(item.descricao,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
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
                  onTap: () async {
                    double? confirmedPrice =
                        await confirmItemScreen(context: context);
                    if (confirmedPrice != null) {
                      item.precoAtual = confirmedPrice;
                      //print('Preço confirmado: $confirmedPrice');
                      //print('chamada de função confirmar item');
                      moveCallback(item);
                      //print(item.getId());
                    } else {
                      //print('Operação cancelada');
                    }
                  }),
            ),
          ])),
      const SizedBox(
        height: 5,
      ),
    ]);
  }
}
