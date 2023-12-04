import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
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
        print('----------------Criação do banco de dados--------------');
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
        quantidade INTEGER NOT NULL,
        pendente INTEGER NOT NULL,
        precoAtual REAL NOT NULL
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
    final userId = 1;

    // Inserindo uma lista de mercado de teste associada ao usuário
    final listaMercadoId = await db.insert(
      'ListaMercado',
      {
        'userId': userId,
        'custoTotal': 100.0,
        'data': '2023-01-02',
        'supermercado': 'Supermarket',
        'finalizada': 1,
      },
    );

    for (var i = 0; i < 3; i++) {
      await db.insert(
        'ListaMercado',
        {
          'userId': userId,
          'custoTotal': 200.0,
          'data': '2024-01-01',
          'supermercado': 'Supermarket $i',
          'finalizada': 1,
        },
      );
    }

    // Inserindo um produto de teste associado à lista de mercado
    final produtoId = await db.insert(
      'Produto',
      {
        'descricao': 'Test Product',
        'barras': '123456789',
        'quantidade': 5,
        'pendente': 1,
        'precoAtual': 20.0,
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

  Future<void> insertItem(ListaMercado listaMercado, Produto produto) async {
    await openDB();
    await _database.transaction((txn) async {
      // ... (o restante do seu código de inserção de itens)
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
    print('---------***---------Teste get AllItens--------***----------');
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
    print('------------------------------------------------------------');
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

    print('Todas as listas de Mercado:');
    todasListas.forEach((item) => print(item));

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
           Produto.precoAtual as produtoPrecoAtual
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
          historicoPreco: [],
        );
        currentLista!.itens.add(produto);
      }
    }
    return result;
  }
}
