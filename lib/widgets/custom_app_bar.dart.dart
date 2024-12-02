import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_mercado/firebase/teste_envio_lista.dart';
import 'package:lista_mercado/widgets/alerts/confirm_exit_list.dart';
import 'package:lista_mercado/widgets/calculator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const platform = MethodChannel('openCalculator');
  final String? title;
  final String defaultTitle;
  final bool screenReturn;
  final bool showShareButton;
  final Function()? onSharePressed;

  const CustomAppBar({
    Key? key,
    this.title,
    this.defaultTitle = 'Lista de Mercado',
    this.screenReturn = false,
    this.showShareButton = true,
    this.onSharePressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (showShareButton)
            IconButton(
              onPressed: onSharePressed,
              icon: const Icon(Icons.share),
            ),
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
