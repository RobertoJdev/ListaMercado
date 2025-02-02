import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:lista_mercado/screens/email_screen.dart';

class UserPreferences {
  static late SharedPreferences _prefs;
  static const String _emailKey = 'user_email';
  static const String _userIdKey = 'user_Id';

  // Método init modificado para ser assíncrono
  static Future<void> init(BuildContext context) async {
    _prefs = await SharedPreferences.getInstance();
    await checkAndGetEmail(context);
    await getUserId(); // Garante a geração do userId no init
  }

  /// Define o e-mail do usuário e o salva no SharedPreferences
  static Future<bool> setEmail(String email) async {
    if (email.isEmpty) return false; // Evita salvar valores inválidos

    bool success = await _prefs.setString(_emailKey, email);
    return success;
  }

  static Future<String> checkAndGetEmail(BuildContext context) async {
    String? email = _prefs.getString(_emailKey);

    if (email == null || email.isEmpty) {
      final String? newEmail = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmailScreen('')),
      );

      if (newEmail != null && newEmail.isNotEmpty) {
        await _prefs.setString(_emailKey, newEmail);
        return newEmail;
      }
    }

    return email ?? ''; // Caso o e-mail seja válido, retorna o e-mail
  }

  static Future<String> getUserId() async {
    if (!_prefs.containsKey(_userIdKey)) {
      return await _generateUserId();
    }
    return _prefs.getString(_userIdKey)!;
  }

  static Future<String> _generateUserId() async {
    final String newUserId =
        Uuid().v4().substring(0, 8); // UUID curto (8 caracteres)
    await _prefs.setString(_userIdKey, newUserId);
    print("Novo userId gerado: $newUserId");
    return newUserId;
  }
}
