import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lista_mercado/util/data_util.dart';

void main() {
  group('DataUtil', () {
    test(
        'getCurrentFormattedDate deve retornar uma data formatada corretamente',
        () {
      String formattedDate = DataUtil.getCurrentFormattedDate();
      String expectedDate = DateFormat('dd-MM-yy').format(DateTime.now());
      expect(formattedDate, expectedDate);
    });

    test('returnDataFormatted deve retornar uma data formatada corretamente',
        () {
      String dataExemplo = '2024-02-13';
      String formattedDate = DataUtil.returnDataFormatted(dataExemplo);
      expect(formattedDate, '13-02-24');
    });
  });
}
