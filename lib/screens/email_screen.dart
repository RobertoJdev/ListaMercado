import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadEmail(); // Carrega o email quando a tela inicia
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');
    if (email != null) {
      setState(() {
        _emailController.text = email; // Preenche o campo com o email salvo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      /*
      appBar: AppBar(
        title: _emailController.text.isEmpty
            ? const Text('Adicionar E-mail')
            : const Text('Modifique seu E-mail'),
      ),
      */
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.deepPurple, // Cor inicial
              Colors.white, // Cor final
            ],
            begin: Alignment.topLeft, // Ponto de início do gradiente
            end: Alignment.center, // Ponto de término do gradiente
          )),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Image.asset(
                    'assets/images/compartilhar.png',
                    width: isKeyboardOpen
                        ? 150
                        : 200, // Reduz o tamanho se o teclado estiver aberto
                    height: isKeyboardOpen
                        ? 150
                        : 200, // Reduz o tamanho se o teclado estiver aberto
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Text(
                    'Compartilhe suas listas de mercado com outros usuários.\n Por favor, insira seu e-mail:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail:',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2.0),
                        ),
                        //prefixIcon: Icon(Icons.email),
                        //suffixIcon: Icon(Icons.email),
                        suffixIconColor: Colors.deepPurple,
                        prefixIconColor: Colors.deepPurple,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um e-mail';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Por favor, insira um e-mail válido';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurple),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: _saveEmail,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: Text('Salvar E-mail'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', _emailController.text.trim());
      // Após salvar o e-mail, redireciona para a tela de listas de mercado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
      );
    }
  }
}
