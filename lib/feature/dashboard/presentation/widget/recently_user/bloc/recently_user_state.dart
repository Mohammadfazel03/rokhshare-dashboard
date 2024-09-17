part of 'recently_user_cubit.dart';

@immutable
sealed class RecentlyUserState {
  final int numberPages;
  final int pageIndex;

  const RecentlyUserState({required this.numberPages, required this.pageIndex});
}

final class RecentlyUserLoading extends RecentlyUserState {
  const RecentlyUserLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class RecentlyUserError extends RecentlyUserState {
  final String error;
  final int? code;
  final String title;

  const RecentlyUserError(
      {required this.error,
      required this.title,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class RecentlyUserSuccess extends RecentlyUserState {
  final PageResponse<User> data;

  const RecentlyUserSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
