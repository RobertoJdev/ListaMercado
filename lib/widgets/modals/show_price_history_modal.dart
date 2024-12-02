import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/my_theme.dart';

Future<void> showPriceHistoryModal({
  required BuildContext context,
  required Produto item,
}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Obter o preço atual
          double? precoAtual = item.precoAtual; // Supondo que você tenha uma propriedade precoAtual em Produto

          return SingleChildScrollView(
            child: Container(
              color: MyTheme.modalColorBackground,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: MyTheme.myCustomEdgeInsetsTitleModal,
                    child: Text(
                      'Histórico de Preços',
                      style: MyTheme.myTextStyleTitleModal,
                    ),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsTextFildItensModal,
                    child: Container(
                      height: 300, // Definindo a altura do gráfico
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(show: true),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                // Adiciona pontos históricos
                                ...item.historicoPreco.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  double preco = entry.value;
                                  return FlSpot(index.toDouble(), preco);
                                }).toList(),
                                // Adiciona o preço atual
                                if (precoAtual != null && precoAtual > 0)
                                  FlSpot(item.historicoPreco.length.toDouble(), precoAtual)
                              ],
                              isCurved: true,
                              color: Colors.blue, // Cor da linha
                              dotData: FlDotData(show: true),
                            ),
                          ],
                          minY: 0,
                          lineTouchData: LineTouchData(enabled: true),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: MyTheme.myCustomEdgeInsetsButtomModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.deepPurple),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Fechar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
