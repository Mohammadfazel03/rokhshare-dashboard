import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/entity/cast.dart';

class Episode {
  Episode({
    int? id,
    List<Cast>? casts,
    int? commentsCount,
    int? number,
    String? name,
    int? time,
    String? synopsis,
    String? thumbnail,
    String? poster,
    String? publicationDate,
    int? season,
    int? video,
    int? trailer,
  }) {
    _id = id;
    _casts = casts;
    _commentsCount = commentsCount;
    _number = number;
    _name = name;
    _time = time;
    _synopsis = synopsis;
    _thumbnail = thumbnail;
    _poster = poster;
    _publicationDate = publicationDate;
    _season = season;
    _video = video;
    _trailer = trailer;
  }

  Episode.fromJson(dynamic json) {
    _id = json['id'];
    if (json['casts'] != null) {
      _casts = [];
      json['casts'].forEach((v) {
        _casts?.add(Cast.fromJson(v));
      });
    }
    _commentsCount = json['comments_count'];
    _number = json['number'];
    _name = json['name'];
    _time = json['time'];
    _synopsis = json['synopsis'];
    _thumbnail = json['thumbnail'];
    _poster = json['poster'];
    _publicationDate = json['publication_date'];
    _season = json['season'];
    _video = json['video'];
    _trailer = json['trailer'];
  }

  int? _id;
  List<Cast>? _casts;
  int? _commentsCount;
  int? _number;
  String? _name;
  int? _time;
  String? _synopsis;
  String? _thumbnail;
  String? _poster;
  String? _publicationDate;
  int? _season;
  int? _video;
  int? _trailer;

  int? get id => _id;

  List<Cast>? get casts => _casts;

  int? get commentsCount => _commentsCount;

  int? get number => _number;

  String? get name => _name;

  int? get time => _time;

  String? get synopsis => _synopsis;

  String? get thumbnail => _thumbnail;

  String? get poster => _poster;

  String? get publicationDate => _publicationDate;

  int? get season => _season;

  int? get video => _video;

  int? get trailer => _trailer;

  String? get humanizeTime {
    if (_time != null) {
      var allSec = _time! * 60;
      var hour = (allSec / 3600).floor();
      var min = ((allSec % 3600) / 60).floor();
      var second = allSec % 60;
      String temp = "";
      if (hour > 0) {
        if (hour < 10) {
          temp += '0$hour:';
        } else {
          temp += "$hour:";
        }
      }
      if (min > 0) {
        if (min < 10) {
          temp += '0$min:';
        } else {
          temp += "$min:";
        }
      }
      if (second < 10) {
        temp += '0$second';
      } else {
        temp += "$second";
      }
      return temp;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_casts != null) {
      map['casts'] = _casts?.map((v) => v.toJson()).toList();
    }
    map['comments_count'] = _commentsCount;
    map['number'] = _number;
    map['name'] = _name;
    map['time'] = _time;
    map['synopsis'] = _synopsis;
    map['thumbnail'] = _thumbnail;
    map['poster'] = _poster;
    map['publication_date'] = _publicationDate;
    map['season'] = _season;
    map['video'] = _video;
    map['trailer'] = _trailer;
    return map;
  }
}
