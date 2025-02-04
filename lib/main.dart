import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lista_mercado/db/market_db.dart';
import 'package:lista_mercado/screens/splash_screen.dart';
import 'package:lista_mercado/my_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final MarketDB db = MarketDB();
  bool isLoading = true;
  await db.initDB();
  await db.openDB();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
