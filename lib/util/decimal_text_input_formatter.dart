import 'package:flutter/services.dart';

// Formatador personalizado que adiciona ponto decimal automaticamente
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Limita os caracteres a números e remove pontos existentes
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Adiciona automaticamente o ponto decimal
    if (newText.isNotEmpty) {
      // Insere o ponto antes dos dois últimos dígitos
      double value = double.parse(newText) / 100;

      // Formata o valor com duas casas decimais
      newText = value.toStringAsFixed(2);
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
