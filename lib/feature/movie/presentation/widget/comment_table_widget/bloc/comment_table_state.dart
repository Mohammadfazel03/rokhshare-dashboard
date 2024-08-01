part of 'comment_table_cubit.dart';

@immutable
sealed class CommentTableState {
  final int numberPages;
  final int pageIndex;

  const CommentTableState({required this.numberPages, required this.pageIndex});
}

final class CommentTableLoading extends CommentTableState {
  const CommentTableLoading({super.numberPages = 0, super.pageIndex = 0});
}

final class CommentTableInitial extends CommentTableState {
  const CommentTableInitial({super.numberPages = 0, super.pageIndex = 0});
}

final class CommentTableError extends CommentTableState {
  final String error;
  final String? title;
  final int? code;

  const CommentTableError(
      {required this.error,
      this.title,
      this.code,
      super.numberPages = 0,
      super.pageIndex = 0});
}

final class CommentTableSuccess extends CommentTableState {
  final PageResponse<Comment> data;

  const CommentTableSuccess(
      {required this.data, super.numberPages = 0, super.pageIndex = 0});
}
