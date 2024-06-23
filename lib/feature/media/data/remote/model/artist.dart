class Artist {
  Artist({
      int? id, 
      String? name, 
      String? biography, 
      String? image,}){
    _id = id;
    _name = name;
    _biography = biography;
    _image = image;
}

  Artist.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _biography = json['biography'];
    _image = json['image'];
  }
  int? _id;
  String? _name;
  String? _biography;
  String? _image;

  int? get id => _id;
  String? get name => _name;
  String? get biography => _biography;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['biography'] = _biography;
    map['image'] = _image;
    return map;
  }

}