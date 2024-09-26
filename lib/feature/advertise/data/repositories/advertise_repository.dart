import 'package:dashboard/feature/dashboard/data/remote/model/ads.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/plan.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';

abstract class AdvertiseRepository {
  Future<DataResponse<PageResponse<Plan>>> getPlans({int page = 1});

  Future<DataResponse<Plan>> getPlan({required int id});

  Future<DataResponse<void>> addPlan(
      {required String title,
      required String description,
      required int days,
      required int price});

  Future<DataResponse<void>> changePlanState(
      {required int planId, required bool isEnable});

  Future<DataResponse<PageResponse<Advertise>>> getAdvertises({int page = 1});

  Future<DataResponse<Advertise>> getAdvertise({required int id});

  Future<DataResponse<void>> deleteAdvertise({required int id});

  Future<DataResponse<void>> addAdvertise(
      {required String title,
      required int numberRepeated,
      required int fileId,
      required int time});

  Future<DataResponse<void>> editAdvertise(
      {required int id,
      String? title,
      int? numberRepeated,
      int? fileId,
      int? time});
}
