class User {
  User({
      String? username, 
      String? dateJoined, 
      bool? isPremium, 
      int? seenMovies, 
      String? fullName,}){
    _username = username;
    _dateJoined = dateJoined;
    _isPremium = isPremium;
    _seenMovies = seenMovies;
    _fullName = fullName;
}

  User.fromJson(dynamic json) {
    _username = json['username'];
    _dateJoined = json['date_joined'];
    _isPremium = json['is_premium'];
    _seenMovies = json['seen_movies'];
    _fullName = json['full_name'];
  }
  String? _username;
  String? _dateJoined;
  bool? _isPremium;
  int? _seenMovies;
  String? _fullName;

  String? get username => _username;
  String? get dateJoined => _dateJoined;
  bool? get isPremium => _isPremium;
  int? get seenMovies => _seenMovies;
  String? get fullName => _fullName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['date_joined'] = _dateJoined;
    map['is_premium'] = _isPremium;
    map['seen_movies'] = _seenMovies;
    map['full_name'] = _fullName;
    return map;
  }

}