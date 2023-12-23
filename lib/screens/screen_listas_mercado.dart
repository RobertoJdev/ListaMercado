import 'package:flutter/material.dart';
import 'package:lista_mercado/components/decoration_list_bar.dart';
import 'package:lista_mercado/components/item_list_compra.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/screens/modal_screen_exclui_lista.dart';
import 'package:lista_mercado/screens/modal_screen_reabrir_lista.dart';
import 'package:lista_mercado/screens/screen_active_list.dart';

class ScreenListasMercado extends StatefulWidget {
  const ScreenListasMercado({Key? key}) : super(key: key);

  @override
  State<ScreenListasMercado> createState() => _listasMercadoState();
}

class _listasMercadoState extends State<ScreenListasMercado> {
  List<ListaMercado> listasMercado = [];
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
        const DecorationListBar(isListMercado: true),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    'Listas de compras finalizadas',
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listasMercado.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          excluirLista(listasMercado[index]);
                        },
                        confirmDismiss: (direction) async {
                          return await showDeleteConfirmationDialog(context);
                        },
                        child: GestureDetector(
                          onTap: () {
                            abrirListaMercadoFinalizada(
                              context,
                              listasMercado[index],
                            );
                          },
                          child: ItemListCompras(
                            listaMercado: listasMercado[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      criarNovaListaMercado(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Nova lista',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _initializeDB() async {
    await itemMarketDB.initDB();
    await itemMarketDB.openDB();
    listasMercado = await itemMarketDB.getAllListasMercado();
    setState(() {
      //itemMarketDB;
    });
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
      BuildContext context, ListaMercado listaMercado) async {
    bool? reabrirLista = await reabrirListaScreen(context: context);
    int temp = listaMercado.id!;
    ListaMercado? tempLista = await itemMarketDB.searchListaMercadoById(temp);

    if (reabrirLista!) {
      if (tempLista != null) {
        for (var element in tempLista.itens) {
          element.pendente = true;
        }

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenActiveList(tempLista),
          ),
        );
      } else {
        // Trate o caso em que a lista de mercado não foi encontrada
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: const Text('Lista de mercado não encontrada.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenActiveList(tempLista!),
        ),
      );
    }
  }

  void excluirLista(ListaMercado lista) {
    setState(() {
      listasMercado.remove(lista);
    });
    // Adicione aqui a lógica para excluir permanentemente do banco de dados
  }
}
