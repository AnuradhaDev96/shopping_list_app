enum UnitOfMeasureEnum {
  grams(dtoValue: 1, text: "Grams", symbol: "g"),
  kg(dtoValue: 2, text: "Kilo grams", symbol: "kg"),
  meters(dtoValue: 3, text: "Meters", symbol: "m"),
  pieces(dtoValue: 4, text: "Count", symbol: "Pieces"),
  litres(dtoValue: 5, text: "Litres", symbol: "L");

  final int dtoValue;
  final String text;
  final String symbol;

  const UnitOfMeasureEnum({required this.dtoValue, required this.text, required this.symbol});
}