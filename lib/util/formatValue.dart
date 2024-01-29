import 'package:intl/intl.dart';

class FortmatValue {
  static String formatDouble(double value) {
    // Formatar o número com vírgula como separador decimal
    final formatter = NumberFormat("#,##00.0", "pt_BR");

    // Remover a parte decimal se não houver fração
    String formattedValue = formatter.format(value);
    if (formattedValue.endsWith(',0')) {
      formattedValue = formattedValue.replaceAll(',0', '');
    }


    return formattedValue;
  }
}
