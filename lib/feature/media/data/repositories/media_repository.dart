import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/media/data/remote/model/collection.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/media/data/remote/model/movie.dart';
import 'package:dashboard/feature/media/data/remote/model/series.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';

abstract class MediaRepository {
  Future<DataResponse<PageResponse<Movie>>> getMovies({int page = 1});

  Future<DataResponse<PageResponse<Series>>> getSeries({int page = 1});

  Future<DataResponse<PageResponse<Genre>>> getGenres({int page = 1});

  Future<DataResponse<PageResponse<Country>>> getCountries({int page = 1});

  Future<DataResponse<PageResponse<SliderModel>>> getSliders({int page = 1});

  Future<DataResponse<PageResponse<Artist>>> getArtists({int page = 1});

  Future<DataResponse<PageResponse<Collection>>> getCollections({int page = 1});

  Future<DataResponse<Genre>> postGenre({required title,required poster});

  Future<DataResponse<void>> deleteGenre({required int id});

  Future<DataResponse<Genre>> getGenre({required int id});

  Future<DataResponse<Genre>> updateGenre({required int id, poster, title});

  Future<DataResponse<Country>> postCountry({required name,required flag});

  Future<DataResponse<void>> deleteCountry({required int id});

  Future<DataResponse<Country>> getCountry({required int id});

  Future<DataResponse<Country>> updateCountry({required int id, flag, name});

  Future<DataResponse<Artist>> postArtist({required name,required image, required bio});

  Future<DataResponse<void>> deleteArtist({required int id});

  Future<DataResponse<Artist>> getArtist({required int id});

  Future<DataResponse<Artist>> updateArtist({required int id, image, name, required bio});
}
