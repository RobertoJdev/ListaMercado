import 'package:lista_mercado/firebase/enviar_lista_firestore.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';

void testarEnvioLista() {
  ListaMercado listaTeste = ListaMercado(
    userId: 'user123',
    userEmail: 'user123@email.com',
    isShared: true,
    sharedWithEmail: 'compartilhado@email.com',
    custoTotal: 120.50,
    data: '2024-11-25',
    supermercado: 'Supermercado Teste',
    finalizada: false,
    itens: [
      Produto(
        descricao: 'Arroz',
        barras: '',
        quantidade: 2,
        pendente: false,
        precoAtual: 20.00,
        categoria: 'Alimentos', historicoPreco: [],

      ),
      Produto(
        descricao: 'Feijão',
        barras: '',
        quantidade: 1,
        pendente: true,
        precoAtual: 10.00,
        categoria: 'Alimentos', historicoPreco: [],

      ),
    ],
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
  );

  enviarListaParaFirestore(listaTeste);
}
