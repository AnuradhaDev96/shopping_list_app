import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/models/shopping_list_dto.dart';
import '../../../domain/repositories/shopping_list_repository.dart';
import '../../states/data_payload_state.dart';

class CreateNewListCubit extends Cubit<DataPayloadState> {
  CreateNewListCubit() : super(InitialState());

  Future<void> createShoppingList(String title, DateTime shoppingDate) async {
    emit(RequestingState());

    final bool result = await GetIt.instance<ShoppingListRepository>().createShoppingList(
      ShoppingListDto(
        listId: const Uuid().v1(),
        title: title,
        date: shoppingDate,
        createdOn: DateTime.now(),
      ),
    );

    emit(result ? SuccessState() : ErrorState("Shopping list can't be saved"));
  }
}
