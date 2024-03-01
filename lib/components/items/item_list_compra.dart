import 'package:flutter/material.dart';
import 'package:lista_mercado/components/modals/modal_screen_compartilhar_lista.dart';
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
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
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
            formatCurrency(listaMercado.custoTotal),
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          GestureDetector(
            onTap: () {
              compartilharLista(context: context, lista: listaMercado);
              print('teste de compartilhamento');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Icon(
                Icons.share,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
