import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/enums/list_item_status_enum.dart';
import '../../../domain/models/list_item_dto.dart';
import '../../../domain/repositories/list_item_repository.dart';
import '../../states/data_payload_state.dart';
import '../shopping_list_bloc.dart';

class UpdateItemStatusCubit extends Cubit<DataPayloadState> {
  UpdateItemStatusCubit() : super(InitialState());

  Future<void> updateStatus(ListItemStatusEnum newStatus, ListItemDto existingData) async {
    final result = await GetIt.instance<ListItemRepository>().updateListItem(
      ListItemDto(
        itemId: existingData.itemId,
        title: existingData.title,
        amount: existingData.amount,
        UOM: existingData.UOM,
        status: newStatus,
        listId: existingData.listId,
      ),
    );

    if (result) {
      GetIt.instance<ShoppingListBloc>().retrieveShoppingLists();
      emit(SuccessState());
    } else {
      emit(ErrorState("Status can't be changed"));
    }
  }
}
