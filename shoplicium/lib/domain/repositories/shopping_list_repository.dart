import '../models/shopping_list_dto.dart';

abstract class ShoppingListRepository {

  Future<bool> createShoppingList(ShoppingListDto instance);
}
