import 'package:flutter/material.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

class ButtomBar extends StatefulWidget {
  //final Function finalizarListCompras;
  //final Function adicionarItem;
  String totalValue;
  List<Produto> listPendentItens;
  List<Produto> listConfirmedItens;
  ListaMercado listaMercado;
  late bool listaAberta;

  ButtomBar({
    super.key,
    // required this.finalizarListCompras,
    //required this.adicionarItem,
    required this.totalValue,
    required this.listPendentItens,
    required this.listConfirmedItens,
    required this.listaMercado,
  });

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
            onTap: null,
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
            onTap: null,
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

/*   void finalizarListCompras() async {
    print('teste de chamada finalizar Lista compras ------------');
    String? nomeMercado = await confirmMercadoScreen(context: context);
    bool listaAberta = widget.listaMercado.finalizada;

    if (nomeMercado != null) {
      widget.listaMercado.custoTotal = double.parse(widget.totalValue);
      widget.listaMercado.itens =
          widget.listPendentItens + widget.listConfirmedItens;
      widget.listaMercado.supermercado = nomeMercado;
      widget.listaMercado.finalizada = true;
      widget.listaMercado.data = DataUtil.getCurrentFormattedDate();
      widget.listaMercado.uniqueKey = Uuid().v4().substring(0, 8);

/*       if (!listaAberta) {
        await db.atualizarListaMercado(widget.listaMercado);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
          (route) => false,
        );
      } else {} */

      TestePrintMixin.printListaMercadoInfo(widget.listaMercado);

      await db.salvarListaMercado(widget.listaMercado);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        (route) => false,
      );
    }
  } */

/*   Future adicionarNovoItem() async {
    Produto? temp;
    temp = await newItemScreen(context);
    if (temp != null && temp.precoAtual == 0.0) {
      db.inserirItem(widget.listaMercado, temp);
      widget.listPendentItens.add(temp);
      setState(() {
        widget.listPendentItens = Produto.ordenarItens(widget.listPendentItens);
      });
    } else if (temp?.precoAtual != 0.0) {
      db.inserirItem(widget.listaMercado, temp!);
      widget.listConfirmedItens.add(temp);
      setState(() {
        widget.listConfirmedItens =
            Produto.ordenarItens(widget.listConfirmedItens);
      });
    }
  } */
}
