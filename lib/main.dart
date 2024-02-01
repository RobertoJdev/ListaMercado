import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:lista_mercado/screens/splash_screen.dart';
=======
import 'package:lista_mercado/screens/activelist.dart';
>>>>>>> fe0d4d11418a8e542fd00e7a732347feef6bc5bf

void main() {
  runApp(const MyApp());
}

<<<<<<< HEAD
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
=======
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
>>>>>>> fe0d4d11418a8e542fd00e7a732347feef6bc5bf
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple List Mercado',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
<<<<<<< HEAD
      home: SplashScreen(),
=======
      home: const ActiveList(),
>>>>>>> fe0d4d11418a8e542fd00e7a732347feef6bc5bf
    );
  }
}
