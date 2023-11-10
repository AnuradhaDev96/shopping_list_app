enum ListItemStatusEnum {
  remaining(dtoValue: 1, text: "Remaining"),
  inBag(dtoValue: 2, text: "In bag"),
  notInShop(dtoValue: 3, text: "Not in shop");

  final int dtoValue;
  final String text;

  const ListItemStatusEnum({required this.dtoValue, required this.text});
}