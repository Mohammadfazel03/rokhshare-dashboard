part of 'recently_comment_cubit.dart';

@immutable
sealed class RecentlyCommentState {}

final class RecentlyCommentLoading extends RecentlyCommentState {}
final class RecentlyCommentError extends RecentlyCommentState {
  final String error;
  final int? code;

  RecentlyCommentError({required this.error, this.code});


}
final class RecentlyCommentSuccessful extends RecentlyCommentState {
  final List<Comment> data;

  RecentlyCommentSuccessful({required this.data});
}
