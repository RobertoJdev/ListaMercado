import 'package:flutter/material.dart';
import 'package:lista_mercado/models/produto.dart';

class ItemListConfirmed extends StatelessWidget {
  ItemListConfirmed({super.key, required this.item});
  Produto item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      color: Colors.green[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                item.quantidade.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  //fontSize: 18,
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
            child: Text('R\$: ${item.precoAtual.toString()}'),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.query_stats_outlined),
          ),
        ],
      ),
    );
  }
}
