import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  static Future<void> saveToFile(String fileName, String jsonString) async {
    try {
      // Obtém o diretório de documentos do dispositivo
      Directory directory = await getApplicationDocumentsDirectory();
      //print('-------------------- teste de diretorio : $directory');
      // Cria o arquivo no diretório de documentos
      File file = File('${directory.path}/$fileName');

      // Escreve a string JSON no arquivo
      await file.writeAsString(jsonString);
      //print('-------------------- teste de salvar arquivo--------------------');
    } catch (e) {
      print('-------------------- Erro ao salvar o arquivo: $e');
      // Lidar com o erro, se necessário
    }
  }

  static Future<File> salvarEmArquivoArquivo(
      String fileName, String content) async {
    try {
      // Obtém o diretório de documentos do dispositivo
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String filePath = '${documentsDirectory.path}/$fileName';

      // Cria o arquivo no diretório de documentos
      File file = File(filePath);

      // Escreve o conteúdo no arquivo
      await file.writeAsString(content);
      print('Arquivo salvo com sucesso em: $filePath');

      return file;
    } catch (e) {
      // Trate qualquer erro que possa ocorrer ao salvar o arquivo
      throw 'Erro ao salvar o arquivo: $e';
    }
  }

  static void openAndPrintFileContent(String fileName) async {
    try {
      // Obtém o diretório de documentos do aplicativo
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String filePath = '${appDocumentsDirectory.path}/$fileName';

      // Abre o arquivo
      File file = File(filePath);
      if (await file.exists()) {
        // Lê o conteúdo do arquivo
        String contents = await file.readAsString();

        // Imprime o conteúdo do arquivo
        print('Conteúdo do arquivo $fileName:');
        print(contents);
      } else {
        print('O arquivo $fileName não foi encontrado.');
      }
    } catch (e) {
      print('Erro ao abrir o arquivo: $e');
    }
  }
}
