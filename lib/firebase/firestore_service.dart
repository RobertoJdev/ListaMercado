import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarListaDeMercado(Map<String, dynamic> listaMercado) async {
    try {
      // Adiciona a lista à coleção "listasDeMercado"
      await _firestore.collection('listasDeMercado').add(listaMercado);
      print("Lista de mercado adicionada com sucesso!");
    } catch (e) {
      print("Erro ao adicionar lista de mercado: $e");
    }
  }
}
