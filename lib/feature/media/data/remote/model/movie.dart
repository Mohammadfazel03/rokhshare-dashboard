import 'package:dashboard/feature/media/data/remote/model/genre.dart';

class Movie {
  Movie(
      {String? name,
      List<Genre>? genres,
      String? releaseDate,
      String? value,
      List<Country>? countries,
      int? id}) {
    _id = id;
    _name = name;
    _genres = genres;
    _releaseDate = releaseDate;
    _value = value;
    _countries = countries;
  }

  Movie.fromJson(dynamic json) {
    var valueType = {
      "Free": "رایگان",
      "Subscription": "اشتراکی",
      "Advertising": "نیمه رایگان"
    };
    _name = json['name'];
    if (json['genres'] != null) {
      _genres = [];
      json['genres'].forEach((v) {
        _genres?.add(Genre.fromJson(v));
      });
    }
    _releaseDate = json['release_date'];
    _value = valueType[json['value']];
    _id = json['id'];
    if (json['countries'] != null) {
      _countries = [];
      json['countries'].forEach((v) {
        _countries?.add(Country.fromJson(v));
      });
    }
  }

  String? _name;
  List<Genre>? _genres;
  String? _releaseDate;
  String? _value;
  List<Country>? _countries;
  int? _id;

  String? get name => _name;

  List<Genre>? get genres => _genres;

  String? get releaseDate => _releaseDate;

  String? get value => _value;

  int? get id => _id;

  List<Country>? get countries => _countries;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    if (_genres != null) {
      map['genres'] = _genres?.map((v) => v.toJson()).toList();
    }
    map['release_date'] = _releaseDate;
    map['value'] = _value;
    if (_countries != null) {
      map['countries'] = _countries?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Country {
  Country({
    int? id,
    String? name,
    String? flag,
  }) {
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

