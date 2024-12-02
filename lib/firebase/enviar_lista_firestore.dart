import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_mercado/models/lista_mercado.dart';

Future<void> enviarListaParaFirestore(ListaMercado listaMercado) async {
  try {
    // Referência à coleção "listasMercado" no Firestore
    CollectionReference listasMercado =
        FirebaseFirestore.instance.collection('listasMercado');

    // Preparar os dados da lista no formato Map<String, dynamic>
    Map<String, dynamic> listaData = {
      'userId': listaMercado.userId,
      'userEmail': listaMercado.userEmail,
      'isShared': listaMercado.isShared,
      'sharedWithEmail': listaMercado.sharedWithEmail,
      'custoTotal': listaMercado.custoTotal,
      'data': listaMercado.data,
      'supermercado': listaMercado.supermercado,
      'finalizada': listaMercado.finalizada,
      'createdAt': listaMercado.createdAt,
      'updatedAt': listaMercado.updatedAt,
      'isSynced': listaMercado.isSynced,
      // Transformar os produtos em uma lista de mapas
      'itens': listaMercado.itens
          .map((produto) => {
                'descricao': produto.descricao,
                'barras': produto.barras,
                'quantidade': produto.quantidade,
                'pendente': produto.pendente,
                'precoAtual': produto.precoAtual,
                'categoria': produto.categoria,
              })
          .toList(),
    };

    // Adicionar a lista no Firestore
    DocumentReference documentReference = await listasMercado.add(listaData);

    print("Lista enviada com sucesso. ID do documento: ${documentReference.id}");
  } catch (e) {
    print("Erro ao enviar a lista: $e");
  }
}
