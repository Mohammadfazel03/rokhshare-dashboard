part of 'recently_advertise_cubit.dart';

@immutable
sealed class RecentlyAdvertiseState {}

final class RecentlyAdvertiseLoading extends RecentlyAdvertiseState {}

final class RecentlyAdvertiseError extends RecentlyAdvertiseState {
  final String error;
  final int? code;

  RecentlyAdvertiseError({required this.error, this.code});
}

final class RecentlyAdvertiseSuccessful extends RecentlyAdvertiseState {
  final List<Advertise> data;

  RecentlyAdvertiseSuccessful({required this.data});
}
