part of 'plan_table_cubit.dart';

@immutable
sealed class PlanTableState {
  final int numberPages;
  final int pageIndex;

  const PlanTableState({required this.numberPages, required this.pageIndex});
}

final class PlanTableLoading extends PlanTableState {
  const PlanTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class PlanTableError extends PlanTableState {
  final String error;
  final int? code;
  final String title;

  const PlanTableError(
      {required this.error,
      required this.title,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class PlanTableSuccess extends PlanTableState {
  final PageResponse<Plan> data;

  const PlanTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
