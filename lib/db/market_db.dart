import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class MarketDatabase {
  late Database _database;

  Future<void> open() async {
    final databasePath = await getDatabasesPath();
    final databasePathWithName = join(databasePath, 'my_database.db');
    bool databaseExists = await File(databasePathWithName).exists();

    try {
      _database = await openDatabase(databasePathWithName);
    } on DatabaseException {
      if (!databaseExists) {
        _database = await openDatabase(
          databasePathWithName,
          version: 1,
          onCreate: (db, version) {
            db.execute('''
              CREATE TABLE item_market(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                quant INTEGER NOT NULL,
                last_price REAL NOT NULL,
                historic_price TEXT,
                pendent INTEGER NOT NULL
              )
            ''');
          },
        );
      } else {
        rethrow; // Reenvie a exceção se ocorrer um erro diferente
      }
    }
  }

  Future<int> insertItem(Map<String, dynamic> itemData) async {
    return await _database.insert('item_market', itemData);
  }

  Future<int> deleteItem(int id) async {
    return await _database
        .delete('item_market', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getItem(int id) async {
    final List<Map<String, dynamic>> results =
        await _database.query('item_market', where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return results[0];
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    final List<Map<String, dynamic>> results =
        await _database.query('item_market');
    return results;
  }

  Future<void> printAllItems() async {
    final allItems = await getAllItems();
    allItems.forEach((item) {
      print(
          'Item: ${item['name']}'); // Altere para refletir a estrutura do seu item
    });
  }

  void populateDatabaseWithExampleData() {}
}
