enum CollectionState {
  pending(persianName: "در انتظار", serverKey: 0),
  accept(persianName: "تایید شده", serverKey: 1),
  reject(persianName: "رد شده", serverKey: 2);

  final String persianName;
  final int serverKey;

  const CollectionState({required this.persianName, required this.serverKey});
}

class Collection {
  Collection({
    int? id,
    String? owner,
    bool? canEdit,
    String? name,
    String? createdAt,
    int? state,
    String? poster,
    int? user,
  }) {
    _id = id;
    _owner = owner;
    _canEdit = canEdit;
    _name = name;
    _createdAt = createdAt;
    _state = state;
    _poster = poster;
    _user = user;
  }

  Collection.fromJson(dynamic json) {
    _id = json['id'];
    _owner = json['owner'];
    _canEdit = json['can_edit'];
    _name = json['name'];
    _createdAt = json['created_at'];
    _state = json['state'];
    _poster = json['poster'];
    _user = json['user'];
  }

  int? _id;
  String? _owner;
  bool? _canEdit;
  String? _name;
  String? _createdAt;
  int? _state;
  String? _poster;
  int? _user;

  int? get id => _id;

  String? get owner => _owner;

  bool? get canEdit => _canEdit;

  String? get name => _name;

  String? get createdAt => _createdAt;

  CollectionState? get state {
    if (_state != null) {
      for (final s in CollectionState.values) {
        if (s.serverKey == _state) {
          return s;
        }
      }
    }
    return null;
  }

  String? get poster => _poster;

  int? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['owner'] = _owner;
    map['can_edit'] = _canEdit;
    map['name'] = _name;
    map['created_at'] = _createdAt;
    map['state'] = _state;
    map['poster'] = _poster;
    map['user'] = _user;
    return map;
  }
}
