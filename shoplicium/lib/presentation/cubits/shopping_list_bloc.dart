import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/list_item_dto.dart';
import '../../domain/models/shopping_list_dto.dart';
import '../../domain/repositories/list_item_repository.dart';
import '../../domain/repositories/shopping_list_repository.dart';

class ShoppingListBloc {
  // shopping list
  final _shoppingListSubject = BehaviorSubject<List<ShoppingListDto>>();

  Stream<List<ShoppingListDto>> get shoppingListStream => _shoppingListSubject.stream;

  void setShoppingList(List<ShoppingListDto> list) {
    _shoppingListSubject.sink.add(list);
  }

  // list items
  final _listItemsSubject = BehaviorSubject<List<ListItemDto>>();

  Stream<List<ListItemDto>> get listItemsStream => _listItemsSubject.stream;

  void setListItems(List<ListItemDto> list) {
    _listItemsSubject.sink.add(list);
  }

  Future<void> retrieveShoppingLists() async {
    setShoppingList(await GetIt.instance<ShoppingListRepository>().getShoppingLists());
    setListItems(await GetIt.instance<ListItemRepository>().getListItems());
  }
}
