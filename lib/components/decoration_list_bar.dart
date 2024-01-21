import 'package:flutter/material.dart';

class DecorationListBar extends StatelessWidget {
  final bool isListMercado;

  const DecorationListBar({Key? key, this.isListMercado = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isListMercado)
          Container(
            color: Colors.deepPurple,
            height: 2,
            width: MediaQuery.of(context).size.width,
          )
        else
          Row(
            children: [
              Container(
                color: Colors.deepPurple,
                height: 2,
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
/*
          Row(
            children: [
              Container(
                color: Colors.amber,
                height: 2,
                width: MediaQuery.of(context).size.width / 2,
              ),
              Container(
                color: Colors.green,
                height: 2,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ],
          )
*/
      ],
    );
  }
}
