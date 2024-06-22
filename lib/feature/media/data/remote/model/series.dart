class Series {
  Series({
      String? name, 
      List<Genre>? genres,
      String? releaseDate, 
      String? value, 
      List<Country>? countries,
      int? id, 
      int? seasonNumber, 
      int? episodeNumber,}){
    _name = name;
    _genres = genres;
    _releaseDate = releaseDate;
    _value = value;
    _countries = countries;
    _id = id;
    _seasonNumber = seasonNumber;
    _episodeNumber = episodeNumber;
}

  Series.fromJson(dynamic json) {
    _name = json['name'];
    if (json['genres'] != null) {
      _genres = [];
      json['genres'].forEach((v) {
        _genres?.add(Genre.fromJson(v));
      });
    }
    _releaseDate = json['release_date'];
    _value = json['value'];
    if (json['countries'] != null) {
      _countries = [];
      json['countries'].forEach((v) {
        _countries?.add(Country.fromJson(v));
      });
    }
    _id = json['id'];
    _seasonNumber = json['season_number'];
    _episodeNumber = json['episode_number'];
  }
  String? _name;
  List<Genre>? _genres;
  String? _releaseDate;
  String? _value;
  List<Country>? _countries;
  int? _id;
  int? _seasonNumber;
  int? _episodeNumber;

  String? get name => _name;
  List<Genre>? get genres => _genres;
  String? get releaseDate => _releaseDate;
  String? get value => _value;
  List<Country>? get countries => _countries;
  int? get id => _id;
  int? get seasonNumber => _seasonNumber;
  int? get episodeNumber => _episodeNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    if (_genres != null) {
      map['genres'] = _genres?.map((v) => v.toJson()).toList();
    }
    map['release_date'] = _releaseDate;
    map['value'] = _value;
    if (_countries != null) {
      map['countries'] = _countries?.map((v) => v.toJson()).toList();
    }
    map['id'] = _id;
    map['season_number'] = _seasonNumber;
    map['episode_number'] = _episodeNumber;
    return map;
  }

}

class Country {
  Country({
      int? id, 
      String? name, 
      String? flag,}){
    _id = id;
    _name = name;
    _flag = flag;
}

  Country.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _flag = json['flag'];
  }
  int? _id;
  String? _name;
  String? _flag;

  int? get id => _id;
  String? get name => _name;
  String? get flag => _flag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['flag'] = _flag;
    return map;
  }

}

class Genre {
  Genre({
      int? id, 
      String? title, 
      String? poster,}){
    _id = id;
    _title = title;
    _poster = poster;
}

  Genre.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _poster = json['poster'];
  }
  int? _id;
  String? _title;
  String? _poster;

  int? get id => _id;
  String? get title => _title;
  String? get poster => _poster;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['poster'] = _poster;
    return map;
  }

}