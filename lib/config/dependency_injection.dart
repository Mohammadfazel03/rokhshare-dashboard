import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/theme/theme_cubit.dart';
import 'package:dashboard/feature/dashboard/data/remote/dashboard_api_service.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/first_screen_slider/bloc/first_screen_slider_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/header_information/bloc/header_information_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/popular_plan/bloc/popular_plan_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_advertise/bloc/recently_advertise_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_comment/bloc/recently_comment_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/bloc/recently_user_cubit.dart';
import 'package:dashboard/feature/login/data/remote/login_api_service.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository_impl.dart';
import 'package:dashboard/feature/login/presentation/bloc/login_cubit.dart';
import 'package:dashboard/feature/media/data/remote/media_api_service.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository_impl.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/bloc/countries_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/bloc/genres_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/movies_table/bloc/movies_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/series_table/bloc/series_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/bloc/sliders_table_cubit.dart';
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

  getIt.registerLazySingleton<DashboardApiService>(() => DashboardApiService(
      dio: getIt.get(),
      accessToken: getIt.get<LocalStorageService>().getAccessToken() ?? ""));
  getIt.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(apiService: getIt.get()));

  getIt.registerLazySingleton<MediaApiService>(() => MediaApiService(
      dio: getIt.get(),
      accessToken: getIt.get<LocalStorageService>().getAccessToken() ?? ""));
  getIt.registerLazySingleton<MediaRepository>(
      () => MediaRepositoryImpl(apiService: getIt.get()));

  // register state managements
  getIt.registerLazySingleton(() => ThemeCubit());

  getIt.registerLazySingleton<LoginCubit>(
      () => LoginCubit(loginRepository: getIt.get()));

  getIt.registerLazySingleton<HeaderInformationCubit>(
      () => HeaderInformationCubit(repository: getIt.get()));

  getIt.registerLazySingleton<RecentlyUserCubit>(
      () => RecentlyUserCubit(repository: getIt.get()));

  getIt.registerLazySingleton<PopularPlanCubit>(
      () => PopularPlanCubit(repository: getIt.get()));

  getIt.registerLazySingleton<RecentlyCommentCubit>(
      () => RecentlyCommentCubit(repository: getIt.get()));

  getIt.registerLazySingleton<FirstScreenSliderCubit>(
      () => FirstScreenSliderCubit(repository: getIt.get()));

  getIt.registerLazySingleton<RecentlyAdvertiseCubit>(
      () => RecentlyAdvertiseCubit(repository: getIt.get()));

  getIt.registerLazySingleton<MoviesTableCubit>(
      () => MoviesTableCubit(repository: getIt.get()));

  getIt.registerLazySingleton<SeriesTableCubit>(
      () => SeriesTableCubit(repository: getIt.get()));

  getIt.registerLazySingleton<GenresTableCubit>(
      () => GenresTableCubit(repository: getIt.get()));

  getIt.registerLazySingleton<CountriesTableCubit>(
      () => CountriesTableCubit(repository: getIt.get()));

  getIt.registerLazySingleton<SlidersTableCubit>(
      () => SlidersTableCubit(repository: getIt.get()));
}
