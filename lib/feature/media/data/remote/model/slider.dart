import 'package:dashboard/feature/movie/data/remote/model/movie.dart';

class SliderModel {
  SliderModel({
    int? id,
    Media? media,
    String? description,
    String? title,
    int? priority,
    String? thumbnail,
    String? poster,
  }) {
    _id = id;
    _media = media;
    _description = description;
    _title = title;
    _priority = priority;
    _thumbnail = thumbnail;
    _poster = poster;
  }

  SliderModel.fromJson(dynamic json) {
    _id = json['id'];
    _media = json['media'] != null ? Media.fromJson(json['media']) : null;
    _description = json['description'];
    _title = json['title'];
    _priority = json['priority'];
    _thumbnail = json['thumbnail'];
    _poster = json['poster'];
  }

  int? _id;
  Media? _media;
  String? _description;
  String? _title;
  int? _priority;
  String? _thumbnail;
  String? _poster;

  int? get id => _id;

  Media? get media => _media;

  String? get description => _description;

  String? get title => _title;

  int? get priority => _priority;

  String? get thumbnail => _thumbnail;

  String? get poster => _poster;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_media != null) {
      map['media'] = _media?.toJson();
    }
    map['description'] = _description;
    map['title'] = _title;
    map['priority'] = _priority;
    map['thumbnail'] = _thumbnail;
    map['poster'] = _poster;
    return map;
  }
}
