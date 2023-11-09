import 'package:get_it/get_it.dart';

abstract class DependencyLocator {
  static void locateDependencies() {
    // GetIt.instance.registerLazySingleton<AppDatabase>(() => AppDatabase());
  }
}