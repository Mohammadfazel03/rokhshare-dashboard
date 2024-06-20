class SliderModel {
  SliderModel({
    int? id,
    Media? media,
    String? description,
    String? title,
    int? priority,}){
    _id = id;
    _media = media;
    _description = description;
    _title = title;
    _priority = priority;
  }

  SliderModel.fromJson(dynamic json) {
    _id = json['id'];
    _media = json['media'] != null ? Media.fromJson(json['media']) : null;
    _description = json['description'];
    _title = json['title'];
    _priority = json['priority'];
  }
  int? _id;
  Media? _media;
  String? _description;
  String? _title;
  int? _priority;

  int? get id => _id;
  Media? get media => _media;
  String? get description => _description;
  String? get title => _title;
  int? get priority => _priority;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_media != null) {
      map['media'] = _media?.toJson();
    }
    map['description'] = _description;
    map['title'] = _title;
    map['priority'] = _priority;
    return map;
  }

}

class Media {
  Media({
    String? name,
    String? poster,}){
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