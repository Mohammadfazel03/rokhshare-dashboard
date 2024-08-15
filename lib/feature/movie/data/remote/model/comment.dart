enum CommentState {
  pending(persianName: "در انتظار", serverKey: 0),
  accept(persianName: "تایید شده", serverKey: 1),
  reject(persianName: "رد شده", serverKey: 2);

  final String persianName;
  final int serverKey;

  const CommentState({required this.persianName, required this.serverKey});
}

class Comment {
  Comment({
    int? id,
    User? user,
    String? comment,
    String? title,
    String? createdAt,
    int? state,
    CommentEpisode? episode,
  }) {
    _id = id;
    _user = user;
    _comment = comment;
    _title = title;
    _createdAt = createdAt;
    _state = state;
    _episode = episode;
  }

  Comment.fromJson(dynamic json) {
    _id = json['id'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _comment = json['comment'];
    _title = json['title'];
    _createdAt = json['created_at'];
    _state = json['state'];
    _episode = json['episode'] != null
        ? CommentEpisode.fromJson(json['episode'])
        : null;
  }

  int? _id;
  User? _user;
  String? _comment;
  String? _title;
  String? _createdAt;
  int? _state;
  CommentEpisode? _episode;

  int? get id => _id;

  User? get user => _user;

  String? get comment => _comment;

  String? get title => _title;

  String? get createdAt => _createdAt;

  CommentEpisode? get episode => _episode;

  CommentState? get state {
    if (_state != null) {
      for (final s in CommentState.values) {
        if (s.serverKey == _state) {
          return s;
        }
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['comment'] = _comment;
    map['title'] = _title;
    map['created_at'] = _createdAt;
    map['state'] = _state;
    if (_episode != null) {
      map['episode'] = _episode?.toJson();
    }
    return map;
  }
}

class CommentEpisode {
  CommentEpisode({
    int? id,
    int? number,
    String? name,
    int? season,
  }) {
    _id = id;
    _number = number;
    _name = name;
    _season = season;
  }

  CommentEpisode.fromJson(dynamic json) {
    _id = json['id'];
    _number = json['number'];
    _name = json['name'];
    _season = json['season'];
  }

  int? _id;
  int? _number;
  String? _name;
  int? _season;

  int? get id => _id;

  int? get number => _number;

  String? get name => _name;

  int? get season => _season;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['number'] = _number;
    map['name'] = _name;
    map['season'] = _season;
    return map;
  }
}

class User {
  User({
    int? id,
    String? fullName,
    String? username,
  }) {
    _id = id;
    _fullName = fullName;
    _username = username;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _fullName = json['full_name'];
    _username = json['username'];
  }

  int? _id;
  String? _fullName;
  String? _username;

  int? get id => _id;

  String? get fullName => _fullName;

  String? get username => _username;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['full_name'] = _fullName;
    map['username'] = _username;
    return map;
  }
}
