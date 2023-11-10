import '../models/list_item_dto.dart';

abstract class ListItemRepository {

  Future<bool> createListItem(ListItemDto instance);

  Future<List<ListItemDto>> getListItems();

  Future<bool> updateListItem(ListItemDto instance);
}