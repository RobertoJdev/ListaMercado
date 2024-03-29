import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    String urlPoliticas =
        "https://politicadeprivacidadelistademercado.blogspot.com/2024/03/politica-de-privacidade-lista-de-mercado.html";
    String urlDesenvolvedor =
        "https://www.linkedin.com/in/roberto-j-874325144/";
    String notasVersao = "";
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        //padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            //------------user image section  and other deatils //
            child: ListTile(
              title: Text(
                'Usuario e email',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Políticas de Privacidade'),
            onTap: () {
              abrirUrl(urlPoliticas);
            },
          ),
          const Expanded(
            flex: 1,
            child: ListTile(
              title: Text(''),
              onTap: null,
            ),
          ),
          const Divider(),
          const ListTile(title: Text('Versão 1.0.0')),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ListTile(
              onTap: () {
                abrirUrl(urlDesenvolvedor);
              },
              title: const Text('Dev. por: Roberto de Jesus'),
            ),
          ),
        ],
      ),
    );
  }

  void abrirUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Ocorreram erros na chamada de função URL');
      throw 'Could not launch $url';
    }
  }
}
