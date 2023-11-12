import 'package:uuid/uuid.dart';

class ItemMarket {
  ItemMarket(this.name, this.quant, this.last_price, this.historic_price,
      this.pendent) {
    var uuid = Uuid();
    _id = uuid.v4(); // Gerando um UUID para cada instância
  }

  String? _id; // Identificador único (UUID) para cada ItemMarket
  String name;
  int quant;
  double last_price;
  List<double> historic_price;
  bool pendent;

  get uuid => null;

  String getId() {
    return _id.toString();
  }
}
