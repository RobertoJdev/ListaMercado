import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/models/produto.dart';

Future<void> calculator(BuildContext? context) async {
  await showModalBottomSheet(
    context: context!,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
      ),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: const SimpleCalculator(
          theme: CalculatorThemeData(
            //borderWidth: 2,
            //displayColor: Colors.black,
            displayStyle: TextStyle(
              //height: 80,
              fontWeight: FontWeight.w600,
              fontSize: 80,
            ),
          ),
        ),
      );
    },
  );
}
