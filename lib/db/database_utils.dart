import 'package:sqflite/sqflite.dart';

class DatabaseUtils {
  // Método estático para verificar a estrutura de uma tabela
  static Future<void> verificarEstruturaTabela(Database db, String tableName) async {
    try {
      // Executa o PRAGMA para verificar a estrutura da tabela
      final List<Map<String, dynamic>> resultado =
          await db.rawQuery('PRAGMA table_info($tableName);');

      // Exibe os resultados no console
      print('Estrutura da tabela "$tableName":');
      for (var coluna in resultado) {
        print('Coluna: ${coluna['name']}, Tipo: ${coluna['type']}, '
              'NotNull: ${coluna['notnull']}, PK: ${coluna['pk']}');
      }
    } catch (e) {
      print('Erro ao verificar a estrutura da tabela "$tableName": $e');
    }
  }
}
