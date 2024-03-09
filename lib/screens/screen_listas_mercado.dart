import 'package:flutter/material.dart';
import 'package:lista_mercado/components/decoration_list_bar.dart';
import 'package:lista_mercado/components/items/item_list_compra.dart';
import 'package:lista_mercado/components/items/item_list_compra_nao_finalizada.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/components/modals/modal_screen_lista_nao_finalizada.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/components/modals/modal_screen_exclui_lista.dart';
import 'package:lista_mercado/components/modals/modal_screen_reabrir_lista.dart';
import 'package:lista_mercado/screens/screen_active_list.dart';

class ScreenListasMercado extends StatefulWidget {
  const ScreenListasMercado({Key? key}) : super(key: key);

  @override
  State<ScreenListasMercado> createState() => _listasMercadoState();
}

class _listasMercadoState extends State<ScreenListasMercado> {
  List<ListaMercado> listasMercado = [];
  ListaMercado? listaNaoFinaliza;
  final MarketDB db = MarketDB();

  @override
  void initState() {
    super.initState();
    _initializeDB();
    db.getUnfinishedLists();
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
          GestureDetector(
            child: const Icon(
              Icons.bar_chart_outlined,
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
            padding: const EdgeInsets.all(10.0),
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
    await db.initDB();
    await db.openDB();
    listasMercado = await db.getAllListasMercado();
    setState(() {
      //itemMarketDB;
    });

    // Após inicializar o banco de dados, chama a função
    _verificarListaNaoFinalizada();
  }

  Future<void> _verificarListaNaoFinalizada() async {
    for (var i = 0; i < listasMercado.length; i++) {
      if (!listasMercado[i].finalizada) {
        listaNaoFinaliza = listasMercado[i];
        listasMercado.removeAt(i);
      }
    }

    if (listaNaoFinaliza != null) {
      bool? resultado = await abrirListaNaoFinalizada(context);

      if (resultado != null) {
        if (resultado) {
          // O usuário escolheu excluir
          db.deleteListaMercado(listaNaoFinaliza!);
        } else {
          abrirListaMercadoNaoFinalizada(context, listaNaoFinaliza!);
        }
      }
    }
  }

  void criarNovaListaMercado(BuildContext context) async {
    int idNovaLista = await db.salvarListaMercadoVazia(0);

    ListaMercado novaListaMercado = ListaMercado(
      id: idNovaLista,
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
    ListaMercado? tempLista = await db.searchListaMercadoById(temp);

    if (reabrirLista!) {
      if (tempLista != null) {
        for (var element in tempLista.itens) {
          element.pendente = true;
          element.precoAtual = 0;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenActiveList(tempLista),
          ),
        );
      } else {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenActiveList(tempLista!),
        ),
      );
    }
  }

  void abrirListaMercadoNaoFinalizada(
      BuildContext context, ListaMercado listaNaoFinaliza) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenActiveList(listaNaoFinaliza),
      ),
    );
  }

  void excluirLista(ListaMercado lista) {
    setState(() {
      listasMercado.remove(lista);
    });
    db.deleteListaMercado(lista);
    // Adicione aqui a lógica para excluir permanentemente do banco de dados
  }
}
