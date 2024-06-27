part of 'genre_append_cubit.dart';

@immutable
sealed class GenreAppendState {}

final class GenreAppendInitial extends GenreAppendState {}

final class GenreAppendLoading extends GenreAppendState {}

final class GenreAppendSuccessAppend extends GenreAppendState {}

final class GenreAppendSuccessUpdate extends GenreAppendState {}

final class GenreAppendSuccess extends GenreAppendState {
  final Genre genre;

  GenreAppendSuccess({required this.genre});
}

final class GenreAppendFailed extends GenreAppendState {
  final String message;
  final int? code;

  GenreAppendFailed({required this.message, this.code});
}
