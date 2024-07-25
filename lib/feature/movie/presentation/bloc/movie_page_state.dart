part of 'movie_page_cubit.dart';

@immutable
sealed class MoviePageState {}

final class MoviePageInitial extends MoviePageState {}
final class MoviePageLoading extends MoviePageState {}
final class MoviePageSuccess extends MoviePageState {}
final class MoviePageFail extends MoviePageState {
  final String message;
  final int? code;

  MoviePageFail({required this.message, this.code});
}
