import 'package:dashboard/feature/movie/data/remote/model/movie.dart';

class Advertise {
  Advertise({
    String? title,
    String? createdAt,
    int? viewNumber,
    int? id,
    int? time,
    MediaFile? file,
    int? mustPlayed,
  }) {
    _title = title;
    _id = id;
    _file = file;
    _time = _time;
    _createdAt = createdAt;
    _viewNumber = viewNumber;
    _mustPlayed = mustPlayed;
  }

  Advertise.fromJson(dynamic json) {
    _title = json['title'];
    _createdAt = json['created_at'];
    _viewNumber = json['view_number'];
    _mustPlayed = json['must_played'];
    _time = json['time'];
    _id = json['id'];
    _file = json['file'] != null ? MediaFile.fromJson(json['file']) : null;
    _mustPlayed = json['must_played'];
  }

  String? _title;
  String? _createdAt;
  int? _viewNumber;
  int? _mustPlayed;
  int? _id;
  MediaFile? _file;
  int? _time;

  String? get title => _title;

  String? get createdAt => _createdAt;

  int? get viewNumber => _viewNumber;

  int? get mustPlayed => _mustPlayed;

  MediaFile? get file => _file;

  int? get id => _id;

  int? get time => _time;

  String? get humanizeTime {
    if (_time != null) {
      var hour = (_time! / 3600).floor();
      var min = ((_time! % 3600) / 60).floor();
      var second = _time! % 60;
      String temp = "";
      if (hour > 0) {
        if (hour < 10) {
          temp += '0$hour:';
        } else {
          temp += "$hour:";
        }
      }

      if (min < 10) {
        temp += '0$min:';
      } else {
        temp += "$min:";
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
    map['title'] = _title;
    map['created_at'] = _createdAt;
    map['view_number'] = _viewNumber;
    map['must_played'] = _mustPlayed;
    return map;
  }
}
