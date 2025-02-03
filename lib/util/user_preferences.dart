import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:lista_mercado/screens/email_screen.dart';

class UserPreferences {
  static late SharedPreferences _prefs;
  static const String _emailKey = 'user_email';
  static const String _userIdKey = 'user_Id';

  // Inicializa as preferências e verifica o e-mail
  static Future<void> init(BuildContext context) async {
    _prefs = await SharedPreferences.getInstance();
    //await checkAndGetEmail(context);
    await openEmailScreen(context);
    await getUserId(); // Garante a geração do userId no init
  }

  /// Define o e-mail do usuário e salva no SharedPreferences
  static Future<bool> setEmail(String email) async {
    if (email.isEmpty) return false; // Evita salvar valores inválidos
    return await _prefs.setString(_emailKey, email);
  }

  /// Abre a tela de e-mail e salva o e-mail fornecido, sem retornar nada
  static Future<void> openEmailScreen(BuildContext context) async {
    final String? newEmail = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailScreen('')),
    );

    if (newEmail != null && newEmail.isNotEmpty) {
      await setEmail(newEmail);
    }
  }

  /// Verifica se há um e-mail salvo. Se não houver, abre a tela para fornecimento.
  static Future<void> checkAndGetEmail(BuildContext context) async {
    String? email = _prefs.getString(_emailKey);
    if (email == null || email.isEmpty) {
      await openEmailScreen(context);
    }
  }

  /// Obtém o e-mail salvo, retornando uma string vazia se não houver e-mail salvo
  static Future<String> getEmail() async {
    return _prefs.getString(_emailKey) ?? '';
  }

  static Future<String> getUserId() async {
    if (!_prefs.containsKey(_userIdKey)) {
      return await _generateUserId();
    }
    return _prefs.getString(_userIdKey)!;
  }

  static Future<String> _generateUserId() async {
    final String newUserId = Uuid().v4().substring(0, 8); // UUID curto (8 caracteres)
    await _prefs.setString(_userIdKey, newUserId);
    print("Novo userId gerado: $newUserId");
    return newUserId;
  }
}
