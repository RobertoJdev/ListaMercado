import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/email_screen.dart';
import 'package:lista_mercado/widgets/decoration_list_bar.dart';
import 'package:lista_mercado/widgets/items/item_list_compra.dart';
import 'package:lista_mercado/widgets/items/item_list_compra_nao_finalizada.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/widgets/menu.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_lista_nao_finalizada.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_exclui_lista.dart';
import 'package:lista_mercado/widgets/modals/modal_screen_reabrir_lista.dart';
import 'package:lista_mercado/screens/screen_active_list.dart';
import 'package:lista_mercado/widgets/custom_app_bar.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenListasMercado extends StatefulWidget {
  const ScreenListasMercado({Key? key}) : super(key: key);

  @override
  State<ScreenListasMercado> createState() => _listasMercadoState();
}

class _listasMercadoState extends State<ScreenListasMercado> {
  List<ListaMercado> listasMercado = [];
  ListaMercado? listaNaoFinaliza;
  final MarketDB db = MarketDB();

  String email = ''; // Variável para armazenar o email

  @override
  void initState() {
    super.initState();
    _checkEmail(); // Verifica o e-mail quando a tela é iniciada
    _initializeDB();
    db.getUnfinishedLists();
    _loadEmail(); // Chamar o método para carregar o e-mail
  }

  // Função para verificar se o e-mail do usuário já está salvo
  Future<void> _checkEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    if (email == null || email.isEmpty) {
      // Se o e-mail não estiver salvo, redireciona para a tela de inserir e-mail
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailScreen()),
      );
    } else {
      // Caso contrário, continue com a lógica da tela
      // Você pode carregar a lista de mercado aqui ou outra lógica
    }
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('user_email') ??
          ''; // Lê o e-mail das SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(userEmail: email), // Passa o e-mail para o Menu
      appBar: const CustomAppBar(screenReturn: false),
      body: Column(
        children: [
          //const DecorationListBar(isListMercado: true),
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
                            onTap: () async {
                              bool? reabrirLista =
                                  await reabrirListaScreen(context: context);
                              if (reabrirLista!) {
                                reutilizarListaMercadoFinalizada(
                                    listasMercado[index]);
                              } else {
                                abrirListaMercadoFinalizada(
                                    listasMercado[index]);
                              }
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 12),
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
        ],
      ),
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

    // Log para verificar se as listas foram recuperadas
    print('Listas recuperadas: ${listasMercado.length}');
    print(
        "===========================================================================================================================");
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

  void abrirListaMercadoFinalizada(ListaMercado listaMercado) async {
    // bool? reabrirLista = await reabrirListaScreen(context: context);
    print(
        "================================================= abertura de lista finalizada ==========================================================================");
    int temp = listaMercado.id!;
    ListaMercado? tempLista = await db.searchListaMercadoById(temp);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenActiveList(tempLista!),
      ),
    );
  }

  void reutilizarListaMercadoFinalizada(ListaMercado listaMercado) async {
    int temp = listaMercado.id!;
    ListaMercado? tempLista = await db.searchListaMercadoById(temp);

    MarketDB.printListaMercadoInfo(tempLista!);

    print(
        "========================================== entrada de lista REUTILIZAR =======================================================");

    for (var element in tempLista!.itens) {
      element.pendente = true;
      //element.historicoPreco.add(element.precoAtual);
      //element.historicoPreco.add(2.2);
      //element.historicoPreco.add(3.3);
      element.precoAtual = 0;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenActiveList(tempLista),
      ),
    );
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
