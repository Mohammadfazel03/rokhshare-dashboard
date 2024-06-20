import 'dart:async';
import 'package:dashboard/feature/dashboard/data/remote/model/comment.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/header_information.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/plan.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/user.dart';
import 'package:dashboard/utils/data_response.dart';

abstract class DashboardRepository {

  Future<DataResponse<HeaderInformation>> getHeaderInformation();

  Future<DataResponse<List<User>>> getRecentlyUser();

  Future<DataResponse<List<Plan>>> getPopularPlan();

  Future<DataResponse<List<Comment>>> getRecentlyComment();
}