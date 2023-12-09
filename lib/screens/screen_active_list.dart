import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:lista_mercado/components/populator.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/components/decoration_list_bar.dart';
import 'package:lista_mercado/components/item_list_confirmed.dart';
import 'package:lista_mercado/components/item_list_pendent.dart';
import 'package:lista_mercado/screens/modal_screen_confirm_mercado.dart';
import 'package:lista_mercado/screens/modal_screen_new_item.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';

class ScreenActiveList extends StatefulWidget {
  ScreenActiveList(this.listaMercado, {super.key});
  ListaMercado listaMercado;

  @override
  State<ScreenActiveList> createState() => _ActiveListState();
}

class _ActiveListState extends State<ScreenActiveList> {
  late TextEditingController _textEditingController = TextEditingController();
  //PopuladorItens _populator = PopuladorItens();
  List<Produto> listItensPendent = [];
  List<Produto> listItensConfirmed = [];
  final MarketDB itemMarketDB = MarketDB();

  late String totalValue;

  @override
  void initState() {
    super.initState();
    itemMarketDB.initDB();
    abrirListaMercado(widget.listaMercado);
  }

  ListaMercado lmercadot = ListaMercado.generateListaMercadoExemplo(
      Produto.generateMultiProdutosExemplo());

  @override
  Widget build(BuildContext context) {
    //initializeDatabase();
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
            const Icon(
              Icons.bar_chart_outlined,
              color: Colors.grey,
            ),
            GestureDetector(
              child: const Icon(
                Icons.share,
                color: Colors.grey,
              ),
              onTap: () {
                //PopUpItemConfirm.showAlertDialog(context);
              },
            ),
            const Padding(padding: EdgeInsets.only(right: 10))
          ],
        ),
        body: Column(children: [
          const DecorationListBar(),
          Expanded(
              child: PageView(children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text('Itens que faltam'),
                  ),
                  Expanded(
                      child: Stack(children: [
                    ListView.builder(
                      itemCount: listItensPendent.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
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
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton(
                              splashColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepPurple,
                              onPressed: () async {
                                Produto? temp;
                                temp = await newItemScreen(context);
                                setState(() {
                                  listItensPendent.add(temp!);
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text('Itens adicionados ao carrinho'),
                  ),
                  Expanded(
                      flex: 20,
                      child: ListView.builder(
                          itemCount: listItensConfirmed.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ItemListConfirmed(
                                item: listItensConfirmed[index]);
                          })),
                  Expanded(
                    child: Text(
                      'Valor total das compras R\$: $totalValue',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  ElevatedButton(
                    onPressed: finalizarListCompras,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        elevation: 5, // Ajuste conforme necessário
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Finalizar lista',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]))
        ]));
  }

  void moveItemToConfirmedList(Produto item) {
    itemMarketDB.printAllItems();
    setState(() {
      item.pendente = false;
      listItensPendent.remove(item);
      listItensConfirmed.add(item);
    });
  }

  double somarList(List<Produto> produtos) {
    double totalList = 0;
    for (var item in produtos) {
      totalList += item.quantidade * item.precoAtual;
    }
    return totalList;
  }

  void finalizarListCompras() async {
    String? nomeMercado = await confirmMercadoScreen(context: context);

    if (nomeMercado != null) {
      widget.listaMercado.custoTotal = double.parse(totalValue);
      widget.listaMercado.itens = listItensPendent + listItensConfirmed;
      widget.listaMercado.supermercado =
          nomeMercado; // Defina o nome do mercado
      itemMarketDB.novaListaMercado(widget.listaMercado);

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        (route) => false, // Remove todas as telas do histórico
      );
    }
  }

  void abrirListaMercado(ListaMercado lista) {
    if (lista.finalizada) {
      for (Produto element in lista.itens) {
        //print(element.descricao + '-----' + element.pendente.toString());
        if (element.pendente) {
          listItensPendent.add(element);
        } else {
          listItensConfirmed.add(element);
        }
      }
    } else {
      widget.listaMercado.itens =
          listItensPendent = Produto.generateMultiProdutosExemplo();
    }
  }
}
