import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_share/flutter_share.dart';

class FileShare {
  static Future<void> shareFileSearch(
      BuildContext context, String fileName) async {
    try {
      // Obtém o diretório de documentos do aplicativo
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String filePath = '${appDocumentsDirectory.path}/$fileName';

      // Verifica se o arquivo existe
      File file = File(filePath);
      if (!(await file.exists())) {
        throw Exception('O arquivo $fileName não foi encontrado.');
      }

      // Compartilha o arquivo usando o FlutterShare
      await FlutterShare.shareFile(
        title: 'Compartilhar arquivo',
        text: 'Escolha um aplicativo para compartilhar o arquivo:',
        filePath: filePath,
        chooserTitle: 'Compartilhar arquivo via',
      );
    } catch (e) {
      print('Erro ao compartilhar arquivo: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao compartilhar arquivo: $e'),
      ));
    }
  }

  static Future<void> shareFile(File file, String fileName) async {
    try {
      if (await file.exists()) {
        await FlutterShare.shareFile(
          title: 'Compartilhar arquivo',
          filePath: file.path,
          text: 'Compartilhando o arquivo $fileName',
        );
      } else {
        throw 'Arquivo não encontrado: $fileName';
      }
    } catch (e) {
      throw 'Erro ao compartilhar o arquivo: $e';
    }
  }
}
