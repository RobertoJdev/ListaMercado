
class Populador {
  //List<Produto> produtos = [];
  final bool _isPopulated = false;

  // Singleton instance
  static final Populador _singleton = Populador._internal();

  factory Populador() {
    return _singleton;
  }

  Populador._internal();

}
