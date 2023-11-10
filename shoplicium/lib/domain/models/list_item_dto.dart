import '../enums/list_item_status_enum.dart';
import '../enums/unit_of_measure_enum.dart';

class ListItemDto {
  ///type: TEXT
  final String itemId;

  ///type: TEXT
  final String title;

  ///type: INTEGER
  final int amount;

  ///type: INTEGER
  final UnitOfMeasureEnum UOM;

  ///type: INTEGER
  final ListItemStatusEnum status;

  ///type: TEXT
  final String listId;

  ListItemDto({
    required this.itemId,
    required this.title,
    required this.amount,
    required this.UOM,
    required this.status,
    required this.listId,
  });

  ListItemDto.fromMap(Map<String, dynamic> map)
      : itemId = map['itemId'],
        title = map['title'],
        amount = map['amount'],
        UOM = UnitOfMeasureEnum.values.where((element) => element.dtoValue == map['UOM']).first,
        status = ListItemStatusEnum.values.where((element) => element.dtoValue == map['status']).first,
        listId = map['listId'];

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'title': title,
      'amount': amount,
      'UOM': UOM.dtoValue,
      'status': status.dtoValue,
      'listId': listId,
    };
  }
}
