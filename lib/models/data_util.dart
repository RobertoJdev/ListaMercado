import 'package:intl/intl.dart';

class DataUtil {
  static String getCurrentFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    return formattedDate;
  }
}
