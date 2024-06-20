part of 'recently_user_cubit.dart';

@immutable
sealed class RecentlyUserState {}

final class RecentlyUserLoading extends RecentlyUserState {}

final class RecentlyUserError extends RecentlyUserState {
  final String error;
  final int? code;

  RecentlyUserError({required this.error, this.code});

}

final class RecentlyUserSuccess extends RecentlyUserState {
  final List<User> data;

  RecentlyUserSuccess({required this.data});
}