import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:lista_mercado/screens/splash_screen.dart';
import 'package:lista_mercado/util/my_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Mercado',
      theme: MyTheme.themeData,
      /* theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ), */
      home: SplashScreen(),
    );
  }
}
