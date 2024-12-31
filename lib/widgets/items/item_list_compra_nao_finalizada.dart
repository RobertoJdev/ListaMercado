import 'package:flutter/material.dart';
import 'package:lista_mercado/models/lista_mercado.dart';

class ItemListComprasNaoFinalizada extends StatelessWidget {
  const ItemListComprasNaoFinalizada({
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
      margin: const EdgeInsets.only(bottom: 5),
      color: Colors.amber[100],
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                textAlign: TextAlign.center,
                listaMercado.supermercado,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
