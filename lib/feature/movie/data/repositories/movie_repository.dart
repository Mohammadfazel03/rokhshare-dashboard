import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/feature/movie/data/remote/model/file_response.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/foundation.dart';

abstract class MovieRepository {
  Future<DataResponse<PageResponse<Artist>>> getArtists(
      {int page = 1, String? search});

  Future<DataResponse<List<Country>>> getCountries();

  Future<DataResponse<List<Genre>>> getGenres();

  Future<DataResponse<FileResponse>> uploadFile(
      {required List<int> fileBytes,
      required String filename,
      required int chunkIndex,
      required int totalChunk,
      String? uploadId});

  Future<DataResponse<String>> saveMovie(
      {required int time,
      required List<int> genres,
      required List<int> countries,
      required int video,
      required String releaseDate,
      required int trailer,
      required Uint8List thumbnail,
      required Uint8List poster,
      required String thumbnailName,
      required String posterName,
      required List<Map<String, String?>> casts,
      required String name,
      required String  value,
      required String synopsis});

  Future<DataResponse<String>> editMovie({
    required int id,
    int? time,
    List<int>? genres,
    List<int>? countries,
    int? video,
    String? releaseDate,
    int? trailer,
    Uint8List? thumbnail,
    Uint8List? poster,
    String? thumbnailName,
    String? posterName,
    List<Map<String, String?>>? casts,
    String? synopsis,
    String? name,
    String? value,
  });

  Future<DataResponse<Movie>> getMovie(int id);
}