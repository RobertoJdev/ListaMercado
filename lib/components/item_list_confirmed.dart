import 'package:flutter/material.dart';
import 'package:lista_mercado/models/produto.dart';

class ItemListConfirmed extends StatelessWidget {
  ItemListConfirmed({super.key, required this.item});
  Produto item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            color: Colors.green[50],
            child: Row(children: [
              Container(
                  color: Colors.green,
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
                                ))),
                      ))),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                  fit: FlexFit.tight,
                  flex: 6,
                  child: Container(
                      child: Text(
                    item.descricao,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ))),
              Flexible(
                fit: FlexFit.tight,
                flex: 4,
                child: Container(
                    child: Text('Preço R\$: ${item.precoAtual.toString()}')),
              ),
              const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Icon(Icons.query_stats_outlined),
                  ))
            ])),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
