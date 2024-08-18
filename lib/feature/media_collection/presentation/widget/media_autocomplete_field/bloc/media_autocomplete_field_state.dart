part of 'media_autocomplete_field_cubit.dart';

enum PostStatus { initial, success, failure, loading }

class PostError {
  final String? title;
  final String error;
  final int? code;

  PostError({required this.title, required this.error, required this.code});
}

final class MediaAutocompleteFieldState {
  const MediaAutocompleteFieldState(
      {this.status = PostStatus.initial,
      this.media = const <Media>[],
      this.nextPage = 1,
      this.lastPage = 1,
      this.query = '',
      this.error,
      this.hashRequest});

  final PostStatus status;
  final List<Media> media;
  final int nextPage;
  final int lastPage;
  final PostError? error;
  final String query;
  final String? hashRequest;

  MediaAutocompleteFieldState copyWith(
      {PostStatus? status,
      List<Media>? media,
      int? nextPage,
      int? lastPage,
      String? query,
      String? hashRequest,
      PostError? error}) {
    return MediaAutocompleteFieldState(
        status: status ?? this.status,
        media: media ?? this.media,
        nextPage: nextPage ?? this.nextPage,
        lastPage: lastPage ?? this.lastPage,
        query: query ?? this.query,
        error: error,
        hashRequest: hashRequest ?? this.hashRequest);
  }
}
