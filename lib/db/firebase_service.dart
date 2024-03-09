import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_mercado/models/lista_mercado.dart';

class ListaMercadoFirebaseService {
  static late FirebaseFirestore _firestore;
  static late FirebaseAuth _auth;

  static void inicializarFirebase() async {
    await Firebase.initializeApp();
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  static Future<void> salvarListaMercado(ListaMercado listaMercado) async {
    try {
      // Verificar se o usuário está autenticado
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Adicionar a lista de mercado ao Firestore
      await _firestore.collection('listas_mercado').doc(user.email).set({
        'userId': user.uid,
        'data': listaMercado.data,
        'supermercado': listaMercado.supermercado,
        'custoTotal': listaMercado.custoTotal,
        // Adicione outras informações que deseja salvar aqui
      });

      print('Lista de mercado salva com sucesso para o usuário: ${user.email}');
    } catch (error) {
      print('Erro ao salvar lista de mercado: $error');
      throw error;
    }
  }
}
