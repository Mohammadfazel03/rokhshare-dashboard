import 'package:dashboard/feature/media/data/remote/model/movie.dart';
import 'package:dashboard/feature/media/data/remote/model/series.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';

abstract class MediaRepository {

  Future<DataResponse<PageResponse<Movie>>> getMovies({int page= 1});

  Future<DataResponse<PageResponse<Series>>> getSeries({int page= 1});
}