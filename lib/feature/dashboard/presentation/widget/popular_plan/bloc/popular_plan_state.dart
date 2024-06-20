part of 'popular_plan_cubit.dart';

@immutable
sealed class PopularPlanState {}

final class PopularPlanLoading extends PopularPlanState {}
final class PopularPlanError extends PopularPlanState {
  final String error;
  final int? code;

  PopularPlanError({required this.error, this.code});

}
final class PopularPlanSuccessful extends PopularPlanState {
  final List<Plan> data;

  PopularPlanSuccessful({required this.data});
}
