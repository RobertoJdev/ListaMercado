import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.deepPurple, // Cor de destaque do tema
    scaffoldBackgroundColor: Colors.deepOrange,
    cardColor: Colors.deepOrange,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 50),
      bodyMedium: TextStyle(fontSize: 50),
      bodySmall: TextStyle(fontSize: 50),
      displayLarge: TextStyle(fontSize: 50),
      displayMedium: TextStyle(fontSize: 50),
      displaySmall: TextStyle(fontSize: 50),
      headlineLarge: TextStyle(fontSize: 50),
      headlineMedium: TextStyle(fontSize: 50),
      headlineSmall: TextStyle(fontSize: 50),
      labelLarge: TextStyle(fontSize: 50),
      labelMedium: TextStyle(fontSize: 50),
      labelSmall: TextStyle(fontSize: 50),
      titleLarge: TextStyle(fontSize: 50),
      titleMedium: TextStyle(fontSize: 50),
      titleSmall: TextStyle(fontSize: 50),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyle(
        color: Colors.deepPurple, // Cor do rótulo do campo
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurpleAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
    ),

    //accentColor: Colors.deepPurpleAccent,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.deepPurpleAccent),
  );

  static const TextStyle myTextFieldStyleInputText = TextStyle(
    fontSize: 50,
    // Adicione mais configurações de estilo conforme necessário
  );
}
