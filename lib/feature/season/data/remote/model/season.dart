class Season {
  Season({
    int? id,
    int? episodeNumber,
    int? number,
    String? name,
    String? thumbnail,
    String? poster,
    String? publicationDate,
    int? series,
  }) {
    _id = id;
    _episodeNumber = episodeNumber;
    _number = number;
    _name = name;
    _thumbnail = thumbnail;
    _poster = poster;
    _publicationDate = publicationDate;
    _series = series;
  }

  Season.fromJson(dynamic json) {
    _id = json['id'];
    _episodeNumber = json['episode_number'];
    _number = json['number'];
    _name = json['name'];
    _thumbnail = json['thumbnail'];
    _poster = json['poster'];
    _publicationDate = json['publication_date'];
    _series = json['series'];
  }

  int? _id;
  int? _episodeNumber;
  int? _number;
  String? _name;
  String? _thumbnail;
  String? _poster;
  String? _publicationDate;
  int? _series;

  int? get id => _id;

  int? get episodeNumber => _episodeNumber;

  int? get number => _number;

  String? get name => _name;

  String? get thumbnail => _thumbnail;

  String? get poster => _poster;

  String? get publicationDate => _publicationDate;

  int? get series => _series;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['episode_number'] = _episodeNumber;
    map['number'] = _number;
    map['name'] = _name;
    map['thumbnail'] = _thumbnail;
    map['poster'] = _poster;
    map['publication_date'] = _publicationDate;
    map['series'] = _series;
    return map;
  }
}
