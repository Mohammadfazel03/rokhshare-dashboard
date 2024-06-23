part of 'sliders_table_cubit.dart';

@immutable
sealed class SlidersTableState {
  final int numberPages;
  final int pageIndex;

  const SlidersTableState({required this.numberPages, required this.pageIndex});
}

final class SlidersTableLoading extends SlidersTableState {
  const SlidersTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class SlidersTableError extends SlidersTableState {
  final String error;
  final int? code;

  const SlidersTableError(
      {required this.error,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class SlidersTableSuccess extends SlidersTableState {
  final PageResponse<SliderModel> data;

  const SlidersTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
