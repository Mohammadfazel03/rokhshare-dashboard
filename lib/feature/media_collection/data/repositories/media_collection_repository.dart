import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';

abstract class MediaCollectionRepository {
  Future<DataResponse<PageResponse<Media>>> getMediaOfCollection(
      {required int collectionId, int page = 1});

  Future<DataResponse<PageResponse<Media>>> searchMedia(
      {required String query, int page = 1});

  Future<DataResponse<void>> addMedia(
      {required int mediaId, required int collectionId});

  Future<DataResponse<void>> removeMedia(
      {required int mediaId, required int collectionId});
}
