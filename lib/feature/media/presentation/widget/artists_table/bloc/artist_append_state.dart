part of 'artist_append_cubit.dart';

@immutable
sealed class ArtistAppendState {}

final class ArtistAppendInitial extends ArtistAppendState {}

final class ArtistAppendLoading extends ArtistAppendState {}

final class ArtistAppendSuccessAppend extends ArtistAppendState {}

final class ArtistAppendSuccessUpdate extends ArtistAppendState {}

final class ArtistAppendSuccess extends ArtistAppendState {
  final Artist artist;

  ArtistAppendSuccess({required this.artist});
}

final class ArtistAppendFailed extends ArtistAppendState {
  final String message;
  final int? code;

  ArtistAppendFailed({required this.message, this.code});
}
