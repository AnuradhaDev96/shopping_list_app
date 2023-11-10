import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/repositories/shopping_list_repository.dart';
import '../../states/data_payload_state.dart';
import '../shopping_list_bloc.dart';

class DeleteShoppingListCubit extends Cubit<DataPayloadState> {
  DeleteShoppingListCubit() : super(InitialState());

  Future<void> deleteShoppingList(String listId) async {
    emit(RequestingState());

    final bool result = await GetIt.instance<ShoppingListRepository>().deleteShoppingList(listId);

    if (result) {
      GetIt.instance<ShoppingListBloc>().retrieveShoppingLists();
      emit(SuccessState());
    } else {
      emit(ErrorState("Shopping list can't be deleted"));
    }
  }
}
