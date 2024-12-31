import 'package:flutter/material.dart';
import 'package:lista_mercado/widgets/modals/confirm_share_email_screen.dart';

// mixin CompartilharListaMixin {
//   Future<void> compartilharLista({
//     required BuildContext context,
//     required dynamic listaMercado,
//     required Future<void> Function(dynamic) enviarListaParaFirestore,
//   }) async {
//     String? shareEmail = await _abrirModalCompartilharEmail(context);
//     if (shareEmail != null && shareEmail.isNotEmpty) {
//       listaMercado.sharedWithEmail = shareEmail;
//       listaMercado.isShared = true;
//       try {
//         // Chama a função para enviar os dados ao Firestore
//         await enviarListaParaFirestore(listaMercado);
//         print("Lista enviada com sucesso!");
//       } catch (e) {
//         print("Erro ao compartilhar lista: $e");
//       }
//     }
//   }

//   Future<String?> _abrirModalCompartilharEmail(BuildContext context) async {
//     final email = await confirmShareEmailScreen(context: context);
//     return email;
//   }
// }

