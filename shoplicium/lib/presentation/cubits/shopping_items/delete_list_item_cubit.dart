import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/repositories/list_item_repository.dart';
import '../../states/data_payload_state.dart';
import '../shopping_list_bloc.dart';

class DeleteListItemCubit extends Cubit<DataPayloadState> {
  DeleteListItemCubit() : super(InitialState());

  Future<void> deleteListItem(String itemId) async {
    emit(RequestingState());

    final bool result = await GetIt.instance<ListItemRepository>().deleteListItem(itemId);

    if (result) {
      GetIt.instance<ShoppingListBloc>().retrieveShoppingLists();
      emit(SuccessState());
    } else {
      emit(ErrorState("List item can't be deleted"));
    }
  }
}