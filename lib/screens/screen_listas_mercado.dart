import 'package:flutter/material.dart';
import 'package:lista_mercado/components/decoration_list_bar.dart';
import 'package:lista_mercado/components/item_list_compra.dart';
import 'package:lista_mercado/components/populator.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/data_util.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/screens/screen_active_list.dart';

class ScreenListasMercado extends StatefulWidget {
  const ScreenListasMercado({Key? key}) : super(key: key);

  @override
  State<ScreenListasMercado> createState() => _listasMercadoState();
}

class _listasMercadoState extends State<ScreenListasMercado> {
  //late final Function(Produto) moveCallback;
  List<ListaMercado> listasMercado = [];
  List<Produto> listItensPendent = [];
  List<Produto> listItensConfirmed = [];
  final MarketDB itemMarketDB = MarketDB();

  @override
  void initState() {
    super.initState();
    _initializeDB();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Column(children: [
          const DecorationListBar(isListMercado: true),
          Expanded(
              child: PageView(children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  const Text('Listas de compras finalizadas'),
                  Flexible(
                      child: Stack(children: [
                    ListView.builder(
                      itemCount: listasMercado.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            abrirListaMercadoFinalizada(
                                context, listasMercado[index]);
                          },
                          child: ItemListCompra(
                            listaMercado: listasMercado[index],
                          ),
                        );
                      },
                    ),
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  criarNovaListaMercado(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  elevation: 5, // Ajuste conforme necessário
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // Ajuste conforme necessário
                                  ),
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text('Nova lista',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ))))))
                  ]))
                ]))
          ]))
        ]));
  }

  Future<void> _initializeDB() async {
    await itemMarketDB.initDB();
    itemMarketDB.openDB();
    listasMercado = await itemMarketDB.getAllListasMercado();
    setState(() {});
  }

  void criarNovaListaMercado(BuildContext context) async {
    ListaMercado novaListaMercado = ListaMercado(
      userId: 0,
      custoTotal: 0,
      data: DataUtil.getCurrentFormattedDate(),
      supermercado: '',
      finalizada: false,
      itens: [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenActiveList(novaListaMercado),
      ),
    );
  }

  void abrirListaMercadoFinalizada(
      BuildContext context, ListaMercado listasMercado) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenActiveList(listasMercado),
      ),
    );
  }
}
