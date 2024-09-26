part of 'plan_append_cubit.dart';

@immutable
sealed class PlanAppendState {}

final class PlanAppendInitial extends PlanAppendState {}

final class PlanAppendLoading extends PlanAppendState {}

final class PlanAppendSuccessAppend extends PlanAppendState {}

final class PlanAppendSuccess extends PlanAppendState {
  final Plan plan;

  PlanAppendSuccess({required this.plan});
}

final class PlanAppendFailed extends PlanAppendState {
  final String message;
  final int? code;

  PlanAppendFailed({required this.message, this.code});
}
