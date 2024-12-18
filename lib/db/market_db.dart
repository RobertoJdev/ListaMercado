import 'package:lista_mercado/db/database_utils.dart';
import 'package:lista_mercado/util/generate_item_list_mixin.dart';
import 'package:lista_mercado/util/teste_print_mixin.dart';
import 'package:uuid/uuid.dart';

import '/models/lista_mercado.dart';
import '/models/produto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MarketDB with GenerateItemListMixin, TestePrintMixin {
  late Database _database;

  Future<void> openDB() async {
    if (_database == null || !(_database?.isOpen ?? false)) {
      print(
          'openDB: Banco não está aberto ou inicializado. Chamando initDB...');
      await initDB();
      print('openDB: Banco inicializado com sucesso.');
    } else {
      print('openDB: Banco já estava aberto.');
    }
  }

  /*  Future<void> initDB() async {
    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'listMarket.db'),
      version: 4, // Atualize para versão 4
      onCreate: (db, version) async {
        // Criação inicial do banco de dados
        await _createTables(db);
        await _insertTestMarketData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Atualização da versão 1 para a versão 2
          await _upgradeToVersion2(db);
        }
        if (oldVersion < 3) {
          // Atualização da versão 2 para a versão 3
          await _upgradeToVersion3(db);
        }
        if (oldVersion < 4) {
          // Atualização da versão 3 para a versão 4
          await _upgradeToVersion4(db);
        }
      },
      onOpen: (db) async {
        // Verifica a estrutura da tabela "ListaMercado"
        await DatabaseUtils.verificarEstruturaTabela(db, 'ListaMercado');
      },
    );
    await openDB();
  }
 */

  Future<void> _createTables(Database db) async {
    // Remova todas as tabelas antes de criar novas (opcional para evitar conflitos)
    await db.execute('DROP TABLE IF EXISTS ListaMercado;');
    await db.execute('DROP TABLE IF EXISTS Produto;');
    await db.execute('DROP TABLE IF EXISTS HistoricoPreco;');
    await db.execute('DROP TABLE IF EXISTS ListaMercadoProduto;');

    // Criação da tabela ListaMercado
    await db.execute('''
    CREATE TABLE ListaMercado (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      userId TEXT NOT NULL, 
      userEmail TEXT NOT NULL DEFAULT '', 
      isShared INTEGER NOT NULL DEFAULT 0, 
      sharedWithEmail TEXT, 
      custoTotal REAL NOT NULL, 
      data TEXT NOT NULL, 
      supermercado TEXT NOT NULL, 
      finalizada INTEGER NOT NULL, 
      isSynced INTEGER NOT NULL DEFAULT 0, 
      uniqueKey TEXT NOT NULL UNIQUE
    );
  ''');

    // Criação da tabela Produto
    await db.execute('''
    CREATE TABLE Produto (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      descricao TEXT NOT NULL, 
      barras TEXT NOT NULL, 
      quantidade REAL NOT NULL, 
      pendente INTEGER NOT NULL, 
      precoAtual REAL NOT NULL, 
      categoria TEXT NOT NULL
    );
  ''');

    // Criação da tabela HistoricoPreco
    await db.execute('''
    CREATE TABLE HistoricoPreco (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      produtoId INTEGER NOT NULL, 
      preco REAL NOT NULL, 
      data TEXT NOT NULL, 
      FOREIGN KEY (produtoId) REFERENCES Produto(id) ON DELETE CASCADE
    );
  ''');

    // Criação da tabela ListaMercadoProduto
    await db.execute('''
    CREATE TABLE ListaMercadoProduto (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      listaMercadoId INTEGER, 
      produtoId INTEGER, 
      FOREIGN KEY (listaMercadoId) REFERENCES ListaMercado(id), 
      FOREIGN KEY (produtoId) REFERENCES Produto(id)
    );
  ''');

    print(
        "********************* Tabelas criadas com sucesso *********************");
  }

  Future<void> initDB() async {
    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'listMarket.db'),
      version: 5,
      onCreate: (db, version) async {
        await _createTables(db);
        await _inserirTesteMercadoData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print(
            "Atualizando banco de dados da versão $oldVersion para $newVersion...");
        await _createTables(db);
      },
      onOpen: (db) async {
        await DatabaseUtils.verificarEstruturaTabela(db, 'ListaMercado');
        //print(
        //    "--------------- Banco de dados aberto com sucesso. ---------------");
      },
    );
    await openDB();
  }

  static void popularDB(ListaMercado listaMercado) {
    MarketDB itemMarketDB = MarketDB();
    itemMarketDB.novaListaMercado(listaMercado);
  }

  Future<void> _inserirTesteMercadoData(Database db) async {
    //List<Produto> itensMercado = GenerateItemListMixin.generateMultiProdutosExemplo();
    //List<Produto> itensMercado = Produto.generateMultiProdutosExemplo();
    ListaMercado lista = GenerateItemListMixin.generateListaMercadoExemplo();
    //ListaMercado lista = ListaMercado.generateListaMercadoExemplo(itensMercado);
    //const userId = 1;
    salvarListaMercado(lista);
  }

  Future<void> inserirItem(ListaMercado listaMercado, Produto produto) async {
    await initDB();
    await openDB();

    await _database.transaction((txn) async {
      // Insere o produto no banco de dados
      int produtoId = await txn.insert(
        'Produto',
        {
          'descricao': produto.descricao,
          'barras': produto.barras,
          'quantidade': produto.quantidade,
          'pendente': produto.pendente ? 1 : 0,
          'precoAtual': produto.precoAtual,
          'categoria': produto.categoria
        },
      );

      // Associa o produto à ListaMercado
      await txn.insert(
        'ListaMercadoProduto',
        {
          'listaMercadoId': listaMercado.id,
          'produtoId': produtoId,
        },
      );

      // Inserir o preço atual no histórico
      await txn.insert(
        'HistoricoPreco',
        {
          'produtoId': produtoId,
          'preco': produto.precoAtual,
          'data': DateTime.now().toIso8601String(),
        },
      );
    });
  }

  Future<int> novaListaMercado(ListaMercado listaMercado) async {
    await initDB();
    await openDB();
    listaMercado.finalizada = true;
    //print('chamada de metodo para criar nova lista mercado');
    //TestePrintMixin.printListaMercadoInfo(listaMercado);

    final listaMercadoMap = listaMercado.toMapSql();

    //final listaMercadoMap = listaMercado.toMap();
    // Cria um mapa com os valores da ListaMercado
/*     final listaMercadoMap = {
      'userId': listaMercado.userId,
      'userEmail': listaMercado.userEmail,
      'isShared': listaMercado.isShared ? 1 : 0,
      'sharedWithEmail': listaMercado.sharedWithEmail,
      'custoTotal': listaMercado.custoTotal,
      'data': listaMercado.data,
      'supermercado': listaMercado.supermercado,
      'finalizada': listaMercado.finalizada ? 1 : 0,
      'isSynced': listaMercado.isSynced ? 1 : 0,
      'uniqueKey': listaMercado.uniqueKey,
    }; */

    int listaMercadoId =
        await _database.insert('ListaMercado', listaMercadoMap);

    // Salva os produtos associados à ListaMercado
    for (Produto produto in listaMercado.itens) {
      // Cria um mapa com os valores do Produto
      final produtoMap = {
        'descricao': produto.descricao,
        'barras': produto.barras,
        'quantidade': produto.quantidade,
        'pendente':
            produto.pendente ? 1 : 0, // Ajustando para armazenar como inteiro
        'precoAtual': produto.precoAtual,
        'categoria': produto.categoria,
      };

      // Insere o produto no banco de dados
      int produtoId = await _database.insert('Produto', produtoMap);

      // Insere o preço atual no histórico de preços
      if (produto.precoAtual != null && produto.precoAtual > 0) {
        await _database.insert(
          'HistoricoPreco', // Supondo que você tenha uma tabela de histórico de preços
          {
            'produtoId': produtoId,
            'preco': produto.precoAtual,
            'data': DateTime.now().toIso8601String(), // Armazena a data atual
          },
        );
      }

      // Associa o produto à ListaMercado
      await _database.insert(
        'ListaMercadoProduto',
        {
          'listaMercadoId': listaMercadoId,
          'produtoId': produtoId,
        },
      );

      // Imprimir os preços no histórico
      TestePrintMixin.printHistoricoPreco(produto, "NOVA LISTA MERCADO");
    }

    return listaMercadoId;
  }

  Future<List<Map<String, dynamic>>> getTodosItens() async {
    await initDB();
    await openDB();
    return await _database.rawQuery('''
      SELECT *
      FROM Produto
      INNER JOIN ListaMercadoProduto ON Produto.id = ListaMercadoProduto.produtoId
      INNER JOIN ListaMercado ON ListaMercadoProduto.listaMercadoId = ListaMercado.id
    ''');
  }

  Future<bool> getListasNaoFinalizadas() async {
    await openDB();
    List<Map<String, dynamic>> listasMercadoNaoFinalizadas =
        await _database.rawQuery('''
    SELECT *
    FROM ListaMercado
    WHERE finalizada = 0
  ''');

    List<Map<String, dynamic>> todasListas = await _database.rawQuery('''
    SELECT *
    FROM ListaMercado
  ''');

    print('Listas de Mercado não finalizadas:');
    print(listasMercadoNaoFinalizadas);

    return listasMercadoNaoFinalizadas.isNotEmpty;
  }

  Future<List<ListaMercado>> getTodasListasMercado() async {
    List<ListaMercado> result = [];
    await openDB();

    // Consulta para recuperar as listas e seus produtos
    List<Map<String, dynamic>> listasMercado = await _database.rawQuery('''
    SELECT ListaMercado.*, 
           Produto.id as produtoId,
           Produto.descricao as produtoDescricao,
           Produto.barras as produtoBarras,
           Produto.quantidade as produtoQuantidade,
           Produto.pendente as produtoPendente,
           Produto.precoAtual as produtoPrecoAtual,
           Produto.categoria as produtoCategoria,
           HistoricoPreco.preco as historicoPreco,
           HistoricoPreco.data as historicoData
    FROM ListaMercado
    LEFT JOIN ListaMercadoProduto ON ListaMercado.id = ListaMercadoProduto.listaMercadoId
    LEFT JOIN Produto ON ListaMercadoProduto.produtoId = Produto.id
    LEFT JOIN HistoricoPreco ON Produto.id = HistoricoPreco.produtoId
    ORDER BY ListaMercado.id, Produto.id, HistoricoPreco.data ASC
  ''');

    int currentListaId = -1; // Para rastrear a mudança de lista
    int currentProdutoId = -1; // Para rastrear a mudança de produto
    ListaMercado? currentLista;
    Produto? currentProduto;

    for (var item in listasMercado) {
      // Se a lista de mercado mudar
      if (item['id'] != currentListaId) {
        currentListaId = item['id'];
        currentLista = ListaMercado(
          id: item['id'],
          userId: item['userId'] ?? '',
          userEmail: item['userEmail'] ?? '',
          isShared: (item['isShared'] ?? 0) == 1,
          sharedWithEmail: item['sharedWithEmail'] ?? '',
          custoTotal: item['custoTotal'] ?? 0.0,
          data: item['data'] ?? '',
          supermercado: item['supermercado'] ?? '',
          finalizada: (item['finalizada'] ?? 0) == 1,
          isSynced: (item['isSynced'] ?? 0) == 1,
          uniqueKey: item['uniqueKey'] ?? '',
          itens: [],
        );
        result.add(currentLista);
        currentProdutoId = -1; // Reseta o produto ao mudar a lista
      }

      // Se o produto mudar
      if (item['produtoId'] != null && item['produtoId'] != currentProdutoId) {
        currentProdutoId = item['produtoId'];
        currentProduto = Produto(
          descricao: item['produtoDescricao'] ?? '',
          barras: item['produtoBarras'] ?? '',
          quantidade: item['produtoQuantidade'] ?? 0,
          pendente: (item['produtoPendente'] ?? 0) == 1,
          precoAtual: item['produtoPrecoAtual'] ?? 0.0,
          categoria: item['produtoCategoria'] ?? '',
          historicoPreco: [],
        );

        // Adiciona o produto à lista
        currentLista!.itens.add(currentProduto);
      }

      // Adiciona os preços históricos ao produto atual
      if (currentProduto != null && item['historicoPreco'] != null) {
        currentProduto.historicoPreco.add(item['historicoPreco'] as double);
      }
    }

    return result;
  }

  Future<ListaMercado?> buscarListaMercadoById(int listaMercadoId) async {
    await openDB();

    // Consulta para recuperar uma lista de mercado específica e seus produtos
    List<Map<String, dynamic>> listasMercado = await _database.rawQuery('''
    SELECT ListaMercado.*, 
           Produto.id as produtoId,
           Produto.descricao as produtoDescricao,
           Produto.barras as produtoBarras,
           Produto.quantidade as produtoQuantidade,
           Produto.pendente as produtoPendente,
           Produto.precoAtual as produtoPrecoAtual,
           Produto.categoria as produtoCategoria
    FROM ListaMercado
    LEFT JOIN ListaMercadoProduto ON ListaMercado.id = ListaMercadoProduto.listaMercadoId
    LEFT JOIN Produto ON ListaMercadoProduto.produtoId = Produto.id
    WHERE ListaMercado.id = ?
  ''', [listaMercadoId]);

    ListaMercado? result;

    if (listasMercado.isNotEmpty) {
      // Criação da instância de ListaMercado
      result = ListaMercado(
        id: listasMercado[0]['id'],
        userId: listasMercado[0]['userId'],
        userEmail: listasMercado[0]['userEmail'],
        isShared: listasMercado[0]['isShared'] == 1,
        sharedWithEmail: listasMercado[0]['sharedWithEmail'],
        custoTotal: listasMercado[0]['custoTotal'],
        data: listasMercado[0]['data'],
        supermercado: listasMercado[0]['supermercado'],
        finalizada: listasMercado[0]['finalizada'] == 1,
        createdAt: listasMercado[0]['createdat'],
        updatedAt: listasMercado[0]['updatedat'],
        isSynced: listasMercado[0]['issynced'] == 1,
        uniqueKey: listasMercado[0]['uniqueKey'],
        itens: [],
      );

      for (var item in listasMercado) {
        if (item['produtoId'] != null) {
          // Criação da instância de Produto
          Produto produto = Produto(
            descricao: item['produtoDescricao'],
            barras: item['produtoBarras'],
            quantidade: item['produtoQuantidade'],
            pendente: item['produtoPendente'] == 1,
            precoAtual: item['produtoPrecoAtual'],
            categoria: item['produtoCategoria'],
            historicoPreco: [], // Será populado a seguir
          );

          // Recuperar o histórico de preços para o produto
          List<Map<String, dynamic>> historico = await _database.query(
            'HistoricoPreco',
            where: 'produtoId = ?',
            whereArgs: [item['produtoId']],
            orderBy: 'data ASC', // Ordenar por data
          );

          // Adicionar os preços ao histórico do produto
          for (var h in historico) {
            if (h['preco'] != null) {
              produto.historicoPreco.add(h['preco'] as double);
            }
          }

          // Adicionar o produto com o histórico à lista de itens
          result.itens.add(produto);
        }
      }
    }

    TestePrintMixin.printHistoricoPreco(
        result!.itens[0], "searchListaMercadoById");

    return result;
  }

  Future<int> salvarListaMercadoVazia(String userId) async {
    await openDB();

    ListaMercado lista = ListaMercado(
      userId: userId,
      userEmail: '',
      custoTotal: 0.0,
      data: '',
      supermercado: 'Lista Não Finalizada',
      finalizada: false,
      itens: [],
    );

    // Exclui todas as listas de mercado não finalizadas do usuário
    await _database.delete(
      'ListaMercado',
      where: 'userId = ? AND finalizada = 0',
      whereArgs: [userId],
    );

    final listaMercadoMap = lista.toMapSql();

/*     // Cria um mapa com os valores da ListaMercado
    final listaMercadoMap = {
      'userId': userId,
      'custoTotal': 0.0,
      'data': '',
      'supermercado': 'Lista Não Finalizada',
      'finalizada': 0,
    }; */

    // Insere a lista de mercado vazia no banco de dados
    int listaMercadoId =
        await _database.insert('ListaMercado', listaMercadoMap);

    return listaMercadoId;
  }

  Future<void> atualizarListaMercado(ListaMercado listaMercado) async {
    await openDB();
    await _database.transaction((txn) async {
      // Atualiza os dados da ListaMercado
      await txn.update(
        'ListaMercado',
        {
          'userId': listaMercado.userId,
          'custoTotal': listaMercado.custoTotal,
          'data': listaMercado.data,
          'supermercado': listaMercado.supermercado,
          'finalizada': listaMercado.finalizada ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [listaMercado.id],
      );

      // Deleta os produtos associados à ListaMercado
      await txn.delete(
        'ListaMercadoProduto',
        where: 'listaMercadoId = ?',
        whereArgs: [listaMercado.id],
      );

      // Insere os produtos atualizados
      for (Produto produto in listaMercado.itens) {
        // Insere o produto no banco de dados
        int produtoId = await txn.insert(
          'Produto',
          {
            'descricao': produto.descricao,
            'barras': produto.barras,
            'quantidade': produto.quantidade,
            'pendente': produto.pendente ? 1 : 0,
            'precoAtual': produto.precoAtual,
            'categoria': produto.categoria,
          },
        );

        // Insere o preço atual no histórico de preços
        if (produto.precoAtual != null && produto.precoAtual > 0) {
          await txn.insert(
            'HistoricoPreco',
            {
              'produtoId': produtoId,
              'preco': produto.precoAtual,
              'data': DateTime.now().toIso8601String(),
            },
          );
        }

        // Associa o produto à ListaMercado
        await txn.insert(
          'ListaMercadoProduto',
          {
            'listaMercadoId': listaMercado.id,
            'produtoId': produtoId,
          },
        );
      }
    });
  }

  Future<void> apagarListaMercado(ListaMercado listaMercado) async {
    await openDB();
    int? listaMercadoId = listaMercado.id;

    // Exclui a lista de mercado
    await _database.delete(
      'ListaMercado',
      where: 'id = ?',
      whereArgs: [listaMercadoId],
    );

    // Exclui os produtos associados à lista de mercado
    await _database.delete(
      'ListaMercadoProduto',
      where: 'listaMercadoId = ?',
      whereArgs: [listaMercadoId],
    );
  }

  Future<void> apagarProdutoDaLista(
      ListaMercado listaMercado, Produto produto) async {
    await openDB();

    // Exclui a associação do produto com a lista de mercado
    await _database.delete(
      'ListaMercadoProduto',
      where: 'listaMercadoId = ? AND produtoId = ?',
      whereArgs: [listaMercado.id, produto.getId()],
    );

    // Exclui o produto da tabela de produtos
    await _database.delete(
      'Produto',
      where: 'id = ?',
      whereArgs: [produto.getId()],
    );
  }

  Future<int> salvarListaMercado(ListaMercado listaMercado) async {
    await initDB();
    await openDB();

    listaMercado.finalizada = true;

    print('teste interno no save do bd ${listaMercado.uniqueKey}');

    //listaMercado.uniqueKey = Uuid().v4().substring(0, 8);

    final listaMercadoMap = listaMercado.toMapSql();

/*     // Cria um mapa com os valores da ListaMercado
    final listaMercadoMap = {
      'userId': listaMercado.userId,
      'userEmail': listaMercado.userEmail,
      'isShared': listaMercado.isShared ? 1 : 0,
      'sharedWithEmail': listaMercado.sharedWithEmail,
      'custoTotal': listaMercado.custoTotal,
      'data': listaMercado.data,
      'supermercado': listaMercado.supermercado,
      'finalizada': listaMercado.finalizada ? 1 : 0,
      'isSynced': listaMercado.isSynced ? 1 : 0,
      'uniqueKey': listaMercado.uniqueKey,
    }; */

    int listaMercadoId =
        await _database.insert('ListaMercado', listaMercadoMap);

    // Salva os produtos associados à ListaMercado
    for (Produto produto in listaMercado.itens) {
      // Cria um mapa com os valores do Produto
      final produtoMap = {
        'descricao': produto.descricao,
        'barras': produto.barras,
        'quantidade': produto.quantidade,
        'pendente': produto.pendente ? 1 : 0, // Salvando como inteiro
        'precoAtual': produto.precoAtual,
        'categoria': produto.categoria,
      };

      // Insere o produto no banco de dados
      int produtoId = await _database.insert('Produto', produtoMap);

      //teste para inserir os valores já existentes no historico.

      for (int i = 0; i < produto.historicoPreco.length; i++) {
        await _database.insert(
          'HistoricoPreco',
          {
            'produtoId': produtoId,
            'preco': produto.historicoPreco[i],
            'data': DateTime.now().toIso8601String(),
          },
        );
      }

      // Insere o preço atual no histórico, independentemente de ser igual ao anterior
      if (produto.precoAtual != null) {
        await _database.insert(
          'HistoricoPreco',
          {
            'produtoId': produtoId,
            'preco': produto.precoAtual,
            'data': DateTime.now().toIso8601String(),
          },
        );
      }

      // Associa o produto à ListaMercado
      await _database.insert(
        'ListaMercadoProduto',
        {
          'listaMercadoId': listaMercadoId,
          'produtoId': produtoId,
        },
      );
      // Verificar os preços no histórico após a inserção
      await procurarHistoricoDePreco(produtoId);
    }

    return listaMercadoId;
  }

  Future<void> procurarHistoricoDePreco(int produtoId) async {
    await openDB();

    // Consulta o histórico de preços para o produto especificado
    List<Map<String, dynamic>> historico = await _database.query(
      'HistoricoPreco',
      where: 'produtoId = ?',
      whereArgs: [produtoId],
      orderBy: 'data ASC',
    );

    if (historico.isNotEmpty) {
      //print("Histórico de preços para o produto $produtoId:");
      for (var entry in historico) {
        //print("Preço: ${entry['preco']}, Data: ${entry['data']}");
      }
    } else {
      //print("Nenhum histórico encontrado para o produto $produtoId.");
    }
  }
}
