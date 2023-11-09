import 'package:get_it/get_it.dart';

import 'data/local_data_source_impl.dart';
import 'domain/repositories/local_data_source.dart';

abstract class DependencyLocator {
  static void locateDependencies() {
    GetIt.instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  }
}
