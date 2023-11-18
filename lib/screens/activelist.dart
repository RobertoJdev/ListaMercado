import 'package:flutter/material.dart';
import 'package:lista_mercado/components/populator_itens.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/screens/confirm_item_screen.dart';
import 'package:lista_mercado/components/decoration_list_bar.dart';
import 'package:lista_mercado/components/item_list_confirmed.dart';
import 'package:lista_mercado/components/item_list_pendent.dart';
import 'package:lista_mercado/screens/newItemScreen.dart';
import 'package:lista_mercado/models/produto.dart';

class ActiveList extends StatefulWidget {
  ActiveList(this.listaMercado, {super.key});
  ListaMercado listaMercado;

  @override
  State<ActiveList> createState() => _ActiveListState();
}

class _ActiveListState extends State<ActiveList> {
  TextEditingController _textEditingController = TextEditingController();
  PopuladorItens _populator = PopuladorItens();

  List<Produto> listItensPendent = [];
  List<Produto> listItensConfirmed = [];
  final ItemMarketDB itemMarketDB = ItemMarketDB();

  @override
  void initState() {
    super.initState();
    _populateItems();
    itemMarketDB.initDB();
    _populateDB(listItensPendent);
    itemMarketDB.printAllItems();
  }

  ListaMercado lmercadot = ListaMercado.getListaMercadoExemplo(
      [Produto.getProdutoExemplo(), Produto.getProdutoExemplo()]);

  @override
  Widget build(BuildContext context) {
    //initializeDatabase();
    String totalValue;
    totalValue = somarList(listItensConfirmed).toStringAsFixed(2);

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
                        return GestureDetector(
                          // Adicionando onTap para mover o item para a lista de confirmados
                          onTap: () {
                            moveItemToConfirmedList(listItensPendent[index]);
                          },
                          child: ItemListPendent(
                            item: listItensPendent[index],
                            moveCallback: moveItemToConfirmedList,
                          ),
                        );
                      },
                    ),
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FloatingActionButton(
                              onPressed: () async {
                                Produto? temp;
                                temp = await newItemScreen(context);
                                setState(() {
                                  if (temp != null) {
                                    print(
                                        'retorno do novo objeto ${temp.descricao}');
                                    listItensPendent.add(temp);

                                    temp.barras = 12345678.toString();
                                    temp.precoAtual = 5.0;
                                    temp.historicoPreco = [4, 5, 5, 5];

                                    ListaMercado lmt =
                                        ListaMercado.getListaMercadoExemplo([
                                      temp,
                                      Produto.getProdutoExemplo()
                                    ]);

                                    itemMarketDB.insertItem(lmt, temp);
                                    itemMarketDB.printAllItems();
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
              child: Column(
                children: [
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
                  Flexible(
                    child: Text(
                      'Valor total das compras R\$: $totalValue',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ]))
        ]));
  }

  void _populateItems() {
    listItensPendent = _populator.popularListaProdutos();
  }

  void _populateDB(List<Produto> produtos) {
    for (var element in produtos) {
      var insertItem = itemMarketDB.insertItem(lmercadot, element);
    }
  }

  void moveItemToConfirmedList(Produto item) {
    //itemMarketDB.insertItem(item);
    itemMarketDB.printAllItems();
    itemMarketDB.initDB();
    setState(() {
      print(item.getId().toString());
      listItensPendent.remove(item); // Remove o item da lista de pendentes
      listItensConfirmed.add(item);
      // Adiciona o item na lista de confirmados
    });
  }

  double somarList(List<Produto> list) {
    double totalList = 0;
    for (var item in list) {
      totalList += item.precoAtual;
    }
    return totalList;
  }
}
