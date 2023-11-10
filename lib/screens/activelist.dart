import 'package:flutter/material.dart';
import 'package:lista_mercado/components/market_populator_list.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/screens/confirm_item_screen.dart';
import 'package:lista_mercado/components/decoration_list_bar.dart';
import 'package:lista_mercado/components/item_list_confirmed.dart';
import 'package:lista_mercado/components/item_list_pendent.dart';
import 'package:lista_mercado/screens/newItemScreen.dart';
import 'package:lista_mercado/models/item_market.dart';

class ActiveList extends StatefulWidget {
  const ActiveList({super.key});

  @override
  State<ActiveList> createState() => _ActiveListState();
}

class _ActiveListState extends State<ActiveList> {
  TextEditingController _textEditingController = TextEditingController();

  List<ItemMarket> listItensPendent = [];
  List<ItemMarket> listItensConfirmed = [];
  MarketPopulatorList listPopulate = MarketPopulatorList();

  @override
  Widget build(BuildContext context) {
    //initializeDatabase();
    String totalValue;
    listItensPendent = listPopulate.populateList();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Lista de Mercado',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          actions: [
            Icon(Icons.bar_chart_outlined),
            GestureDetector(
              child: Icon(Icons.share),
              onTap: () {
                //PopUpItemConfirm.showAlertDialog(context);
              },
            ),
            Padding(padding: EdgeInsets.only(right: 10))
          ],
        ),
        body: Column(children: [
          const DecorationListBar(),
          Expanded(
              child: PageView(children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  const Text('Itens que faltam'),
                  Flexible(
                      child: Stack(children: [
                    ListView.builder(
                        itemCount: listItensPendent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemListPendent(
                            item: listItensPendent[index],
                          );
                        }),
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FloatingActionButton(
                              onPressed: () async {
                                ItemMarket? temp;
                                temp = await newItemScreen(context);
                                setState(() {
                                  if (temp != null) {
                                    print(
                                        'retorno do novo objeto ${temp.name}');
                                    listItensPendent.add(temp);
                                    print(listItensPendent[0].name);
                                  }
                                });
                              },
                              child: const Icon(Icons.add),
                            )))
                  ]))
                ])),
            //Container(),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  const Text('Itens adicionados ao carrinho'),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 20,
                    child: ListView.builder(
                      itemCount: listItensConfirmed.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ItemListConfirmed(
                            item: listItensConfirmed[index]);
                      },
                    ),
                  ),
                  const Flexible(
                      child: Text(
                    'Valor total das compras R\$: {totalValue}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
                ]))
          ]))
        ]));
  }

  Future<void> confirmItem(List confirm, List pendent, int index) async {
    //double? priceTemp = await showItemConfirm();
  }

  Future<void> initializeDatabase() async {
    MarketDatabase database = MarketDatabase();
    await database.open();
    MarketPopulatorList databasePopulator = MarketPopulatorList();
    //await databasePopulator.populateDatabaseWithExampleData();
    print('Itens inseridos:');
    await database.printAllItems();
  }
}
