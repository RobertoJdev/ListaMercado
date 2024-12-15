import 'package:flutter/material.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/widgets/modals/confirm_mercado_screen.dart';
import 'package:lista_mercado/widgets/modals/new_item_screen.dart';

class ButtomBar extends StatefulWidget {
  //final Function finalizarListCompras;
  //final Function adicionarItem;
  String totalValue;
  List<Produto> listPendentItens;
  List<Produto> listConfirmedItens;
  ListaMercado listaMercado;
  late bool listaAberta;

  ButtomBar({
    Key? key,
    // required this.finalizarListCompras,
    //required this.adicionarItem,
    required this.totalValue,
    required this.listPendentItens,
    required this.listConfirmedItens,
    required this.listaMercado,
  }) : super(key: key);

  @override
  State<ButtomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<ButtomBar> {
  final MarketDB db = MarketDB();

  @override
  void initState() {
    super.initState();
    db.initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.5),
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
            onTap: () {
              finalizarListCompras();
            },
            child: Row(
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Finalizar: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'R\$ ${widget.totalValue}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
    );
  }

  void finalizarListCompras() async {
    String? nomeMercado = await confirmMercadoScreen(context: context);
    late bool listaAberta;
    listaAberta = widget.listaMercado.finalizada;

    if (nomeMercado != null) {
      widget.listaMercado.custoTotal = double.parse(widget.totalValue);
      widget.listaMercado.itens =
          widget.listPendentItens + widget.listConfirmedItens;
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

      db.newListaMercado(widget.listaMercado);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        (route) => false,
      );
    }
  }

  Future adicionarNovoItem() async {
    Produto? temp;
    temp = await newItemScreen(context);
    if (temp != null && temp.precoAtual == 0.0) {
      db.insertItem(widget.listaMercado, temp);
      widget.listPendentItens.add(temp!);
      setState(() {
        widget.listPendentItens = Produto.ordenarItens(widget.listPendentItens);
      });
    } else if (temp?.precoAtual != 0.0) {
      db.insertItem(widget.listaMercado, temp!);
      widget.listConfirmedItens.add(temp);
      setState(() {
        widget.listConfirmedItens =
            Produto.ordenarItens(widget.listConfirmedItens);
      });
    }
  }
}
