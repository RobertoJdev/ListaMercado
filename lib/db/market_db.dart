import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ItemMarketDB {
  late Database _database;

  Future<void> initDB() async {
    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'listMarket.db'),
      onCreate: (db, version) async {
        print('----------------Criação do banco de dados--------------');

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
            historicoPreco TEXT NOT NULL,
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

        // Inserindo uma lista de mercado de teste associada ao usuário
        final listaMercadoId = await db.insert(
          'ListaMercado',
          {
            'userId': 1, // Substitua pelo ID do usuário real
            'custoTotal': 100.0,
            'data': '2023-01-01',
            'supermercado': 'Test Supermarket',
            'finalizada': 0,
          },
        );

        // Inserindo um produto de teste associado à lista de mercado
        final produtoId = await db.insert(
          'Produto',
          {
            'descricao': 'Test Product',
            'barras': '123456789',
            'quantidade': 5,
            'pendente': 1,
            'historicoPreco': '[15.0, 18.0, 20.0]',
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
      },
      version: 1,
    );
  }

  Future<void> insertItem(ListaMercado listaMercado, Produto produto) async {
    await _database.transaction((txn) async {
      final listaMercadoId = await txn.insert(
        'ListaMercado',
        {
          'userId': listaMercado.userId,
          'custoTotal': listaMercado.custoTotal,
          'data': listaMercado.data,
          'supermercado': listaMercado.supermercado,
          'finalizada': listaMercado.finalizada ? 1 : 0,
        },
      );

      final produtoId = await txn.insert(
        'Produto',
        {
          'descricao': produto.descricao,
          'barras': produto.barras,
          'quantidade': produto.quantidade,
          'pendente': produto.pendente ? 1 : 0,
          'historicoPreco': produto.historicoPreco.toString(),
          'precoAtual': produto.precoAtual,
        },
      );

      // Associando o produto à lista de mercado
      await txn.insert(
        'ListaMercadoProduto',
        {
          'listaMercadoId': listaMercadoId,
          'produtoId': produtoId,
        },
      );
    });
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    print('---------***---------Teste get AllItens--------***----------');
    return await _database.rawQuery('''
    SELECT Produto.*,
           ListaMercadoProduto.listaMercadoId,
           ListaMercado.custoTotal,
           ListaMercado.data,
           ListaMercado.supermercado,
           ListaMercado.finalizada
    FROM Produto
    INNER JOIN ListaMercadoProduto ON Produto.id = ListaMercadoProduto.produtoId
    INNER JOIN ListaMercado ON ListaMercadoProduto.listaMercadoId = ListaMercado.id
  ''');
  }

  Future<void> printAllItems() async {
    print('------------------Teste chamada printAllItens------------------');
    final items = await getAllItems();
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
        print('Histórico de Preço: ${productInfo[0]['historicoPreco']}');
        print('Preço Atual: ${productInfo[0]['precoAtual']}');
      }

      print('------------------------------------------------------------');
    }
  }
}
