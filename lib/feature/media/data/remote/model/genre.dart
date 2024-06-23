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