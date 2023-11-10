import 'package:intl/intl.dart';

class ShoppingListDto {
  /// TEXT
  final String listId;

  /// TEXT
  final String title;

  ///type: TEXT, format: "2012-02-27"
  final DateTime date;

  ///type: TEXT, format: "2012-02-27 13:27:00"
  final DateTime createdOn;

  ShoppingListDto({required this.listId, required this.title, required this.date, required this.createdOn});

  ShoppingListDto.fromMap(Map<String, dynamic> map)
      : listId = map['listId'],
        title = map['title'],
        date = DateTime.parse(map['date']),
        createdOn = DateTime.parse(map['createdOn']);

  Map<String, dynamic> toMap() {
    return {
      'listId': listId,
      'title': title,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'createdOn': DateFormat('yyyy-MM-dd hh:mm:ss').format(createdOn),
    };
  }
}
