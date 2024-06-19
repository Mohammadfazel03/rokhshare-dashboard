import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/feature/dashboard/data/remote/dashboard_api_service.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/header_information/bloc/header_information_bloc.dart';
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
          () =>
          LocalStorageService(preferences: getIt.get<SharedPreferences>()));


  // register remote services
  getIt.registerSingleton<Dio>(getDioConfiguration());

  getIt.registerLazySingleton<LoginApiService>(
          () => LoginApiService(dio: getIt.get()));
  getIt.registerLazySingleton<LoginRepository>(
          () => LoginRepositoryImpl(apiService: getIt.get()));

  getIt.registerLazySingleton<DashboardApiService>(() =>
      DashboardApiService(
          dio: getIt.get(),
          accessToken: getIt.get<LocalStorageService>().getAccessToken() ??
              ""));
  getIt.registerLazySingleton<DashboardRepository>(
          () => DashboardRepositoryImpl(apiService: getIt.get()));


  // register state managements
  getIt.registerLazySingleton<LoginCubit>(
          () => LoginCubit(loginRepository: getIt.get()));

  getIt.registerLazySingleton<HeaderInformationBloc>(
          () => HeaderInformationBloc(repository: getIt.get())
  );
}
