import 'package:intl/intl.dart';

class DataUtil {
  static String getCurrentFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yy').format(now);
    return formattedDate;
  }

  static String returnDataFormatted(String data) {
    DateTime date = DateFormat('yy-MM-dd').parse(data);
    String formattedDate = DateFormat('dd-MM-yy').format(date);
    return formattedDate;
  }
}
