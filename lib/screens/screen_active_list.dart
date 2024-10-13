import 'package:flutter/material.dart';
import 'package:lista_mercado/widgets/decoration_list_bar.dart';
import 'package:lista_mercado/widgets/items/item_list_pendent.dart';
import 'package:lista_mercado/widgets/items/item_list_confirmed.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_confirm_item.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_confirm_mercado.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_exlui_item.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_new_item.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/widgets/custom_app_bar.dart.dart';
import 'package:flutter/services.dart';

class ScreenActiveList extends StatefulWidget {
  ScreenActiveList(this.listaMercado, {Key? key})
      : super(key: key ?? activeListKey);

  //ScreenActiveList(this.listaMercado, {Key? key}) : super(key: key);
  final ListaMercado listaMercado;

  @override
  State<ScreenActiveList> createState() => _ActiveListState();
}

final GlobalKey<_ActiveListState> activeListKey = GlobalKey<_ActiveListState>();

class _ActiveListState extends State<ScreenActiveList>
    with TickerProviderStateMixin {
  late TextEditingController _textEditingController = TextEditingController();
  List<Produto> listItensPendent = [];
  List<Produto> listItensConfirmed = [];
  final MarketDB db = MarketDB();
  late bool listaAberta;

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
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    //testeExibirListaItems();
    // Inicie com a lista de itens que faltam expandida
    //isListPendentExpanded = true;
    //isListConfirmedExpanded = false;
    // Se lista pendente estiver vazia, inicie a lista confirmada expandida
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
      appBar: const CustomAppBar(
        screenReturn: true,
      ),
      body: Stack(
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
                          leading: Icon(Icons.checklist),
                          title: Text('Itens que faltam'),
                        );
                      },
                      body: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        itemCount: listItensPendent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: UniqueKey(),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                return true; // ou implemente uma confirmação específica se necessário
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                bool? confirm =
                                    await showDeleteItemConfirmationDialog(
                                        context);
                                setState(() {
                                  if (confirm!) {
                                    excluirItem(widget.listaMercado,
                                        listItensPendent[index]);
                                  }
                                });
                                return false;
                              }
                              return false;
                            },
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                listItensPendent[index].pendente = false;
                                moveItemToConfirmedList(
                                    listItensPendent[index]);
                              } else if (direction ==
                                  DismissDirection.endToStart) {}
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
                              item: listItensPendent[index],
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
                          leading: Icon(Icons.playlist_add_check),
                          title: Text('Itens adicionados ao carrinho'),
                        );
                      },
                      body: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        itemCount: listItensConfirmed.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                listItensConfirmed[index].pendente = true;
                                moveItemToPendentList(
                                    listItensConfirmed[index]);
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                bool? confirm =
                                    await showDeleteItemConfirmationDialog(
                                        context);
                                setState(() {
                                  if (confirm!) {
                                    excluirItem(widget.listaMercado,
                                        listItensConfirmed[index]);
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
                              item: listItensConfirmed[index],
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
                color: isContainerPressed
                    ? Colors.deepPurple.withOpacity(0.5)
                    : Colors.deepPurple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
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
                    onTap: finalizarListCompras,
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
    );
  }

  void moveItemToConfirmedList(Produto item) {
    //db.printAllItems();
    setState(() {
      if (item.pendente == false) {
        //item.pendente = false;
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
      if (item.precoAtual == 0.0 ||
          item.precoAtual == null ||
          item.pendente == true) {
        item.precoAtual = 0.0;
        item.pendente = true;
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

  double somarList(List<Produto> produtos) {
    double totalList = 0;
    for (var item in produtos) {
      totalList += item.quantidade * item.precoAtual;
    }
    return totalList;
  }

  void finalizarListCompras() async {
    String? nomeMercado = await confirmMercadoScreen(context: context);

    listaAberta = widget.listaMercado.finalizada;

    if (nomeMercado != null) {
      widget.listaMercado.custoTotal = double.parse(totalValue);
      widget.listaMercado.itens = listItensPendent + listItensConfirmed;
      widget.listaMercado.supermercado = nomeMercado;
      widget.listaMercado.finalizada = true;
      widget.listaMercado.data = DataUtil.getCurrentFormattedDate();

      if (!listaAberta) {
        db.updateListaMercado(widget.listaMercado);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
          (route) => false,
        );
      } else {}

      db.novaListaMercado(widget.listaMercado);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        (route) => false,
      );
    }
  }

  void abrirListaMercado(ListaMercado lista) {
    //List<Produto> listaProdutos = lista.itens;
    lista.itens = Produto.ordenarItens(lista.itens);
    for (Produto element in lista.itens) {
      if (element.pendente) {
        listItensPendent.add(element);
      } else {
        listItensConfirmed.add(element);
      }
    }
  }

  void testeExibirListaItems() {
    print(
        '------------------Lista de produtos passados como parametro dentro da chamada. ------------------');
    for (var element in widget.listaMercado.itens) {
      print(element.descricao);
    }
  }

  void excluirItem(ListaMercado listaMercado, Produto produto) {
    setState(() {
      if (produto.pendente) {
        listItensPendent.remove(produto);
      } else {
        listItensConfirmed.remove(produto);
      }
    });
    db.deleteProdutoFromLista(listaMercado, produto);
  }

  Future adicionarNovoItem() async {
    Produto? temp;
    temp = await newItemScreen(context);
    if (temp != null && temp.precoAtual == 0.0) {
      db.insertItem(widget.listaMercado, temp);
      listItensPendent.add(temp);
      setState(() {
        listItensPendent = Produto.ordenarItens(listItensPendent);
      });
    } else if (temp?.precoAtual != 0.0) {
      db.insertItem(widget.listaMercado, temp!);
      listItensConfirmed.add(temp);
      setState(() {
        listItensConfirmed = Produto.ordenarItens(listItensConfirmed);
      });
    }
  }

  void salvarListaTemp() async {
    print(
        '***************** teste de chamada salvar lista **********************************');

    //void finalizarListCompras() async {
    String? nomeMercado = 'Lista salva automática.';

    listaAberta = widget.listaMercado.finalizada;

    if (nomeMercado != null) {
      widget.listaMercado.custoTotal = double.parse(totalValue);
      widget.listaMercado.itens = listItensPendent + listItensConfirmed;
      widget.listaMercado.supermercado = nomeMercado;
      widget.listaMercado.finalizada = true;
      widget.listaMercado.data = DataUtil.getCurrentFormattedDate();

      if (!listaAberta) {
        db.updateListaMercado(widget.listaMercado);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
          (route) => false,
        );
      } else {}

      db.novaListaMercado(widget.listaMercado);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        (route) => false,
      );
    }

/* 
    listaAberta = widget.listaMercado.finalizada;
    print(listaAberta);

    try {
        widget.listaMercado.custoTotal = double.parse(totalValue);
        widget.listaMercado.itens = listItensPendent + listItensConfirmed;
        widget.listaMercado.supermercado = 'Lista salva automática.';
        widget.listaMercado.finalizada = true;
        widget.listaMercado.data = DataUtil.getCurrentFormattedDate();

        if (!listaAberta) {
            db.updateListaMercado(widget.listaMercado);
        } else {
            db.novaListaMercado(widget.listaMercado);
        }
        
        print('Lista salva com sucesso!');
        
        // Realize a navegação para ScreenListasMercado após salvar a lista
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
            (route) => false,
        );
    } catch (e) {
        print('Erro ao salvar a lista: $e');
    }
*/
  }
}
