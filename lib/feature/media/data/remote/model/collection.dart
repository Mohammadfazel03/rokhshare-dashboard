class Collection {
  Collection({
      int? id, 
      String? owner, 
      bool? canEdit, 
      String? name, 
      String? createdAt, 
      bool? isConfirm, 
      String? poster, 
      int? user,}){
    _id = id;
    _owner = owner;
    _canEdit = canEdit;
    _name = name;
    _createdAt = createdAt;
    _isConfirm = isConfirm;
    _poster = poster;
    _user = user;
}

  Collection.fromJson(dynamic json) {
    _id = json['id'];
    _owner = json['owner'];
    _canEdit = json['can_edit'];
    _name = json['name'];
    _createdAt = json['created_at'];
    _isConfirm = json['is_confirm'];
    _poster = json['poster'];
    _user = json['user'];
  }
  int? _id;
  String? _owner;
  bool? _canEdit;
  String? _name;
  String? _createdAt;
  bool? _isConfirm;
  String? _poster;
  int? _user;

  int? get id => _id;
  String? get owner => _owner;
  bool? get canEdit => _canEdit;
  String? get name => _name;
  String? get createdAt => _createdAt;
  bool? get isConfirm => _isConfirm;
  String? get poster => _poster;
  int? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['owner'] = _owner;
    map['can_edit'] = _canEdit;
    map['name'] = _name;
    map['created_at'] = _createdAt;
    map['is_confirm'] = _isConfirm;
    map['poster'] = _poster;
    map['user'] = _user;
    return map;
  }

}