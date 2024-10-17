import '/models/lista_mercado.dart';
import '/models/produto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MarketDB {
  late Database _database;

  static void populateDB(ListaMercado listaMercado) {
    MarketDB itemMarketDB = MarketDB();
    itemMarketDB.novaListaMercado(listaMercado);
  }

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
        // Criação inicial do banco de dados
        await _createTables(db);
        await _insertTestMarketData(db);
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Atualização da versão 1 para a versão 2
          await _upgradeToVersion2(db);
        }
      },
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
    );
    ''');

    await db.execute('''
    CREATE TABLE HistoricoPreco (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      produtoId INTEGER NOT NULL,
      preco REAL NOT NULL,
      data TEXT NOT NULL,
      FOREIGN KEY (produtoId) REFERENCES Produto(id) ON DELETE CASCADE
    );
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

  // Função para migrar o banco de dados da versão 1 para a versão 2
  Future<void> _upgradeToVersion2(Database db) async {
    // Criação da nova tabela HistoricoPreco
    await db.execute('''
    CREATE TABLE HistoricoPreco (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      produtoId INTEGER NOT NULL,
      preco REAL NOT NULL,
      data TEXT NOT NULL,
      FOREIGN KEY (produtoId) REFERENCES Produto(id) ON DELETE CASCADE
    )
  ''');
  }

  Future<void> _insertTestMarketData(Database db) async {
    List<Produto> itensMercado = Produto.generateMultiProdutosExemplo();
    ListaMercado lista = ListaMercado.generateListaMercadoExemplo(itensMercado);
    final userId = 1;

    for (var element in lista.itens) {
      lista.custoTotal += element.precoAtual;
    }

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
          'pendente': element.pendente ? 1 : 0, // Convertendo para inteiro
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

      // Inserindo o histórico de preços para cada produto
      // Aqui você pode adicionar uma lógica para definir o histórico
      // de preços, assumindo que você tem algum histórico padrão.
      // Neste exemplo, estamos apenas inserindo o preço atual no histórico.
      if (element.precoAtual != null && element.precoAtual > 0) {
        await db.insert(
          'HistoricoPreco',
          {
            'produtoId': produtoId,
            'preco': element.precoAtual,
            'data': DateTime.now().toIso8601String(), // Armazena a data atual
          },
        );
      }
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
    print(
        "============================================= CHAMADA NOVA LISTA MERCADO ==============================================================================");
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
      printHistoricoPreco(produto, "NOVA LISTA MERCADO");
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
    print(
        " ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨chamada getAlllista mercado ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨ ");

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
          userId: item['userId'],
          custoTotal: item['custoTotal'],
          data: item['data'],
          supermercado: item['supermercado'],
          finalizada: item['finalizada'] == 1,
          itens: [],
        );
        result.add(currentLista);
        currentProdutoId = -1; // Reseta o produto ao mudar a lista
      }

      // Se o produto mudar
      if (item['produtoId'] != null && item['produtoId'] != currentProdutoId) {
        currentProdutoId = item['produtoId'];
        currentProduto = Produto(
          descricao: item['produtoDescricao'],
          barras: item['produtoBarras'],
          quantidade: item['produtoQuantidade'],
          pendente: item['produtoPendente'] == 1,
          precoAtual: item['produtoPrecoAtual'],
          categoria: item['produtoCategoria'],
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

  Future<ListaMercado?> searchListaMercadoById(int listaMercadoId) async {
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
        custoTotal: listasMercado[0]['custoTotal'],
        data: listasMercado[0]['data'],
        supermercado: listasMercado[0]['supermercado'],
        finalizada: listasMercado[0]['finalizada'] == 1,
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

    printHistoricoPreco(result!.itens[0], "searchListaMercadoById");

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
    print(
        "%%%%%%%%%%%%%%%%%%%%%% teste de updade lista mercado %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
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
            'HistoricoPreco', // Supondo que você tenha uma tabela de histórico de preços
            {
              'produtoId': produtoId,
              'preco': produto.precoAtual,
              'data': DateTime.now().toIso8601String(), // Armazena a data atual
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

  Future<void> deleteProdutoFromLista(ListaMercado listaMercado, Produto produto) async {
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

  Future<int> finalizarListaMercado(ListaMercado listaMercado) async {
    printListaMercadoInfo(listaMercado);

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
      await pesquisarHistoricoPreco(produtoId);
    }

    return listaMercadoId;
  }

  Future<void> pesquisarHistoricoPreco(int produtoId) async {
    await openDB();

    // Consulta o histórico de preços para o produto especificado
    List<Map<String, dynamic>> historico = await _database.query(
      'HistoricoPreco',
      where: 'produtoId = ?',
      whereArgs: [produtoId],
      orderBy: 'data ASC', // Ordena os resultados pela data de inserção
    );

    if (historico.isNotEmpty) {
      print("Histórico de preços para o produto $produtoId:");
      for (var entry in historico) {
        print("Preço: ${entry['preco']}, Data: ${entry['data']}");
      }
    } else {
      print("Nenhum histórico encontrado para o produto $produtoId.");
    }
  }

  static void printListaMercadoInfo(ListaMercado listaMercado) {
    print(
        ' -------------------------- Informações da Lista de Mercado: -------------------------- ');

    for (var produto in listaMercado.itens) {
      print(
        'Item: ${produto.descricao}, Preço Atual: ${produto.precoAtual}, Histórico de Preços: ${[
          ...produto.historicoPreco
        ]}',
      );
    }
  }

  Future<void> printHistoricoPreco(Produto produto, String nomeFuncao) async {
// Imprimir o histórico de preços do produto

    print(
        '++++++++++++++++++++++++++++ $nomeFuncao ++++++++++++++++++++++++++++');

    print('Histórico de Preços para o produto ${produto.descricao}:');

    for (var price in produto.historicoPreco) {
      print('Preço: $price');
    }
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
    print(
        '--------------------------------------------------------------------------------------------------');
  }
}
