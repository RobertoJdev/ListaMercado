import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_mercado/models/lista_mercado.dart';

Future<void> enviarListaParaFirestore(ListaMercado listaMercado) async {
  try {
    // Referência à coleção "listasMercado" no Firestore
    CollectionReference listasMercado =
        FirebaseFirestore.instance.collection('listasMercado');

    // Preparar os dados da lista no formato Map<String, dynamic>
    Map<String, dynamic> listaData = listaMercado.toMap();

    // Adicionar a lista no Firestore
    DocumentReference documentReference = await listasMercado.add(listaData);

    print(
        "Teste modulo firestore -- Lista enviada com sucesso. ID do documento: ${documentReference.id}");
  } catch (e) {
    print("Teste modulo firestore -- Erro ao enviar a lista: $e");
  }
}
