import 'package:dashboard/feature/movie/data/remote/model/comment.dart';

class Comment {
  Comment({
    String? comment,
    String? createdAt,
    int? state,
    String? username,
    Media? media,
  }) {
    _comment = comment;
    _createdAt = createdAt;
    _state = state;
    _username = username;
    _media = media;
  }

  Comment.fromJson(dynamic json) {
    _comment = json['comment'];
    _createdAt = json['created_at'];
    _state = json['state'];
    _username = json['username'];
    _media = json['media'] != null ? Media.fromJson(json['media']) : null;
  }

  String? _comment;
  String? _createdAt;
  int? _state;
  String? _username;
  Media? _media;

  String? get comment => _comment;

  String? get createdAt => _createdAt;

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

  String? get username => _username;

  Media? get media => _media;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['comment'] = _comment;
    map['created_at'] = _createdAt;
    map['state'] = _state;
    map['username'] = _username;
    if (_media != null) {
      map['media'] = _media?.toJson();
    }
    return map;
  }
}

class Media {
  Media({
    String? name,
    String? poster,
  }) {
    _name = name;
    _poster = poster;
  }

  Media.fromJson(dynamic json) {
    _name = json['name'];
    _poster = json['poster'];
  }

  String? _name;
  String? _poster;

  String? get name => _name;

  String? get poster => _poster;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['poster'] = _poster;
    return map;
  }
}
