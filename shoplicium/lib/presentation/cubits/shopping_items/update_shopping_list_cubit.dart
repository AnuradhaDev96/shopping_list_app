import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/shopping_list_dto.dart';
import '../../../domain/repositories/shopping_list_repository.dart';
import '../../states/data_payload_state.dart';
import '../shopping_list_bloc.dart';

class UpdateShoppingListCubit extends Cubit<DataPayloadState> {
  UpdateShoppingListCubit() : super(InitialState());

  Future<void> updateShoppingList(String title, DateTime shoppingDate, ShoppingListDto existingData) async {
    emit(RequestingState());

    final bool result = await GetIt.instance<ShoppingListRepository>().updateShoppingList(
      ShoppingListDto(
        listId: existingData.listId,
        title: title,
        date: shoppingDate,
        createdOn: existingData.createdOn,
      ),
    );

    if (result) {
      GetIt.instance<ShoppingListBloc>().retrieveShoppingLists();
      emit(SuccessState());
    } else {
      emit(ErrorState("Shopping list can't be updated"));
    }
  }
}
