import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_mercado/models/categoria.dart';
import 'package:lista_mercado/models/lista_mercado.dart';
import 'package:lista_mercado/models/produto.dart';
import 'package:lista_mercado/util/lista_mercado_json_converter.dart';
import 'package:url_launcher/url_launcher.dart';



void compartilharLista(
    {BuildContext? context, required ListaMercado lista}) async {
  // Converta a ListaMercado em uma string JSON
  String jsonString = ListaMercadoJsonConverter.toJsonString(lista);

  // Compartilhe via WhatsApp
  String whatsAppUrl = 'whatsapp://send?text=$jsonString';

  // Abra o compartilhamento via WhatsApp
  //await launch(whatsAppUrl);

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context!,
    builder: (BuildContext content) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      'Edite ou confirme o produto.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
