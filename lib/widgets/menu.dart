import 'package:flutter/material.dart';
import 'package:lista_mercado/util/app_info.dart';
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
          Container(
            alignment: Alignment.center,
            color: Colors.deepPurple,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Image.asset('assets/images/app_logo.png',
                      width: 60, height: 60),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10,6,10,0),
                  child: Text(
                    'Lista de Mercado',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
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
          const Divider(
            color: Colors.black12,
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('Versão: ${AppInfo.version}'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ListTile(
              leading: const Icon(Icons.developer_mode),
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
