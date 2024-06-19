import 'dart:async';

import 'package:dashboard/feature/dashboard/data/remote/model/header_information.dart';
import 'package:dashboard/utils/data_response.dart';

abstract class DashboardRepository {

  Future<DataResponse<HeaderInformation>> getHeaderInformation();
}