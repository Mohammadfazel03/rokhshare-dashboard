import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/data/remote/model/artist.dart';
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
}
