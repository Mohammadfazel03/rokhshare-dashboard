import 'package:dashboard/feature/movie/data/remote/model/movie.dart';

class Gallery {
  Gallery({
    int? id,
    String? description,
    MediaFile? file,
    String? mimetype,
    String? thumbnail,
  }) {
    _id = id;
    _description = description;
    _file = file;
    _mimetype = mimetype;
    _thumbnail = thumbnail;
  }

  Gallery.fromJson(dynamic json) {
    _id = json['id'];
    _description = json['description'];
    _file = json['file'] != null ? MediaFile.fromJson(json['file']) : null;
    _mimetype = json['mimetype'];
    _thumbnail = json['thumbnail'];
  }

  int? _id;
  String? _description;
  MediaFile? _file;
  String? _mimetype;
  String? _thumbnail;

  int? get id => _id;

  String? get description => _description;

  MediaFile? get file => _file;

  String? get mimetype => _mimetype;

  String? get thumbnail => _thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['description'] = _description;
    if (_file != null) {
      map['file'] = _file?.toJson();
    }
    map['mimetype'] = _mimetype;
    map['thumbnail'] = _thumbnail;
    return map;
  }

  @override
  bool operator ==(Object other) {
    if (other is Gallery) {
      return other.id == id;
    }
    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(id, description, mimetype, thumbnail, file);
}
