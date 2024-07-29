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

  @override
  String toString() {
    return "Country $id $name";
  }

  @override
  bool operator ==(Object other) {
    if (other is Country) {
      return other.id == id;
    }
    return false;
  }
}