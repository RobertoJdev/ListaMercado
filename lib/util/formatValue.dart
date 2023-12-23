import 'package:intl/intl.dart';

class FortmatValue {
  static String formatDouble(double value) {
    // Formatar o número com vírgula como separador decimal
    final formatter = NumberFormat("#,##0.00", "pt_BR");

    // Remover a parte decimal se não houver fração
    String formattedValue = formatter.format(value);
    if (formattedValue.endsWith(',00')) {
      formattedValue = formattedValue.replaceAll(',00', '');
    }
    return formattedValue;
  }
}
