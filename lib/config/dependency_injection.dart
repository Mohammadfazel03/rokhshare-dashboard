import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/theme/theme_cubit.dart';
import 'package:dashboard/feature/dashboard/data/remote/dashboard_api_service.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:dashboard/feature/login/data/remote/login_api_service.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository_impl.dart';
import 'package:dashboard/feature/media/data/remote/media_api_service.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository_impl.dart';
import 'package:dashboard/feature/movie/data/remote/movie_api_service.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio_config.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // register local storage services
  getIt.registerSingletonAsync<SharedPreferencesAsync>(
      () async => SharedPreferencesAsync());
  getIt.registerLazySingleton<LocalStorageService>(() =>
      LocalStorageService(preferences: getIt.get<SharedPreferencesAsync>()));

  // register remote services
  getIt.registerSingleton<Dio>(getDioConfiguration());

  getIt.registerLazySingleton<LoginApiService>(
      () => LoginApiService(dio: getIt.get()));
  getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(apiService: getIt.get()));

  getIt.registerLazySingleton<DashboardApiService>(
      () => DashboardApiService(dio: getIt.get()));
  getIt.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(apiService: getIt.get()));

  getIt.registerLazySingleton<MediaApiService>(
      () => MediaApiService(dio: getIt.get()));
  getIt.registerLazySingleton<MediaRepository>(
      () => MediaRepositoryImpl(apiService: getIt.get()));

  getIt.registerLazySingleton(() => MovieApiService(dio: getIt.get()));
  getIt.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(getIt.get()));

  // register state managements
  getIt.registerLazySingleton(() => ThemeCubit());
}
