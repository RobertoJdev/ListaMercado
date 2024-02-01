import 'package:flutter/material.dart';

class DecorationListBar extends StatelessWidget {
<<<<<<< HEAD
  final bool isListMercado;

  const DecorationListBar({Key? key, this.isListMercado = false})
      : super(key: key);
=======
  const DecorationListBar({super.key});
>>>>>>> fe0d4d11418a8e542fd00e7a732347feef6bc5bf

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
<<<<<<< HEAD
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
=======
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
>>>>>>> fe0d4d11418a8e542fd00e7a732347feef6bc5bf
      ],
    );
  }
}
