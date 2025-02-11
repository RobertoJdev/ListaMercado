import 'package:flutter/material.dart';
import 'package:lista_mercado/firebase/enviar_lista_firestore.dart';
import 'package:lista_mercado/widgets/items/item_list_pendent.dart';
import 'package:lista_mercado/widgets/items/item_list_confirmed.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/widgets/modals/confirm_mercado_screen.dart';
import 'package:lista_mercado/widgets/modals/confirm_delete_item_list_screen.dart';
import 'package:lista_mercado/widgets/modals/confirm_share_email_screen.dart';
import 'package:lista_mercado/widgets/modals/new_item_screen.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/widgets/custom_app_bar.dart.dart';
import 'package:uuid/uuid.dart';

class ScreenActiveList extends StatefulWidget {
  ScreenActiveList(this.listaMercado, {Key? key}) : super(key: key ?? activeListKey);

  //ScreenActiveList(this.listaMercado, {Key? key}) : super(key: key);
  final ListaMercado listaMercado;

  @override
  State<ScreenActiveList> createState() => _ActiveListState();
}

final GlobalKey<_ActiveListState> activeListKey = GlobalKey<_ActiveListState>();

class _ActiveListState extends State<ScreenActiveList> with TickerProviderStateMixin {
  late final TextEditingController _textEditingController = TextEditingController();

  List<Produto> listItensPendent = [];
  List<Produto> listItensConfirmed = [];
  List<Produto> filteredListPendent = [];
  List<Produto> filteredListConfirmed = [];

  final MarketDB db = MarketDB();
  //late bool listaAberta;

  late String totalValue;
  bool isContainerPressed = false;
  late AnimationController _animationController;
  late bool isListPendentExpanded;
  late bool isListConfirmedExpanded;

  @override
  void initState() {
    super.initState();
    db.initDB();
    abrirListaMercado(widget.listaMercado);

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    _filterItems(""); // Inicializa com todos os itens visíveis

    if (listItensPendent.isEmpty) {
      isListConfirmedExpanded = listItensPendent.isEmpty;
      isListPendentExpanded = false;
    } else {
      isListConfirmedExpanded = listItensPendent.isEmpty;
      isListPendentExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    totalValue = somarList(listItensConfirmed).toStringAsFixed(2);

    return Scaffold(
      //key: activeListKey,
      appBar: CustomAppBar(        
        title: 'Itens da Lista',
        screenReturn: true,
        showShareButton: true,
        onSharePressed: compartilharLista,
        onSave: salvarListaTemp,
        onSearchChanged: _filterItems,
      ),

      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) async {
          //print('onPopInvokedWithResult chamado'); // Confirmação do evento
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 60,
              ),
              child: Column(
                children: [
                  ExpansionPanelList(
                    //dividerColor: Colors.amber,
                    materialGapSize: 0,
                    //elevation: 1,
                    expandedHeaderPadding: const EdgeInsets.all(0),
                    animationDuration: const Duration(milliseconds: 100),
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        if (panelIndex == 0) {
                          isListPendentExpanded = isExpanded;
                          isListConfirmedExpanded = !isExpanded;
                        } else {
                          isListPendentExpanded = !isExpanded;
                          isListConfirmedExpanded = isExpanded;
                        }
                      });
                    },
                    children: [
                      ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: isListPendentExpanded,
                        headerBuilder: (context, isExpanded) {
                          return const ListTile(
                            leading: Icon(Icons.checklist, color: Color.fromARGB(255, 202, 13, 0)),
                            title: Text(
                              'Itens que faltam',
                              style: TextStyle(color: Color.fromARGB(255, 202, 13, 0)),
                            ),
                          );
                        },
                        body: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          itemCount: filteredListPendent.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: UniqueKey(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  return true; // ou implemente uma confirmação específica se necessário
                                } else if (direction == DismissDirection.endToStart) {
                                  bool? confirm = await confirmDeleteItemList(context);
                                  setState(() {
                                    if (confirm!) {
                                      excluirItem(widget.listaMercado, filteredListPendent[index]);
                                    }
                                  });
                                  return false;
                                }
                                return false;
                              },
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  filteredListPendent[index].pendente = false;
                                  moveItemToConfirmedList(filteredListPendent[index]);
                                } else if (direction == DismissDirection.endToStart) {}
                              },
                              // demais propriedades do Dismissible
                              background: Container(
                                color: Colors.green,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 10),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: ItemListPendent(
                                item: filteredListPendent[index],
                                moveCallback: moveItemToConfirmedList,
                              ),
                            );
                          },
                        ),
                      ),
                      ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: isListConfirmedExpanded,
                        headerBuilder: (context, isExpanded) {
                          return const ListTile(
                            leading: Icon(
                              Icons.playlist_add_check,
                              color: Color.fromARGB(255, 0, 141, 5),
                            ),
                            title: Text(
                              'Itens adicionados ao carrinho',
                              style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 141, 5)),
                            ),
                          );
                        },
                        body: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          itemCount: filteredListConfirmed.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.horizontal,
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  filteredListConfirmed[index].pendente = true;
                                  moveItemToPendentList(filteredListConfirmed[index]);
                                } else if (direction == DismissDirection.endToStart) {
                                  bool? confirm = await confirmDeleteItemList(context);
                                  setState(() {
                                    if (confirm!) {
                                      excluirItem(widget.listaMercado, filteredListConfirmed[index]);
                                    }
                                  });
                                }
                              },
                              background: Container(
                                color: Colors.blueAccent,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: const Icon(
                                  Icons.unarchive_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 10),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: ItemListConfirmed(
                                item: filteredListConfirmed[index],
                                moveCallback: moveItemToPendentList,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ///////////////////////////////////////////////////// verificar mudança de inclusão dentro de proprio widget
            //////////////////////////////////////////////////////////////////////////////////
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                      begin: Alignment.topCenter,
                      end: Alignment.center),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: finalizarListaCompras,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Text(
                              'Finalizar: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Text(
                              'R\$ $totalValue',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: adicionarNovoItem,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Text(
                              'Adicionar Item',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveItemToConfirmedList(Produto item) {
    //db.printAllItems();
    setState(() {
      if (!item.pendente) {
        filteredListPendent.remove(item);
        filteredListConfirmed.add(item);

        listItensPendent.remove(item);
        listItensConfirmed.add(item);
      }
    });
    // Verifique se a lista de itens pendentes está vazia após a movimentação
    if (listItensPendent.isEmpty) {
      setState(() {
        // Expandir a lista confirmada automaticamente
        isListPendentExpanded = false;
        isListConfirmedExpanded = true;
      });
    }
  }

  void moveItemToPendentList(Produto item) {
    setState(() {
      if (item.precoAtual == 0.0 || item.pendente == true) {
        item.precoAtual = 0.0;
        item.pendente = true;
        filteredListConfirmed.remove(item);
        filteredListPendent.add(item);
        listItensConfirmed.remove(item);
        listItensPendent.add(item);
      }
    });
    if (listItensConfirmed.isEmpty) {
      setState(() {
        // Expandir a lista pendente automaticamente
        isListPendentExpanded = true;
        isListConfirmedExpanded = false;
      });
    }
  }

  void excluirItem(ListaMercado listaMercado, Produto item) {
    setState(() {
      if (item.pendente) {
        listItensPendent.remove(item);
        filteredListPendent.remove(item);
      } else {
        listItensConfirmed.remove(item);
        filteredListConfirmed.remove(item);
      }
    });
    db.apagarProdutoDaLista(listaMercado, item);
  }

  double somarList(List<Produto> produtos) {
    double totalList = 0;
    for (var item in produtos) {
      totalList += item.quantidade * item.precoAtual;
    }
    return totalList;
  }

  void finalizarListaCompras() async {
    String? nomeMercado = await confirmMercadoScreen(context: context);

    bool listaAberta = widget.listaMercado.finalizada;

    if (nomeMercado != null) {
      widget.listaMercado.custoTotal = double.parse(totalValue);
      widget.listaMercado.itens = listItensPendent + listItensConfirmed;
      widget.listaMercado.supermercado = nomeMercado;
      widget.listaMercado.finalizada = true;
      widget.listaMercado.data = DataUtil.getCurrentFormattedDate();
      widget.listaMercado.uniqueKey = Uuid().v4().substring(0, 8);

      await db.salvarListaMercado(widget.listaMercado, true);
      await db.apagarListaMercadoNaoFinalizada();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        (route) => false,
      );

/*       if (!listaAberta) {
        db.atualizarListaMercado(widget.listaMercado);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
          (route) => false,
        );
      } */
    }
  }

  void abrirListaMercado(ListaMercado lista) {
    //List<Produto> listaProdutos = lista.itens;
    lista.itens = Produto.ordenarItens(lista.itens);
    for (Produto element in lista.itens) {
      if (element.historicoPreco.isEmpty) {
        element.historicoPreco.add(0);
      }

      if (element.pendente) {
        listItensPendent.add(element);
      } else {
        listItensConfirmed.add(element);
      }
    }
  }

  Future adicionarNovoItem() async {
    Produto? temp;
    temp = await newItemScreen(context);
    if (temp != null && temp.precoAtual == 0.0) {
      db.inserirItem(widget.listaMercado, temp);
      listItensPendent.add(temp);
      filteredListPendent.add(temp);
      setState(() {
        listItensPendent = Produto.ordenarItens(listItensPendent);
      });
    } else if (temp?.precoAtual != 0.0) {
      db.inserirItem(widget.listaMercado, temp!);
      listItensConfirmed.add(temp);
      filteredListConfirmed.add(temp);
      setState(() {
        listItensConfirmed = Produto.ordenarItens(listItensConfirmed);
      });
    }
  }

  void salvarListaTemp(bool salvar) async {
    if (salvar) {
      String? nomeMercado = 'Lista salva automática.';

      //listaAberta = widget.listaMercado.finalizada;

      //widget.listaMercado.userId = getUserId().toString();
      //widget.listaMercado.finalizada = true;
      widget.listaMercado.custoTotal = double.parse(totalValue);
      widget.listaMercado.data = DataUtil.getCurrentFormattedDate();
      widget.listaMercado.supermercado = nomeMercado;
      widget.listaMercado.uniqueKey = const Uuid().v4().substring(0, 8);
      widget.listaMercado.itens = listItensPendent + listItensConfirmed;

      await db.salvarListaMercado(widget.listaMercado, true);
      await db.apagarListaMercadoNaoFinalizada();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        (route) => false,
      );
    } else {
      await db.apagarListaMercadoNaoFinalizada();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        (route) => false,
      );
    }
  }

  void compartilharLista() async {
    String? shareEmail = await _abrirModalCompartilharEmail(context);
    if (shareEmail!.isNotEmpty) {
      widget.listaMercado.sharedWithEmail = shareEmail;
      widget.listaMercado.isShared = true;
      try {
        // Chama a função para enviar os dados ao Firestore
        await enviarListaParaFirestore(widget.listaMercado);
        print("Lista enviada com sucesso!");
      } catch (e) {
        print("Erro ao compartilhar lista: $e");
      }
    }
  }

  Future<String> _abrirModalCompartilharEmail(BuildContext context) async {
    final email = await confirmShareEmailScreen(context: context);
    if (email != null) {
      return email;
    }
    return '';
  }

  ///Retorna uma lista filtrada pela query passada como parâmetro.
  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        // Se a pesquisa estiver vazia, mostra todos os itens
        filteredListPendent = [...listItensPendent]; // Mantém a lista de itens pendentes sem filtro
        filteredListConfirmed = [...listItensConfirmed]; // Mantém a lista de itens confirmados sem filtro
      } else {
        // Filtra os itens pendentes com base na pesquisa
        filteredListPendent =
            listItensPendent.where((item) => item.descricao.toLowerCase().contains(query.toLowerCase())).toList();

        // Filtra os itens confirmados com base na pesquisa
        filteredListConfirmed =
            listItensConfirmed.where((item) => item.descricao.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
}
