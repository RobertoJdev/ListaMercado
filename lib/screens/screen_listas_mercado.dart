import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/email_screen.dart';
import 'package:lista_mercado/util/teste_print_mixin.dart';
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

import '../util/user_preferences.dart';

class ScreenListasMercado extends StatefulWidget {
  const ScreenListasMercado({super.key});

  @override
  State<ScreenListasMercado> createState() => _listasMercadoState();
}

class _listasMercadoState extends State<ScreenListasMercado> {
  List<ListaMercado> listasMercado = [];
  ListaMercado? listaNaoFinaliza;
  final MarketDB db = MarketDB();

  List<Map<String, dynamic>> listas = [];
  bool isLoading = true;

  late String email;
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadSharedPrefs();
    _carregarListasCompartilhadas();
    _initializeDB();
    //db.getListasNaoFinalizadas();
  }

// Método para inicializar preferências de forma assíncrona
  Future<void> _loadSharedPrefs() async {
    await UserPreferences.init(context); // Aguarda a inicialização
    String fetchedEmail = await UserPreferences.checkAndGetEmail(
        context); // Aguarda o e-mail ser retornado
    setState(() {
      email = fetchedEmail;
      userId = UserPreferences.getUserId().toString();
    });
    //_carregarListasCompartilhadas();
    //_initializeDB();
  }

/*   // Função para verificar se o e-mail do usuário já está salvo
  Future<void> _checkEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    if (email == null || email.isEmpty) {
      // Se o e-mail não estiver salvo, redireciona para a tela de inserir e-mail
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailScreen()),
      );
    } else {}
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('user_email') ?? '';
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
 */
  Future<void> _carregarListasCompartilhadas() async {
    //final prefs = await SharedPreferences.getInstance();
    //final email = prefs.getString('user_email');

    if (email.isNotEmpty) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('listasMercado')
            .where('sharedWithEmail', isEqualTo: email)
            .get();

        print('++++++++++++++++++++++++++++++++++++++++++++++++++++++');

        List<ListaMercado?> listasCompartilhadas = snapshot.docs
            .map((doc) {
              try {
                ListaMercado temp = ListaMercado.fromMap(doc.data());
                return temp;
              } catch (e) {
                print("Erro ao carregar listas compartilhadas no map: $e");
                return null; // ou pode optar por retornar um objeto default
              }
            })
            .where((element) => element != null)
            .toList(); // Filtra os valores nulos, se houver

        //print(listasCompartilhadas[0]?.itens[0].descricao);

        setState(() async {
          bool addList;
          for (var element in listasCompartilhadas) {
            addList = true;
            print('Key do Firebase: ${element?.uniqueKey}');

            //percorre as listas Locais do dispositivo e compara com as listas compartilhadas.
            for (var elementLocal in listasMercado) {
              print('Keys retornadas da Base:  ${elementLocal.uniqueKey}');
              if (element?.uniqueKey == elementLocal.uniqueKey) {
                print('A lista já existe na base.');
                addList = false;
                break;
              }
            }

            if (addList && element != null) {
              print(
                  "++++++++++teste de if para salvar ++++++++++++++++++++++++");
              //retornar*** para conferir mudança de id ao salvar.
              element.id =
                  Random().nextInt(100); // Altera o ID para evitar conflito
              element.finalizada = true;
              element.userId = Uuid().v4().substring(0, 8);

              //element.uniqueKey = Uuid().v4().substring(0, 8);
              listasMercado.add(element);
              //TestePrintMixin.printListaMercadoInfo(element);

              await db.salvarListaMercado(element, true);
              print('Adicionado:::  ${element.uniqueKey}');
            }
          }
          isLoading = false;
        });

        //TestePrintMixin.returnFireBase(snapshot);
      } catch (e) {
        print("Erro ao carregar listas compartilhadas:: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(), // Passa o e-mail para o Menu
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
                  /* const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      'Listas de compras',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ), */
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
                            /* onLongPress: () {
                              
                            }, */
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
    listasMercado = await db.getTodasListasMercado();
    //TestePrintMixin.printAllItemsBD(listasMercado);

    setState(() {
      isLoading = false;
      // Atualiza o estado para indicar que o carregamento terminou
    });

    // Carrega a lista não finalizada.
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
          await db.apagarListaMercado(listaNaoFinaliza!);
        } else {
          abrirListaMercadoNaoFinalizada(context, listaNaoFinaliza!);
        }
      }
    }
  }

  void criarNovaListaMercado(BuildContext context) async {
    ListaMercado novaListaMercado = ListaMercado(
      userId: userId,
      userEmail: email,
      custoTotal: 0,
      data: DataUtil.getCurrentFormattedDate(),
      supermercado: 'Lista Não Finalizada',
      finalizada: false,
      itens: [],
    );

    int idNovaLista = await db.salvarListaMercadoVazia(novaListaMercado);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenActiveList(novaListaMercado),
      ),
    );
  }

  void abrirListaMercadoFinalizada(ListaMercado listaMercado) async {
    int temp = listaMercado.id!;
    ListaMercado? tempLista = await db.buscarListaMercadoById(temp);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenActiveList(tempLista!),
      ),
    );
  }

  void reutilizarListaMercadoFinalizada(ListaMercado listaMercado) async {
    int oldIdList = listaMercado.id!;
    //int newidLista = db.salvarListaMercadoVazia(listaMercado);
    ListaMercado? tempLista = await db.buscarListaMercadoById(oldIdList);

    tempLista?.id = null;

    for (var element in tempLista!.itens) {
      element.pendente = true;
      element.precoAtual = 0;
    }
    tempLista.userId = userId;
    tempLista.userEmail = email;
    tempLista.finalizada = false;
    tempLista.custoTotal = 0;
    tempLista.data = DataUtil.getCurrentFormattedDate();
    tempLista.supermercado = 'Lista salva automaticamente';
    tempLista.uniqueKey = const Uuid().v4().substring(0, 8);

    int idLista = await db.salvarListaMercado(tempLista, false);

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

  void excluirLista(ListaMercado lista) async {
    setState(() {
      listasMercado.remove(lista);
    });
    await db.apagarListaMercado(lista);
  }
}
