import 'dart:async';
import 'dart:typed_data';

import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/movie/data/remote/model/comment.dart';
import 'package:dashboard/feature/movie/data/remote/model/file_response.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/feature/movie/data/remote/movie_api_service.dart';
import 'package:dashboard/feature/movie/data/repositories/movie_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:dio/dio.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieApiService _api;

  MovieRepositoryImpl(MovieApiService api) : _api = api;

  @override
  Future<DataResponse<PageResponse<Artist>>> getArtists(
      {int page = 1, String? search}) async {
    try {
      Response response = await _api.getArtists(page: page, search: search);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Artist.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<List<Genre>>> getGenres() async {
    try {
      Response response = await _api.getGenres();
      if (response.statusCode == 200) {
        var res = (response.data) as List;
        var data = res.map((g) => Genre.fromJson(g)).toList();
        return DataSuccess(data);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.');
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<List<Country>>> getCountries() async {
    try {
      Response response = await _api.getCountries();
      if (response.statusCode == 200) {
        var res = (response.data) as List;
        var data = res.map((g) => Country.fromJson(g)).toList();
        return DataSuccess(data);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<FileResponse>> uploadFile(
      {required List<int> fileBytes,
      required String filename,
      required int chunkIndex,
      required int totalChunk,
      String? uploadId}) async {
    try {
      Response response = await _api.uploadFile(
          fileBytes: fileBytes,
          filename: filename,
          chunkIndex: chunkIndex,
          totalChunk: totalChunk,
          uploadId: uploadId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DataSuccess(FileResponse.fromJson(response.data));
      }
      return const DataFailed(
          "در بارگذاری مشکلی پیش آماده لطفا دوباره امتحان کنید",
          code: 1);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 410) {
          return const DataFailed("این فایل دیگر قابل سرگیری نمی باشد.",
              code: 410);
        } else if (e.response?.statusCode == 400) {
          return const DataFailed(
              "در بارگذاری مشکلی پیش آماده لطفا دوباره امتحان کنید",
              code: 400);
        } else if (e.response?.statusCode == 404) {
          return const DataFailed("این فایل دیگر قابل سرگیری نمی باشد.",
              code: 404);
        }
      }
      return const DataFailed(
          "در بارگذاری مشکلی پیش آماده لطفا دوباره امتحان کنید",
          code: 1);
    }
  }

  @override
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
      required String name,
      required String value,
      required List<Map<String, String?>> casts,
      required String synopsis}) async {
    try {
      Response response = await _api.saveMovie(
          time: time,
          genres: genres,
          countries: countries,
          video: video,
          releaseDate: releaseDate,
          trailer: trailer,
          thumbnail: thumbnail,
          poster: poster,
          thumbnailName: thumbnailName,
          posterName: posterName,
          casts: casts,
          synopsis: synopsis,
          name: name,
          value: value);
      if (response.statusCode == 201) {
        return const DataSuccess("OK");
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<String>> editMovie(
      {required int id,
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
      String? value}) async {
    try {
      Response response = await _api.editMovie(
          id: id,
          time: time,
          genres: genres,
          countries: countries,
          video: video,
          releaseDate: releaseDate,
          trailer: trailer,
          thumbnail: thumbnail,
          poster: poster,
          thumbnailName: thumbnailName,
          posterName: posterName,
          casts: casts,
          synopsis: synopsis,
          name: name,
          value: value);
      if (response.statusCode == 200) {
        return const DataSuccess("OK");
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<Movie>> getMovie(int id) async {
    try {
      Response response = await _api.getMovie(id);
      if (response.statusCode == 200) {
        var data = Movie.fromJson(response.data);
        return DataSuccess(data);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.');
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<PageResponse<Comment>>> getComments(
      {required int mediaId, int page = 1}) async {
    try {
      Response response = await _api.getComments(page: page, mediaId: mediaId);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Comment.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<void>> changeCommentState(
      {required int commentId, required int state}) async {
    try {
      Response response =
          await _api.changeCommentState(commentId: commentId, state: state);
      if (response.statusCode == 200) {
        return const DataSuccess(null);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('صفحه مورد نظر یافت نشد.', code: 404);
        }
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }
}
