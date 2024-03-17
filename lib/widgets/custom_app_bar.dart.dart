import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String defaultTitle;

  const CustomAppBar(
      {Key? key, this.title, this.defaultTitle = 'Lista de Mercado'})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
      title: title != null
          ? Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          : Text(
              defaultTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
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
}
