import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1), // Por exemplo, aguarde 2 segundos
      () {
        // Navegue para a próxima tela
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        );
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Adicione o logotipo ou o texto do seu aplicativo aqui
            Image.asset('assets/images/app_logo.png', width: 100, height: 100),
            const SizedBox(height: 20),
            const Text(
              'Lista de Mercado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
