import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shopify/blocs/category/category_bloc.dart';
import 'package:shopify/blocs/product/product_bloc.dart';
import 'package:shopify/blocs/theme/theme_bloc.dart';
import 'package:shopify/core/services/api_service.dart';
import 'package:shopify/core/services/connectivity_service.dart';
import 'package:shopify/core/services/database_service.dart';
import 'package:shopify/repositories/product_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());
  getIt.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService(
    connectionChecker: getIt<InternetConnectionChecker>(),
  ));

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepository(
    apiService: getIt<ApiService>(),
    databaseService: getIt<DatabaseService>(),
    connectivityService: getIt<ConnectivityService>(),
  ));

  // Blocs
  getIt.registerFactory<ProductBloc>(() => ProductBloc(
    repository: getIt<ProductRepository>(),
  ));
  getIt.registerFactory<CategoryBloc>(() => CategoryBloc(
    repository: getIt<ProductRepository>(),
  ));
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc(
    databaseService: getIt<DatabaseService>(),
  ));
}