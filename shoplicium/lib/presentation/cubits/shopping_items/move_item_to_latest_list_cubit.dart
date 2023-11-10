import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/enums/list_item_status_enum.dart';
import '../../../domain/enums/unit_of_measure_enum.dart';
import '../../../domain/models/list_item_dto.dart';
import '../../../domain/repositories/list_item_repository.dart';
import '../../../domain/repositories/shopping_list_repository.dart';
import '../../states/data_payload_state.dart';
import '../shopping_list_bloc.dart';

class MoveItemToLatestListCubit extends Cubit<DataPayloadState> {
  MoveItemToLatestListCubit() : super(InitialState());

  /// Move to latest shopping list with changes of title, amount, unit of measure.
  /// Status will be changed to remaining
  Future<void> moveToLatest({
    required String title,
    required int amount,
    required UnitOfMeasureEnum unitOfMeasure,
    required ListItemDto existingData,
  }) async {
    emit(RequestingState());
    final allShoppingList = await GetIt.instance<ShoppingListRepository>().getShoppingLists();
    if (allShoppingList.isNotEmpty) {
      final result = await GetIt.instance<ListItemRepository>().updateListItem(
        ListItemDto(
          itemId: existingData.itemId,
          title: title,
          amount: amount,
          UOM: unitOfMeasure,
          listId: allShoppingList.first.listId,
          status: ListItemStatusEnum.remaining,
        ),
      );

      if (result) {
        GetIt.instance<ShoppingListBloc>().retrieveShoppingLists();
        emit(SuccessState());
      } else {
        emit(ErrorState("Item can't be moved to latest shopping list"));
      }

    } else {
      emit(ErrorState('Latest list can\'t be found'));
    }
  }
}
