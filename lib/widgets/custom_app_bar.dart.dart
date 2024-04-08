import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:lista_mercado/widgets/alerts/confirm_exit_list.dart';
import 'package:lista_mercado/widgets/calculator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const platform = MethodChannel('openCalculator');
  final String? title;
  final String defaultTitle;
  final bool screenReturn;

  const CustomAppBar(
      {Key? key,
      this.title,
      this.defaultTitle = 'Lista de Mercado',
      this.screenReturn = false})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  get context => null;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
      leading: screenReturn
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmExitDialog();
                  },
                );
              },
            )
          : null,
      title: title != null
          ? Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            )
          : Text(
              defaultTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
      actions: [
        IconButton(
          onPressed: () {
            calculator(context);
          },
          icon: const Icon(
            Icons.calculate_outlined,
          ),
        ),
      ],

/*
        GestureDetector(
          onTap: () {
            calculator(context);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Icon(
              Icons.calculate_outlined,
            ),
          ),
        )
*/
      /*actions: [
          const Icon(
            Icons.bar_chart_outlined,
            color: Colors.grey,
          ),
          GestureDetector(
            child: const Icon(
              Icons.share,
              color: Colors.grey,
            ),
            onTap: () {
              //PopUpItemConfirm.showAlertDialog(context);
            },
          ),
          const Padding(padding: EdgeInsets.only(right: 10))
        ],*/
    );
  }

/*
  static Future<void> _openCalculator() async {
    try {
      await platform.invokeMethod('open');
    } on PlatformException catch (e) {
      print("Erro ao abrir a calculadora: '${e.message}'.");
    }
  }
  */
}
