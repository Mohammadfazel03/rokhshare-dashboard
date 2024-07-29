import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/entity/cast.dart';
import 'package:dashboard/feature/movie/presentation/widget/value_section_widget/bloc/value_section_cubit.dart';

class Movie {
  Movie({
    int? id,
    Media? media,
    List<Cast>? casts,
    num? rating,
    MediaFile? video,
    int? time,
  }) {
    _id = id;
    _media = media;
    _casts = casts;
    _rating = rating;
    _video = video;
    _time = time;
  }

  Movie.fromJson(dynamic json) {
    _id = json['id'];
    _media = json['media'] != null ? Media.fromJson(json['media']) : null;
    if (json['casts'] != null) {
      _casts = [];
      json['casts'].forEach((v) {
        _casts?.add(Cast.fromJson(v));
      });
    }
    _rating = json['rating'];
    _video = json['video'] != null ? MediaFile.fromJson(json['video']) : null;
    _time = json['time'];
  }

  int? _id;
  Media? _media;
  List<Cast>? _casts;
  num? _rating;
  MediaFile? _video;
  int? _time;

  int? get id => _id;

  Media? get media => _media;

  List<Cast>? get casts => _casts;

  num? get rating => _rating;

  MediaFile? get video => _video;

  int? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_media != null) {
      map['media'] = _media?.toJson();
    }
    if (_casts != null) {
      map['casts'] = _casts?.map((v) => v.toJson()).toList();
    }
    map['rating'] = _rating;
    map['video'] = _video?.toJson();
    map['time'] = _time;
    return map;
  }
}

class Media {
  Media({
    int? id,
    List<Genre>? genres,
    List<Country>? countries,
    MediaFile? trailer,
    String? name,
    String? synopsis,
    String? thumbnail,
    String? poster,
    String? value,
    String? releaseDate,
  }) {
    _id = id;
    _genres = genres;
    _countries = countries;
    _trailer = trailer;
    _name = name;
    _synopsis = synopsis;
    _thumbnail = thumbnail;
    _poster = poster;
    _value = value;
    _releaseDate = releaseDate;
  }

  Media.fromJson(dynamic json) {
    _id = json['id'];
    if (json['genres'] != null) {
      _genres = [];
      json['genres'].forEach((v) {
        _genres?.add(Genre.fromJson(v));
      });
    }
    if (json['countries'] != null) {
      _countries = [];
      json['countries'].forEach((v) {
        _countries?.add(Country.fromJson(v));
      });
    }
    _trailer =
        json['trailer'] != null ? MediaFile.fromJson(json['trailer']) : null;
    _name = json['name'];
    _synopsis = json['synopsis'];
    _thumbnail = json['thumbnail'];
    _poster = json['poster'];
    _value = json['value'];
    _releaseDate = json['release_date'];
  }

  int? _id;
  List<Genre>? _genres;
  List<Country>? _countries;
  MediaFile? _trailer;
  String? _name;
  String? _synopsis;
  String? _thumbnail;
  String? _poster;
  String? _value;
  String? _releaseDate;

  int? get id => _id;

  List<Genre>? get genres => _genres;

  List<Country>? get countries => _countries;

  MediaFile? get trailer => _trailer;

  String? get name => _name;

  String? get synopsis => _synopsis;

  String? get thumbnail => _thumbnail;

  String? get poster => _poster;

  // String? get value => _value;
  MediaValue? get value {
    if (_value != null) {
      for (final v in MediaValue.values) {
        if (v.serverNameSpace == _value) {
          return v;
        }
      }
    }
    return null;
  }

  String? get releaseDate => _releaseDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_genres != null) {
      map['genres'] = _genres?.map((v) => v.toJson()).toList();
    }
    if (_countries != null) {
      map['countries'] = _countries?.map((v) => v.toJson()).toList();
    }
    map['trailer'] = _trailer?.toJson();
    map['name'] = _name;
    map['synopsis'] = _synopsis;
    map['thumbnail'] = _thumbnail;
    map['poster'] = _poster;
    map['value'] = _value;
    map['release_date'] = _releaseDate;
    return map;
  }
}

class MediaFile {
  MediaFile({
    String? file,
    int? id,
  }) {
    _file = file;
    _id = id;
  }

  MediaFile.fromJson(dynamic json) {
    _file = json['file'];
    _id = json['id'];
  }

  String? _file;
  int? _id;

  String? get file => _file;

  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file'] = _file;
    map['id'] = _id;
    return map;
  }
}
