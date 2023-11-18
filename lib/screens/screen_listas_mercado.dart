import 'package:flutter/material.dart';
import 'package:lista_mercado/components/decoration_list_bar.dart';
import 'package:lista_mercado/components/list_mercado.dart';
import 'package:lista_mercado/components/populator_itens.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/data_util.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/screens/activelist.dart';

class ScreenListasMercado extends StatefulWidget {
  const ScreenListasMercado({Key? key}) : super(key: key);

  @override
  State<ScreenListasMercado> createState() => _listasMercadoState();
}

class _listasMercadoState extends State<ScreenListasMercado> {
  List<ListaMercado> listasMercado = PopuladorItens.popularListaMercado();
  late final Function(Produto) moveCallback;

  List<Produto> listItensPendent = [];
  List<Produto> listItensConfirmed = [];
  final ItemMarketDB itemMarketDB = ItemMarketDB();

  bool hasUnfinishedLists = false;

  @override
  void initState() {
    super.initState();
    _initializeDB();
  }

  Future<void> _initializeDB() async {
    await itemMarketDB.initDB();
    _populateDB(listItensPendent);
    itemMarketDB.printAllItems();
    hasUnfinishedLists = await itemMarketDB.getUnfinishedLists();

    if (!hasUnfinishedLists) {
      _navigateToNextScreen();
    }
  }

  ListaMercado lmercadot = ListaMercado.getListaMercadoExemplo(
    [Produto.getProdutoExemplo(), Produto.getProdutoExemplo()],
  );

  void _navigateToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActiveList(lmercadot)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hasUnfinishedLists) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Lista de Mercado',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          actions: [
            const Icon(Icons.bar_chart_outlined),
            GestureDetector(
              child: const Icon(Icons.share),
              onTap: () {
                //PopUpItemConfirm.showAlertDialog(context);
              },
            ),
            const Padding(padding: EdgeInsets.only(right: 10))
          ],
        ),
        body: Column(
          children: [
            const DecorationListBar(),
            Expanded(
              child: PageView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const Text('Listas de compras'),
                        Flexible(
                          child: Stack(
                            children: [
                              ListView.builder(
                                itemCount: listasMercado.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: ItemListMercado(
                                      listaMercado: listasMercado[index],
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
                                      ListaMercado novaListaMercado =
                                          ListaMercado(
                                        userId: 0,
                                        custoTotal: 0,
                                        data:
                                            DataUtil.getCurrentFormattedDate(),
                                        supermercado: '',
                                        finalizada: false,
                                        itens: [],
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ActiveList(novaListaMercado),
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      //_navigateToNextScreen(); // Adicionando parênteses aqui
      return ActiveList(
          lmercadot); // ou qualquer outro widget desejado, dependendo do seu caso
    }
  }

  void _populateDB(List<Produto> produtos) {
    for (var element in produtos) {
      var insertItem = itemMarketDB.insertItem(lmercadot, element);
    }
  }
}
