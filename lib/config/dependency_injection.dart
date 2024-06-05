import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/feature/login/data/remote/login_api_service.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository_impl.dart';
import 'package:dashboard/feature/login/presentation/bloc/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio_config.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // register local storage services
  getIt.registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance());
  getIt.registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(preferences: getIt.get<SharedPreferences>()));

  // register remote services
  getIt.registerSingleton<Dio>(getDioConfiguration());
  getIt.registerLazySingleton<LoginApiService>(
      () => LoginApiService(dio: getIt.get()));
  getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(apiService: getIt.get()));

  // register state managements
  getIt.registerLazySingleton<LoginCubit>(
      () => LoginCubit(loginRepository: getIt.get()));
}
