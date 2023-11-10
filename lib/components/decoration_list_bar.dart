import 'package:flutter/material.dart';

class DecorationListBar extends StatelessWidget {
  const DecorationListBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
