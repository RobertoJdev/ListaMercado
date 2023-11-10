class ItemMarket {
  ItemMarket(this.name, this.quant, this.last_price, this.historic_price,
      this.pendent);

  String name;
  int quant;
  double last_price;
  List<double> historic_price;
  bool pendent;
}
