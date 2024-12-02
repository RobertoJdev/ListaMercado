import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseTestScreen extends StatefulWidget {
  @override
  _FirebaseTestScreenState createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  bool _isLoading = true;
  String _statusMessage = "Iniciando teste de conexão com o Firebase...";

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    try {
      // Inicializa o Firebase
      await Firebase.initializeApp();
      setState(() {
        _isLoading = false;
        _statusMessage = "Conexão com o Firebase estabelecida com sucesso! 🎉";
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Erro ao conectar com o Firebase: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste de Conexão Firebase"),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Mostra carregamento enquanto testa
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _statusMessage.contains("sucesso")
                        ? Icons.check_circle
                        : Icons.error,
                    color: _statusMessage.contains("sucesso")
                        ? Colors.green
                        : Colors.red,
                    size: 60,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}
