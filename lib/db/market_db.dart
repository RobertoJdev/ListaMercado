import '/models/lista_mercado.dart';
import '/models/produto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MarketDB {
  late Database _database;

  Future<void> openDB() async {
    if (!(_database?.isOpen ?? false)) {
      await initDB();
    }
  }

  Future<void> initDB() async {
    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'listMarket.db'),
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertTestMarketData(db);
      },
      version: 1,
    );

    await openDB();
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE ListaMercado (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        custoTotal REAL NOT NULL,
        data TEXT NOT NULL,
        supermercado TEXT NOT NULL,
        finalizada INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Produto (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        barras TEXT NOT NULL,
        quantidade REAL NOT NULL,
        pendente INTEGER NOT NULL,
        precoAtual REAL NOT NULL,
        categoria TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ListaMercadoProduto (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        listaMercadoId INTEGER,
        produtoId INTEGER,
        FOREIGN KEY (listaMercadoId) REFERENCES ListaMercado(id),
        FOREIGN KEY (produtoId) REFERENCES Produto(id)
      )
    ''');
  }

  Future<void> _insertTestMarketData(Database db) async {
    List<Produto> itensMercado = Produto.generateMultiProdutosExemplo();
    ListaMercado lista = ListaMercado.generateListaMercadoExemplo(itensMercado);
    final userId = 1;

    // Inserindo uma lista de mercado de teste associada ao usuário
    final listaMercadoId = await db.insert(
      'ListaMercado',
      {
        'userId': userId,
        'custoTotal': lista.custoTotal,
        'data': lista.data,
        'supermercado': lista.supermercado,
        'finalizada': 1,
      },
    );

    for (var element in itensMercado) {
      // Inserindo um produto de teste associado à lista de mercado
      final produtoId = await db.insert(
        'Produto',
        {
          'descricao': element.descricao,
          'barras': element.barras,
          'quantidade': element.quantidade,
          'pendente': element.pendente,
          'precoAtual': element.precoAtual,
          'categoria': element.categoria,
        },
      );

      // Associando o produto à lista de mercado
      await db.insert(
        'ListaMercadoProduto',
        {
          'listaMercadoId': listaMercadoId,
          'produtoId': produtoId,
        },
      );
    }
  }

  Future<void> insertItem(ListaMercado listaMercado, Produto produto) async {
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
    });
  }

  Future<int> novaListaMercado(ListaMercado listaMercado) async {
    await initDB();
    await openDB();

    listaMercado.finalizada = true;

    // Cria um mapa com os valores da ListaMercado
    final listaMercadoMap = {
      'userId': listaMercado.userId,
      'custoTotal': listaMercado.custoTotal,
      'data': listaMercado.data,
      'supermercado': listaMercado.supermercado,
      'finalizada': listaMercado.finalizada,
    };

    int listaMercadoId =
        await _database.insert('ListaMercado', listaMercadoMap);

    // Salva os produtos associados à ListaMercado
    for (Produto produto in listaMercado.itens) {
      // Cria um mapa com os valores do Produto
      final produtoMap = {
        'descricao': produto.descricao,
        'barras': produto.barras,
        'quantidade': produto.quantidade,
        'pendente': produto.pendente,
        'precoAtual': produto.precoAtual,
        'categoria': produto.categoria,
      };

      // Insere o produto no banco de dados
      int produtoId = await _database.insert('Produto', produtoMap);

      // Associa o produto à ListaMercado
      await _database.insert(
        'ListaMercadoProduto',
        {
          'listaMercadoId': listaMercadoId,
          'produtoId': produtoId,
        },
      );
    }

    return listaMercadoId;
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    await initDB();
    await openDB();
    return await _database.rawQuery('''
      SELECT *
      FROM Produto
      INNER JOIN ListaMercadoProduto ON Produto.id = ListaMercadoProduto.produtoId
      INNER JOIN ListaMercado ON ListaMercadoProduto.listaMercadoId = ListaMercado.id
    ''');
  }

  Future<void> printAllItems() async {
    print(
        '********************------------------Teste chamada printAllItens------------------********************');
    final items = await getAllItems();
    print(items);

    for (var item in items) {
      print('ID: ${item['id']}');
      print('User ID: ${item['userId']}');
      print('Total Cost: ${item['custoTotal']}');
      print('Data: ${item['data']}');
      print('Supermarket: ${item['supermercado']}');
      print('Finished: ${item['finalizada']}');

      final products = await _database.query(
        'ListaMercadoProduto',
        where: 'listaMercadoId = ?',
        whereArgs: [item['id']],
      );

      for (var product in products) {
        final productInfo = await _database.query(
          'Produto',
          where: 'id = ?',
          whereArgs: [product['produtoId']],
        );

        print('Produto ID: ${productInfo[0]['id']}');
        print('Descrição: ${productInfo[0]['descricao']}');
        print('Barras: ${productInfo[0]['barras']}');
        print('Quantidade: ${productInfo[0]['quantidade']}');
        print('Pendente: ${productInfo[0]['pendente']}');
        print('Preço Atual: ${productInfo[0]['precoAtual']}');
      }
    }
    print('--------------------------------------------------------------------------------------------------');
  }

  Future<bool> getUnfinishedLists() async {
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

  Future<List<ListaMercado>> getAllListasMercado() async {
    List<ListaMercado> result = [];
    await openDB();
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
  ''');

    int currentListaId = -1; // Para rastrear a mudança de lista
    ListaMercado? currentLista;

    for (var item in listasMercado) {
      if (item['id'] != currentListaId) {
        currentListaId = item['id'];
        currentLista = ListaMercado(
          id: item['id'],
          userId: item['userId'],
          custoTotal: item['custoTotal'],
          data: item['data'],
          supermercado: item['supermercado'],
          finalizada: item['finalizada'] == 1,
          itens: [],
        );
        result.add(currentLista);
      }

      if (item['produtoId'] != null) {
        Produto produto = Produto(
          descricao: item['produtoDescricao'],
          barras: item['produtoBarras'],
          quantidade: item['produtoQuantidade'],
          pendente: item['produtoPendente'] == 1,
          precoAtual: item['produtoPrecoAtual'],
          categoria: item['produtoCategoria'],
          historicoPreco: [],
        );
        currentLista!.itens.add(produto);
      }
    }
    return result;
  }

  static void populateDB(ListaMercado listaMercado) {
    MarketDB itemMarketDB = MarketDB();
    itemMarketDB.novaListaMercado(listaMercado);
  }

  Future<ListaMercado?> searchListaMercadoById(int listaMercadoId) async {
    await openDB();
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
      result = ListaMercado(
        id: listasMercado[0]['id'],
        userId: listasMercado[0]['userId'],
        custoTotal: listasMercado[0]['custoTotal'],
        data: listasMercado[0]['data'],
        supermercado: listasMercado[0]['supermercado'],
        finalizada: listasMercado[0]['finalizada'] == 1,
        itens: [],
      );

      for (var item in listasMercado) {
        if (item['produtoId'] != null) {
          Produto produto = Produto(
            descricao: item['produtoDescricao'],
            barras: item['produtoBarras'],
            quantidade: item['produtoQuantidade'],
            pendente: item['produtoPendente'] == 1,
            precoAtual: item['produtoPrecoAtual'],
            categoria: item['produtoCategoria'],
            historicoPreco: [],
          );
          result.itens.add(produto);
        }
      }
    }

    return result;
  }

  Future<int> salvarListaMercadoVazia(int userId) async {
    await openDB();

    // Exclui todas as listas de mercado não finalizadas do usuário
    await _database.delete(
      'ListaMercado',
      where: 'userId = ? AND finalizada = 0',
      whereArgs: [userId],
    );

    // Cria um mapa com os valores da ListaMercado
    final listaMercadoMap = {
      'userId': userId,
      'custoTotal': 0.0,
      'data': '',
      'supermercado': 'Lista Não Finalizada',
      'finalizada': 0,
    };

    // Insere a lista de mercado vazia no banco de dados
    int listaMercadoId =
        await _database.insert('ListaMercado', listaMercadoMap);

    return listaMercadoId;
  }

  Future<void> updateListaMercado(ListaMercado listaMercado) async {
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

  Future<void> deleteListaMercado(ListaMercado listaMercado) async {
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
}
