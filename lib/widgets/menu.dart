import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/email_screen.dart';
import 'package:lista_mercado/util/app_info.dart';
import 'package:lista_mercado/util/user_preferences.dart';
import 'package:lista_mercado/widgets/alerts/donation_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String _userEmail = '';

  Future<void> _loadUserEmail() async {
    //String email = await UserPreferences.checkAndGetEmail(context);
    String email = await UserPreferences.getEmail();
    
    if (mounted) {
      setState(() {
        _userEmail = email;
      });
    }
  }

  Future<void> _updateEmail() async {
    final String? newEmail = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailScreen(_userEmail)),
    );

    if (newEmail != null && newEmail.isNotEmpty) {
      await UserPreferences.setEmail(newEmail);
      if (mounted) {
        setState(() {
          _userEmail = newEmail;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    String urlPoliticas =
        "https://politicadeprivacidadelistademercado.blogspot.com/2024/03/politica-de-privacidade-lista-de-mercado.html";
    String urlDesenvolvedor =
        "https://www.linkedin.com/in/roberto-j-874325144/";

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
            ),
            alignment: Alignment.center,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Image.asset('assets/images/app_logo.png',
                        width: 60, height: 60),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 6, 10, 0),
                    child: Text(
                      'Lista de Mercado',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'E-mail usuário:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  onTap: _updateEmail,
                  title: Text(
                    _userEmail, // Corrigido para usar a variável correta
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.indigo),
            title: const Text('Políticas de Privacidade'),
            onTap: () => abrirUrl(urlPoliticas),
          ),
          const Expanded(child: SizedBox()),
          const Divider(color: Colors.black12),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DonationAlert();
                },
              );
            },
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text('Doe ao desenvolvedor'),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('Versão: ${AppInfo.version}'),
          ),
          ListTile(
            leading: const Icon(Icons.developer_mode),
            onTap: () => abrirUrl(urlDesenvolvedor),
            title: const Text.rich(
              TextSpan(
                text: 'Dev. por: ',
                style: TextStyle(fontSize: 16),
                children: [
                  TextSpan(
                    text: 'Roberto J.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
