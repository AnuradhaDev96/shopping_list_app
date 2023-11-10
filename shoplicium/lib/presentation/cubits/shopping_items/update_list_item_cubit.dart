import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/enums/unit_of_measure_enum.dart';
import '../../../domain/models/list_item_dto.dart';
import '../../../domain/repositories/list_item_repository.dart';
import '../../states/data_payload_state.dart';
import '../shopping_list_bloc.dart';

class UpdateListItemCubit extends Cubit<DataPayloadState> {
  UpdateListItemCubit() : super(InitialState());

  Future<void> updateListItem({
    required String title,
    required int amount,
    required UnitOfMeasureEnum unitOfMeasure,
    required ListItemDto existingData,
  }) async {
    final result = await GetIt.instance<ListItemRepository>().updateListItem(
      ListItemDto(
        itemId: existingData.itemId,
        title: title,
        amount: amount,
        UOM: unitOfMeasure,
        listId: existingData.listId,
        status: existingData.status,
      ),
    );

    if (result) {
      GetIt.instance<ShoppingListBloc>().retrieveShoppingLists();
      emit(SuccessState());
    } else {
      emit(ErrorState("List item can't be updated"));
    }
  }
}
