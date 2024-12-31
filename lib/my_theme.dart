import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MyTheme {
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.deepPurple, // Cor de destaque do tema
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textTheme: const TextTheme(
        //bodyLarge: TextStyle(fontSize: 50),
        //bodyMedium: TextStyle(fontSize: 50),
        //bodySmall: TextStyle(fontSize: 50),
        //displayLarge: TextStyle(fontSize: 50),
        //displayMedium: TextStyle(fontSize: 50),
        //displaySmall: TextStyle(fontSize: 50),
        //headlineLarge: TextStyle(fontSize: 50),
        //headlineMedium: TextStyle(fontSize: 50),
        //headlineSmall: TextStyle(fontSize: 50),
        labelLarge: TextStyle(fontSize: 16), //utilizado nos botões
        //labelMedium: TextStyle(fontSize: 50),
        //labelSmall: TextStyle(fontSize: 50),
        titleLarge: TextStyle(fontSize: 22) //utilizado nos titulos dos bars,
        //titleMedium: TextStyle(fontSize: 50),
        //titleSmall: TextStyle(fontSize: 50),
        ),

/*     dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(
        color: Colors.red,
        fontSize: 5,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.amber,
      ),
    ),
       */

    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        activeIndicatorBorder: BorderSide(color: Colors.deepPurpleAccent),
        enabledBorder: InputBorder.none,
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(18),
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
        borderSide: BorderSide(color: Colors.white),
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

  // Style utilizado na etiqueta da categoria do produto em pendente e confirmado.
  static const TextStyle myTextStyleCategoryProduct = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  // Style utilizado na descrição de cada item em lista mercado e produto de pendente e confirmado.
  static const TextStyle myTextStyleDescriptionItem = TextStyle(
    //fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  // Style utilizado na quantidade dos item em Pendente e Confirmado.
  static const TextStyle myTextStyleQuantItem = TextStyle(
    fontWeight: FontWeight.w500,
  );

  // Style utilizado nos valores em ListaMercado e Itens confirmado com valor maior que o histórico.
  static const TextStyle myTextStylePriceUp = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.red,
  );

  // Style utilizado nos valores em ListaMercado e Itens confirmado com valor maior que o histórico.
  static const TextStyle myTextStylePriceDown = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.green,
  );

  // Style utilizado nos valores em ListaMercado e Itens pendent e confirmado.
  static const TextStyle myTextStylePriceNotDefined = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.grey,
  );

  // Style utilizado nos valores em ListaMercado e Itens pendent e confirmado.
  static const TextStyle myTextStylePrice = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  // Style utilizado nos histórico dos valores em ListaMercado e Itens pendent e confirmado.
  static const TextStyle myTextStylPricePrevious = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.blue,
  );

  // Style utilizado nas datas das listas de mercado.
  static const TextStyle myTextStyleDateListMarket = TextStyle(
    fontWeight: FontWeight.normal,
  );

  // Style utilizado nos títulos dos modais.
  static const TextStyle myTextStyleTitleModal = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  // Style utilizado nos DropDownButton.
  static const TextStyle myTextStyleDropDownButton = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static ButtonStyle chavePixButton = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
    foregroundColor: WidgetStateProperty.all(Colors.white),
  );

  static const EdgeInsets myCustomEdgeInsetsSpaceExtern =
      EdgeInsets.only(bottom: 5);

  static const EdgeInsets myCustomEdgeInsetsItemSpaceIntern =
      EdgeInsets.symmetric(horizontal: 10, vertical: 13);

  static const EdgeInsets myCustomEdgeInsetsItemSpaceInternRight =
      EdgeInsets.only(right: 2);

  static const EdgeInsets myCustomEdgeInsetsItemSpaceInternRight2 =
      EdgeInsets.only(right: 6);

  static const EdgeInsets myCustomEdgeInsetsItemPrice =
      EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 12);

  static const EdgeInsets myCustomEdgeInsetsItemPriceConfirmed =
      EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 5);

  static const EdgeInsets myCustomEdgeInsetsItemSpaceInternCategoryProduct =
      EdgeInsets.symmetric(horizontal: 6);

  static const EdgeInsets myCustomEdgeInsetsTitleModal =
      EdgeInsets.fromLTRB(0, 30, 0, 10);

  static const EdgeInsets myCustomEdgeInsetsTextFildItensModal =
      EdgeInsets.fromLTRB(20, 4, 20, 4);

  static const EdgeInsets myCustomEdgeInsetsButtomModal =
      EdgeInsets.symmetric(vertical: 10);

  static Color? modalColorBackground = Colors.grey[200];

  static Color? alertColorBackground = Colors.white;
}
