import 'package:flutter/material.dart';
import 'package:lista_mercado/components/decoration_list_bar.dart';
import 'package:lista_mercado/components/items/item_list_pendent.dart';
import 'package:lista_mercado/components/items/item_list_confirmed.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/components/modals/modal_screen_confirm_mercado.dart';
import 'package:lista_mercado/components/modals/modal_screen_new_item.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:lista_mercado/util/data_util.dart';

class ScreenActiveList extends StatefulWidget {
  ScreenActiveList(this.listaMercado, {Key? key}) : super(key: key);
  final ListaMercado listaMercado;

  @override
  State<ScreenActiveList> createState() => _ActiveListState();
}

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

  @override
  void initState() {
    super.initState();
    db.initDB();
    abrirListaMercado(widget.listaMercado);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    testeExibirListaItems();
  }

  @override
  Widget build(BuildContext context) {
    totalValue = somarList(listItensConfirmed).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.deepPurple,
            height: 1.0,
          ),
        ),
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
          const Padding(
            padding: EdgeInsets.only(right: 10),
          ),
        ],
      ),
      body: Stack(
        children: [
          //const DecorationListBar(),
          SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                  leading: const Icon(Icons.format_line_spacing_sharp),
                  initiallyExpanded: true,
                  title: const Text('Itens que faltam'),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      itemCount: listItensPendent.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: UniqueKey(),
                          //direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              // Mover o item para confirmado
                              moveItemToConfirmedList(listItensPendent[index]);
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              // Excluir o item
                              excluirItemPendente(listItensPendent[index]);
                            }
                          },
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
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.format_line_spacing_sharp),
                  initiallyExpanded: true,
                  title: const Text('Itens adicionados ao carrinho'),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      itemCount: listItensConfirmed.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: UniqueKey(),
                          //direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              setState(() {
                                listItensConfirmed.removeAt(index);
                              });
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              setState(() {
                                listItensConfirmed.removeAt(index);
                              });
                            }
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 10),
                            child: const Icon(
                              Icons.delete,
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
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
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
                        const Text(
                          'Valor total: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'R\$ $totalValue',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Produto? temp;
                      temp = await newItemScreen(context);
                      if (temp != null && temp.precoAtual == 0.0) {
                        db.insertItem(widget.listaMercado, temp);
                        listItensPendent.add(temp!);
                        setState(() {
                          listItensPendent =
                              Produto.ordenarItens(listItensPendent);
                        });
                      } else if (temp?.precoAtual != 0.0) {
                        db.insertItem(widget.listaMercado, temp!);
                        listItensConfirmed.add(temp);
                        setState(() {
                          listItensConfirmed =
                              Produto.ordenarItens(listItensConfirmed);
                        });
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Adicionar Item',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
    db.printAllItems();
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

  void excluirItemPendente(Produto produto) {
    setState(() {
      listItensPendent.remove(produto);
    });
    // Adicione aqui a lógica para excluir permanentemente do banco de dados
  }
}
