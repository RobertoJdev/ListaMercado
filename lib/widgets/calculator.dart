import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

Future<void> calculator(BuildContext? context) async {
  await showModalBottomSheet(
    context: context!,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(0.0),
        topRight: Radius.circular(0.0),
      ),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: const SimpleCalculator(
          theme: CalculatorThemeData(
            commandColor: Color.fromRGBO(209, 196, 233, 1),
            borderColor: Colors.black26,
            //borderWidth: 2,
            //displayColor: Colors.black,
            displayStyle: TextStyle(
              color: Colors.deepPurple,
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
