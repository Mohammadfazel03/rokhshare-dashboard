import 'dart:async';

import 'package:dashboard/feature/dashboard/data/remote/model/ads.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/comment.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/header_information.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/plan.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/slider.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/user.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';

abstract class DashboardRepository {

  Future<DataResponse<HeaderInformation>> getHeaderInformation();

  Future<DataResponse<PageResponse<User>>> getRecentlyUser({int page = 1});

  Future<DataResponse<List<Plan>>> getPopularPlan();

  Future<DataResponse<List<Comment>>> getRecentlyComment();

  Future<DataResponse<List<SliderModel>>> getSlider();

  Future<DataResponse<List<Advertise>>> getAdvertise();
}