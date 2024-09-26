part of 'advertise_table_cubit.dart';

@immutable
sealed class AdvertiseTableState {
  final int numberPages;
  final int pageIndex;

  const AdvertiseTableState(
      {required this.numberPages, required this.pageIndex});
}

final class AdvertiseTableLoading extends AdvertiseTableState {
  const AdvertiseTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class AdvertiseTableError extends AdvertiseTableState {
  final String error;
  final int? code;
  final String title;

  const AdvertiseTableError(
      {required this.error,
      required this.title,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class AdvertiseTableSuccess extends AdvertiseTableState {
  final PageResponse<Advertise> data;

  const AdvertiseTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
