import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/theme/theme_cubit.dart';
import 'package:dashboard/feature/advertise/data/remote/advertise_api_service.dart';
import 'package:dashboard/feature/advertise/data/repositories/advertise_repository.dart';
import 'package:dashboard/feature/advertise/data/repositories/advertise_repository_impl.dart';
import 'package:dashboard/feature/dashboard/data/remote/dashboard_api_service.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:dashboard/feature/episode/data/remote/episode_api_service.dart';
import 'package:dashboard/feature/episode/data/repositories/episode_repository.dart';
import 'package:dashboard/feature/episode/data/repositories/episode_repository_impl.dart';
import 'package:dashboard/feature/login/data/remote/login_api_service.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository.dart';
import 'package:dashboard/feature/login/data/repositories/login_repository_impl.dart';
import 'package:dashboard/feature/media/data/remote/media_api_service.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository_impl.dart';
import 'package:dashboard/feature/media_collection/data/remote/media_collection_api_service.dart';
import 'package:dashboard/feature/media_collection/data/repositories/media_collection_repository.dart';
import 'package:dashboard/feature/media_collection/data/repositories/media_collection_repository_impl.dart';
import 'package:dashboard/feature/movie/data/remote/movie_api_service.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository_impl.dart';
import 'package:dashboard/feature/season/data/remote/season_api_service.dart';
import 'package:dashboard/feature/season/data/repositories/season_repository.dart';
import 'package:dashboard/feature/season/data/repositories/season_repository_impl.dart';
import 'package:dashboard/feature/season_episode/data/remote/season_episode_api_service.dart';
import 'package:dashboard/feature/season_episode/data/repositories/season_episode_repository.dart';
import 'package:dashboard/feature/season_episode/data/repositories/season_episode_repository_impl.dart';
import 'package:dashboard/feature/series/data/remote/series_api_service.dart';
import 'package:dashboard/feature/series/data/repositories/series_repository.dart';
import 'package:dashboard/feature/series/data/repositories/series_repository_impl.dart';
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

  getIt.registerLazySingleton(() => SeriesApiService(dio: getIt.get()));
  getIt.registerLazySingleton<SeriesRepository>(
      () => SeriesRepositoryImpl(api: getIt.get()));

  getIt.registerLazySingleton(() => SeasonApiService(dio: getIt.get()));
  getIt.registerLazySingleton<SeasonRepository>(
      () => SeasonRepositoryImpl(api: getIt.get()));

  getIt.registerLazySingleton(() => SeasonEpisodeApiService(dio: getIt.get()));
  getIt.registerLazySingleton<SeasonEpisodeRepository>(
      () => SeasonEpisodeRepositoryImpl(api: getIt.get()));

  getIt.registerLazySingleton(() => EpisodeApiService(dio: getIt.get()));
  getIt.registerLazySingleton<EpisodeRepository>(
      () => EpisodeRepositoryImpl(api: getIt.get()));

  getIt
      .registerLazySingleton(() => MediaCollectionApiService(dio: getIt.get()));
  getIt.registerLazySingleton<MediaCollectionRepository>(
      () => MediaCollectionRepositoryImpl(api: getIt.get()));

  getIt.registerLazySingleton(() => AdvertiseApiService(dio: getIt.get()));
  getIt.registerLazySingleton<AdvertiseRepository>(
      () => AdvertiseRepositoryImpl(api: getIt.get()));

  // register state managements
  getIt.registerLazySingleton(() => ThemeCubit());
}
