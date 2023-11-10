import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/enums/list_item_status_enum.dart';
import '../../../domain/enums/unit_of_measure_enum.dart';
import '../../../domain/models/list_item_dto.dart';
import '../../../domain/repositories/list_item_repository.dart';
import '../../states/data_payload_state.dart';
import '../shopping_list_bloc.dart';

class CreateListItemCubit extends Cubit<DataPayloadState> {
  CreateListItemCubit() : super(InitialState());

  Future<void> createListItem({
    required String title,
    required int amount,
    required UnitOfMeasureEnum unitOfMeasure,
    required String listId,
  }) async {
    emit(RequestingState());

    final bool result = await GetIt.instance<ListItemRepository>().createListItem(
      ListItemDto(
        itemId: const Uuid().v1(),
        title: title,
        amount: amount,
        UOM: unitOfMeasure,
        status: ListItemStatusEnum.remaining,
        listId: listId,
      ),
    );

    if (result) {
      GetIt.instance<ShoppingListBloc>().retrieveShoppingLists();
      emit(SuccessState());
    } else {
      emit(ErrorState("List item can't be saved"));
    }
  }
}
