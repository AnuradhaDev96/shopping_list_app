import 'package:get_it/get_it.dart';

import 'data/data_sources/local_data_source_impl.dart';
import 'data/repositories/shopping_list_repository_impl.dart';
import 'domain/repositories/local_data_source.dart';
import 'domain/repositories/shopping_list_repository.dart';
import 'presentation/cubits/shopping_list_bloc.dart';

abstract class DependencyLocator {
  static void locateDependencies() {
    GetIt.instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
    GetIt.instance.registerLazySingleton<ShoppingListRepository>(() => ShoppingListRepositoryImpl());
    GetIt.instance.registerLazySingleton<ShoppingListBloc>(() => ShoppingListBloc());
  }
}
