import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/email_screen.dart';
import 'package:lista_mercado/util/teste_print.dart';
import 'package:lista_mercado/widgets/decoration_list_bar.dart';
import 'package:lista_mercado/widgets/items/item_list_compra.dart';
import 'package:lista_mercado/widgets/items/item_list_compra_nao_finalizada.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/widgets/menu.dart';
import 'package:lista_mercado/widgets/modals/open_list_unfinished_list.dart';
import 'package:lista_mercado/util/data_util.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/widgets/modals/confirm_delete_list_screen.dart';
import 'package:lista_mercado/widgets/modals/reopen_list_screen.dart';
import 'package:lista_mercado/screens/screen_active_list.dart';
import 'package:lista_mercado/widgets/custom_app_bar.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ScreenListasMercado extends StatefulWidget {
  const ScreenListasMercado({Key? key}) : super(key: key);

  @override
  State<ScreenListasMercado> createState() => _listasMercadoState();
}

class _listasMercadoState extends State<ScreenListasMercado> {
  List<ListaMercado> listasMercado = [];
  ListaMercado? listaNaoFinaliza;
  final MarketDB db = MarketDB();

  List<Map<String, dynamic>> listas = [];
  bool isLoading = true;

  String email = ''; // Variável para armazenar o email

  @override
  void initState() {
    super.initState();
    _checkEmail(); // Verifica o e-mail quando a tela é iniciada
    _initializeDB();
    db.getUnfinishedLists();
    _loadEmail(); // Chamar o método para carregar o e-mail
    _carregarListasCompartilhadas();
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

// Método para verificar e carregar ou gerar o userId
  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    // Verifica se o userId existe nas preferências
    if (prefs.containsKey('userId')) {
      return prefs.getString('userId')!;
    } else {
      // Gera um novo userId e salva nas preferências
      String newUserId =
          Uuid().v4().substring(0, 8); // UUID curto (8 caracteres)
      await prefs.setString('userId', newUserId);
      print("Retorno do valor do ID do usuário: ========== $newUserId");
      return newUserId;
    }
  }

  Future<void> _carregarListasCompartilhadas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('preferredEmail');

    if (email != null) {
      try {
        // Consultar o Firestore para listas compartilhadas
        final snapshot = await FirebaseFirestore.instance
            .collection('listasMercado')
            .where('sharedWithEmail', isEqualTo: email)
            .get();

        List<ListaMercado?> listasCompartilhadas = snapshot.docs
            .map((doc) {
              try {
                return ListaMercado.fromMap(doc.data() as Map<String, dynamic>);
              } catch (e) {
                print("Erro ao carregar listas compartilhadas: $e");
                return null; // ou pode optar por retornar um objeto default
              }
            })
            .where((element) => element != null)
            .toList(); // Filtra os valores nulos, se houver

       // setState(() {
      //    listasMercado.addAll(
       //       listasCompartilhadas as Iterable<ListaMercado>); // Adiciona as listas compartilhadas à lista local
      //    isLoading = false;
      //  });

        

        TestePrintMixin.returnFireBase(snapshot);
      } catch (e) {
        print("Erro ao carregar listas compartilhadas: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(userEmail: email), // Passa o e-mail para o Menu
      appBar: const CustomAppBar(
        title: 'Minhas Listas',
        showShareButton: false,
        screenReturn: false,
      ),
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
                      'Listas de compras',
                      style: TextStyle(color: Colors.deepPurple),
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
                            return await confirmDeleteList(context);
                          },
                          child: GestureDetector(
                            onTap: () async {
                              bool? reabrirLista =
                                  await reopenList(context: context);
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
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurpleAccent,
                            Colors.deepPurple, // Cor final do degradê
                          ],
                          begin: Alignment.center, // Início do gradiente
                          end: Alignment.bottomCenter, // Fim do gradiente
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          criarNovaListaMercado(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Criar nova lista',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
    //TestePrintMixin.printAllItemsBD(listasMercado);

    setState(() {
      isLoading = false;
      // Atualiza o estado para indicar que o carregamento terminou
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
      bool? resultado = await openListUnfinishedList(context);

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
    int idNovaLista = await db.salvarListaMercadoVazia(getUserId().toString());

    ListaMercado novaListaMercado = ListaMercado(
      id: idNovaLista,
      userId: getUserId().toString(),
      userEmail: email,
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

    for (var element in tempLista!.itens) {
      element.pendente = true;
      element.precoAtual = 0;
    }

    tempLista.userEmail = email;

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
