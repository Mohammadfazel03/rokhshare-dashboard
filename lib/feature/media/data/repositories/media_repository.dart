import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/media/data/remote/model/collection.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/media/data/remote/model/movie.dart';
import 'package:dashboard/feature/media/data/remote/model/series.dart';
import 'package:dashboard/feature/media/data/remote/model/slider.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/services.dart';

abstract class MediaRepository {
  Future<DataResponse<PageResponse<Movie>>> getMovies({int page = 1});

  Future<DataResponse<void>> deleteMovie({required int id});

  Future<DataResponse<PageResponse<Series>>> getSeries({int page = 1});

  Future<DataResponse<void>> deleteSeries({required int id});

  Future<DataResponse<PageResponse<Genre>>> getGenres({int page = 1});

  Future<DataResponse<PageResponse<Country>>> getCountries({int page = 1});

  Future<DataResponse<PageResponse<SliderModel>>> getSliders({int page = 1});

  Future<DataResponse<SliderModel>> getSlider({required int id});

  Future<DataResponse<String>> saveSlider(
      {required int mediaId,
      required int priority,
      required String title,
      required String description,
      required Uint8List thumbnail,
      required Uint8List poster,
      required String thumbnailName,
      required String posterName});

  Future<DataResponse<String>> editSlider(
      {required int id,
      int? mediaId,
      int? priority,
      String? title,
      String? description,
      Uint8List? thumbnail,
      Uint8List? poster,
      String? thumbnailName,
      String? posterName});

  Future<DataResponse<void>> deleteSlider({required int id});

  Future<DataResponse<PageResponse<Artist>>> getArtists({int page = 1});

  Future<DataResponse<PageResponse<Collection>>> getCollections({int page = 1});

  Future<DataResponse<void>> postCollection({required title, required poster});

  Future<DataResponse<void>> deleteCollection({required int id});

  Future<DataResponse<Collection>> getCollection({required int id});

  Future<DataResponse<void>> updateCollection({required int id, poster, title});

  Future<DataResponse<Genre>> postGenre({required title, required poster});

  Future<DataResponse<void>> deleteGenre({required int id});

  Future<DataResponse<Genre>> getGenre({required int id});

  Future<DataResponse<Genre>> updateGenre({required int id, poster, title});

  Future<DataResponse<Country>> postCountry({required name, required flag});

  Future<DataResponse<void>> deleteCountry({required int id});

  Future<DataResponse<Country>> getCountry({required int id});

  Future<DataResponse<Country>> updateCountry({required int id, flag, name});

  Future<DataResponse<Artist>> postArtist(
      {required name, required image, required bio});

  Future<DataResponse<void>> deleteArtist({required int id});

  Future<DataResponse<Artist>> getArtist({required int id});

  Future<DataResponse<Artist>> updateArtist(
      {required int id, image, name, required bio});

  Future<DataResponse<void>> changeCollectionState(
      {required int collectionId, required int state});
}
