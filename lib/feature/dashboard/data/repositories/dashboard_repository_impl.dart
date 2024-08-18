import 'package:dashboard/feature/dashboard/data/remote/dashboard_api_service.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/ads.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/comment.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/header_information.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/plan.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/user.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dio/dio.dart';

import 'dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardApiService _api;

  DashboardRepositoryImpl({required DashboardApiService apiService})
      : _api = apiService;

  @override
  Future<DataResponse<HeaderInformation>> getHeaderInformation() async {
    try {
      Response response = await _api.getHeaderInformation();
      if (response.statusCode == 200) {
        return DataSuccess(HeaderInformation.fromJson(response.data));
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<List<User>>> getRecentlyUser() async {
    try {
      Response response = await _api.getRecentlyUser();
      if (response.statusCode == 200) {
        List<User> users =
            ((response.data) as List).map((e) => User.fromJson(e)).toList();
        return DataSuccess(users);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<List<Plan>>> getPopularPlan() async {
    try {
      Response response = await _api.getPopularPlan();
      if (response.statusCode == 200) {
        List<Plan> plans =
            ((response.data) as List).map((e) => Plan.fromJson(e)).toList();
        return DataSuccess(plans);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<List<Comment>>> getRecentlyComment() async {
    try {
      Response response = await _api.getRecentlyComment();
      if (response.statusCode == 200) {
        List<Comment> comments =
            ((response.data) as List).map((e) => Comment.fromJson(e)).toList();
        return DataSuccess(comments);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<List<SliderModel>>> getSlider() async {
    try {
      Response response = await _api.getSlider();
      if (response.statusCode == 200) {
        List<SliderModel> slider =
        ((response.data) as List).map((e) => SliderModel.fromJson(e)).toList();
        return DataSuccess(slider);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }

  @override
  Future<DataResponse<List<Advertise>>> getAdvertise() async {
    try {
      Response response = await _api.getAdvertise();
      if (response.statusCode == 200) {
        List<Advertise> ads =
        ((response.data) as List).map((e) => Advertise.fromJson(e)).toList();
        return DataSuccess(ads);
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    } catch (e) {
      if (e is DioException) {
        DioException exception = e;
        int cat = ((exception.response?.statusCode ?? 0) / 100).round();
        if (cat == 5) {
          return const DataFailed('سایت در حال تعمیر است بعداً تلاش کنید.');
        }
      }
      return const DataFailed('در برقرای ارتباط مشکلی پیش آمده است.');
    }
  }
}
