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

  //final Function salvarListaTemp;

  const CustomAppBar({
    Key? key,
    this.title,
    this.defaultTitle = 'Lista de Mercado',
    this.screenReturn = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  get context => null;
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: kToolbarHeight, // Definindo a altura da AppBar
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.deepPurpleAccent,
          ],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: screenReturn
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ConfirmExitDialog();
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
            padding: const EdgeInsets.only(right: 10),
            onPressed: () {
              calculator(context);
            },
            icon: const Icon(
              Icons.calculate_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
