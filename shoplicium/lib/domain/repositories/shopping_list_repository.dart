import '../models/shopping_list_dto.dart';

abstract class ShoppingListRepository {

  Future<bool> createShoppingList(ShoppingListDto instance);

  /// Ordered by createdOn. Newest list appear first.
  Future<List<ShoppingListDto>> getShoppingLists();

  Future<bool> deleteShoppingList(String listId);

  Future<bool> updateShoppingList(ShoppingListDto instance);
}
