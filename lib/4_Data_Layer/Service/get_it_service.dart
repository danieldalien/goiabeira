import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class GetItService {
  /// Registers a factory, replacing any existing registration for type [T].
  void registerFactory<T extends Object>(T Function() factory) {
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }
    getIt.registerFactory<T>(factory);
  }

  /// Registers a singleton, replacing any existing registration for type [T].
  void registerSingleton<T extends Object>(T instance) {
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }
    getIt.registerSingleton<T>(instance);
  }

  /// Registers a lazy singleton, replacing any existing registration for type [T].
  void registerLazySingleton<T extends Object>(T Function() factory) {
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }
    getIt.registerLazySingleton<T>(factory);
  }
}
