import 'package:dio/dio.dart';

class AdvertiseApiService {
  final Dio _dio;

  AdvertiseApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> getPlans({int page = 1}) async {
    return await _dio.get("plan", queryParameters: {"page": page});
  }

  Future<dynamic> changePlanState(
      {required int planId, required bool isEnable}) async {
    return await _dio.patch("plan/$planId/",
        data: FormData.fromMap({"is_enable": isEnable}));
  }

  Future<dynamic> addPlan(
      {required String title,
      required String description,
      required int days,
      required int price}) async {
    return await _dio.post("plan/",
        data: FormData.fromMap({
          "title": title,
          "description": description,
          "days": days,
          "price": price
        }));
  }

  Future<dynamic> getPlan({required int id}) async {
    return await _dio.get("plan/$id/");
  }

  Future<dynamic> getAdvertises({int page = 1}) async {
    return await _dio.get("advertise/", queryParameters: {"page": page});
  }

  Future<dynamic> editAdvertise(
      {required int id,
      String? title,
      int? numberRepeated,
      int? fileId,
      int? time}) async {
    Map<String, dynamic> values = {};

    if (title != null) {
      values['title'] = title;
    }
    if (numberRepeated != null) {
      values['number_repeated'] = numberRepeated;
    }
    if (fileId != null) {
      values['file'] = fileId;
    }

    if (time != null) {
      values['time'] = time;
    }
    return await _dio.patch("advertise/$id/", data: FormData.fromMap(values));
  }

  Future<dynamic> addAdvertise(
      {required String title,
      required int numberRepeated,
      required int fileId,
      required int time}) async {
    return await _dio.post("advertise/",
        data: FormData.fromMap({
          "title": title,
          "number_repeated": numberRepeated,
          "file": fileId,
          "time": time
        }));
  }

  Future<dynamic> getAdvertise({required int id}) async {
    return await _dio.get("advertise/$id/");
  }

  Future<dynamic> deleteAdvertise({required int id}) async {
    return await _dio.delete("advertise/$id/");
  }
}
