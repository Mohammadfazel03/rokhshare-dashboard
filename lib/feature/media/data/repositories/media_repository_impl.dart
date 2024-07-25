import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/data/remote/media_api_service.dart';
import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/media/data/remote/model/collection.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/media/data/remote/model/movie.dart';
import 'package:dashboard/feature/media/data/remote/model/series.dart';
import 'package:dashboard/feature/media/data/repositories/media_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:dio/dio.dart';

class MediaRepositoryImpl extends MediaRepository {
  final MediaApiService _api;

  MediaRepositoryImpl({required MediaApiService apiService})
      : _api = apiService;

  @override
  Future<DataResponse<PageResponse<Movie>>> getMovies({int page = 1}) async {
    try {
      Response response = await _api.getMovies(page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Movie.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<PageResponse<Series>>> getSeries({int page = 1}) async {
    try {
      Response response = await _api.getSeries(page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Series.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<PageResponse<Genre>>> getGenres({int page = 1}) async {
    try {
      Response response = await _api.getGenres(page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Genre.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<PageResponse<Country>>> getCountries(
      {int page = 1}) async {
    try {
      Response response = await _api.getCountries(page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Country.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<PageResponse<SliderModel>>> getSliders(
      {int page = 1}) async {
    try {
      Response response = await _api.getSlider(page: page);
      if (response.statusCode == 200) {
        return DataSuccess(PageResponse.fromJson(
            response.data, (s) => SliderModel.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<PageResponse<Artist>>> getArtists({int page = 1}) async {
    try {
      Response response = await _api.getArtists(page: page);
      if (response.statusCode == 200) {
        return DataSuccess(
            PageResponse.fromJson(response.data, (s) => Artist.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<PageResponse<Collection>>> getCollections(
      {int page = 1}) async {
    try {
      Response response = await _api.getCollection(page: page);
      if (response.statusCode == 200) {
        return DataSuccess(PageResponse.fromJson(
            response.data, (s) => Collection.fromJson(s)));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<Genre>> postGenre(
      {required title, required poster}) async {
    try {
      Response response = await _api.postGenre(title: title, poster: poster);
      if (response.statusCode == 201) {
        return DataSuccess(Genre.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
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
  Future<DataResponse<void>> deleteGenre({required int id}) async {
    try {
      Response response = await _api.deleteGenre(id: id);
      if (response.statusCode == 204) {
        return const DataSuccess(null);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<Genre>> getGenre({required int id}) async {
    try {
      Response response = await _api.getGenre(id: id);
      if (response.statusCode == 200) {
        return DataSuccess(Genre.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('ژانر مورد نظر یافت نشد.');
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
  Future<DataResponse<Genre>> updateGenre(
      {required int id, poster, title}) async {
    try {
      Response response =
          await _api.updateGenre(id: id, poster: poster, title: title);
      if (response.statusCode == 200) {
        return DataSuccess(Genre.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('ژانر مورد نظر یافت نشد.');
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
  Future<DataResponse<Country>> postCountry(
      {required name, required flag}) async {
    try {
      Response response = await _api.postCountry(name: name, flag: flag);
      if (response.statusCode == 201) {
        return DataSuccess(Country.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
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
  Future<DataResponse<void>> deleteCountry({required int id}) async {
    try {
      Response response = await _api.deleteCountry(id: id);
      if (response.statusCode == 204) {
        return const DataSuccess(null);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<Country>> getCountry({required int id}) async {
    try {
      Response response = await _api.getCountry(id: id);
      if (response.statusCode == 200) {
        return DataSuccess(Country.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('ژانر مورد نظر یافت نشد.');
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
  Future<DataResponse<Country>> updateCountry(
      {required int id, flag, name}) async {
    try {
      Response response =
          await _api.updateCountry(id: id, flag: flag, name: name);
      if (response.statusCode == 200) {
        return DataSuccess(Country.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('ژانر مورد نظر یافت نشد.');
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
  Future<DataResponse<Artist>> postArtist(
      {required name, required image, required bio}) async {
    try {
      Response response = await _api.postArtist(name: name, image: image, bio: bio);
      if (response.statusCode == 201) {
        return DataSuccess(Artist.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 400) {
          return const DataFailed('مقادیر را به درستی و کامل وارد کنید.');
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
  Future<DataResponse<void>> deleteArtist({required int id}) async {
    try {
      Response response = await _api.deleteArtist(id: id);
      if (response.statusCode == 204) {
        return const DataSuccess(null);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
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
  Future<DataResponse<Artist>> getArtist({required int id}) async {
    try {
      Response response = await _api.getArtist(id: id);
      if (response.statusCode == 200) {
        return DataSuccess(Artist.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('ژانر مورد نظر یافت نشد.');
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
  Future<DataResponse<Artist>> updateArtist(
      {required int id, image, name, bio}) async {
    try {
      Response response =
      await _api.updateArtist(id: id, image: image, name: name, bio: bio);
      if (response.statusCode == 200) {
        return DataSuccess(Artist.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        if (exception.response?.statusCode == 403) {
          return const DataFailed(
              'این نشست غیر فعال شده است. لطفا دوباره وارد شوید.',
              code: 403);
        } else if (exception.response?.statusCode == 404) {
          return const DataFailed('ژانر مورد نظر یافت نشد.');
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
