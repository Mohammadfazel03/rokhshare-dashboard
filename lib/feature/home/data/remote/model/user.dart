class User {
  final String username;
  final String fullName;
  final bool isPremium;
  final String dateJoined;
  final int seenMovies;

  User(
      {required this.username,
      required this.fullName,
      required this.isPremium,
      required this.dateJoined,
      required this.seenMovies});
}
