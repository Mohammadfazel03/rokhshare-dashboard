import '../../../../movie/data/remote/model/movie.dart';

class Series {
  Series({
    int? id,
    Media? media,
    double? rating,
    int? seasonNumber,
    int? episodeNumber,
  }) {
    _id = id;
    _media = media;
    _rating = rating;
    _seasonNumber = seasonNumber;
    _episodeNumber = episodeNumber;
  }

  Series.fromJson(dynamic json) {
    _id = json['id'];
    _media = json['media'] != null ? Media.fromJson(json['media']) : null;
    _rating = json['rating'];
    _seasonNumber = json['season_number'];
    _episodeNumber = json['episode_number'];
  }

  int? _id;
  Media? _media;
  double? _rating;
  int? _seasonNumber;
  int? _episodeNumber;

  int? get id => _id;

  Media? get media => _media;

  double? get rating => _rating;

  int? get seasonNumber => _seasonNumber;

  int? get episodeNumber => _episodeNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_media != null) {
      map['media'] = _media?.toJson();
    }
    map['rating'] = _rating;
    map['season_number'] = _seasonNumber;
    map['episode_number'] = _episodeNumber;
    return map;
  }
}
