enum UnitOfMeasureEnum {
  grams(dtoValue: 1, text: "Grams", symbol: "g"),
  kg(dtoValue: 2, text: "Kilo grams", symbol: "kg"),
  meters(dtoValue: 3, text: "Meters", symbol: "m"),
  pieces(dtoValue: 4, text: "Pieces", symbol: "count");

  final int dtoValue;
  final String text;
  final String symbol;

  const UnitOfMeasureEnum({required this.dtoValue, required this.text, required this.symbol});
}

enum ListItemStatusEnum {
  remaining(dtoValue: 1, text: "Remaining"),
  inBag(dtoValue: 2, text: "In bag"),
  notInShop(dtoValue: 3, text: "Not in shop");

  final int dtoValue;
  final String text;

  const ListItemStatusEnum({required this.dtoValue, required this.text});
}