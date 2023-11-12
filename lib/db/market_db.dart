import 'package:lista_mercado/models/item_market.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ItemMarketDB {
  late Database _database;

  Future<void> initDB() async {
    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'listMarket.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT,
            name TEXT,
            quant INTEGER,
            last_price REAL,
            historic_price TEXT,
            pendent INTEGER
          )
          ''');
      },
      version: 1,
    );

    // Inserindo um item de teste
    await _database.insert(
      'items',
      {
        'uuid': 'test_uuid',
        'name': 'Test Item',
        'quant': 10,
        'last_price': 20.0,
        'historic_price': '15.0,18.0,20.0',
        'pendent': 1,
      },
    );
  }

  Future<void> insertItem(ItemMarket item) async {
    Map<String, dynamic> toMap() {
      return {
        'uuid': item.uuid,
        'name': item.name,
        'quant': item.quant,
        'last_price': item.last_price,
        'historic_price': item.historic_price.join(','),
        'pendent': item.pendent ? 1 : 0,
      };
    }

    await _database.insert(
      'items',
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    return await _database.query('items');
  }

  Future<void> printAllItems() async {
    final items = await getAllItems();
    for (var item in items) {
      print('ID: ${item['id']}');
      print('UUID: ${item['uuid']}');
      print('Name: ${item['name']}');
      print('Quantity: ${item['quant']}');
      print('Last Price: ${item['last_price']}');
      print('Historic Price: ${item['historic_price']}');
      print('Pendent: ${item['pendent']}');
      print('---------------------------------');
    }
  }
}
