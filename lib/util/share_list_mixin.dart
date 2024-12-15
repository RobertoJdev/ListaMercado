import 'package:lista_mercado/firebase/enviar_lista_firestore.dart';
import 'package:lista_mercado/widgets/modals/confirm_share_email_screen.dart';
import 'package:path/path.dart';

mixin ShareListMixin {
/*   void compartilharLista() async {
    String? shareEmail = await _abrirModalCompartilharEmail(context);
    if (shareEmail!.isNotEmpty) {
      widget.listaMercado.sharedWithEmail = shareEmail;
      try {
        // Chama a função para enviar os dados ao Firestore
        await enviarListaParaFirestore(widget.listaMercado);
        print("Lista enviada com sucesso!");
      } catch (e) {
        print("Erro ao compartilhar lista: $e");
      }
    }
  }

  _abrirModalCompartilharEmail(BuildContext context) async {
    final email = await confirmShareEmailScreen(context: context);
    if (email != null) {
      return email;
    }
  } */
}
