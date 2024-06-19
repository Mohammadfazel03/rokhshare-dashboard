import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/header_information.dart';
import 'package:dashboard/feature/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:meta/meta.dart';

part 'header_information_event.dart';

part 'header_information_state.dart';

class HeaderInformationBloc
    extends Bloc<HeaderInformationEvent, HeaderInformationState> {
  final DashboardRepository _repository;

  HeaderInformationBloc({required DashboardRepository repository})
      : _repository = repository,
        super(HeaderInformationLoading()) {
    on<HeaderInformationEventGetData>((event, emit) async {
      emit(HeaderInformationLoading());
      DataResponse<HeaderInformation> response =
          await _repository.getHeaderInformation();
      if (response is DataFailed) {
        emit(HeaderInformationError(
            error: response.error ?? "مشکلی پیش آمده است",
            code: response.code));
      } else {
        emit(HeaderInformationSuccess(data: response.data!));
      }
    });
  }
}
