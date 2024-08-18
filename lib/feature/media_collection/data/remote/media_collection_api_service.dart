import 'package:dio/dio.dart';

class MediaCollectionApiService {
  final Dio _dio;

  MediaCollectionApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> getMediaOfCollection(
      {required int collectionId, int page = 1}) async {
    return await _dio
        .get("collection/$collectionId/media", queryParameters: {"page": page});
  }

  Future<dynamic> searchMedia({required String query, int page = 1}) async {
    return await _dio
        .get("media/", queryParameters: {"page": page, "search": query});
  }

  Future<dynamic> addMedia(
      {required List<int> mediaId, required int collectionId}) async {
    return await _dio
        .post("collection/$collectionId/add/", data: {"media": mediaId});
  }

  Future<dynamic> removeMedia(
      {required List<int> mediaId, required int collectionId}) async {
    return await _dio
        .post("collection/$collectionId/remove/", data: {"media": mediaId});
  }
}
