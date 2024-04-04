class Comment {
  final String username;
  final Media media;
  final String comment;
  final String date;
  final int isPublished;

  Comment(
      {required this.username,
      required this.media,
      required this.comment,
      required this.date,
      required this.isPublished});
}

class Media {
  final String name;
  final String poster;

  Media({required this.name, required this.poster});
}