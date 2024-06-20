class Advertise {
  Advertise({
    String? title,
    String? createdAt,
    int? viewNumber,
    int? mustPlayed,
  }) {
    _title = title;
    _createdAt = createdAt;
    _viewNumber = viewNumber;
    _mustPlayed = mustPlayed;
  }

  Advertise.fromJson(dynamic json) {
    _title = json['title'];
    _createdAt = json['created_at'];
    _viewNumber = json['view_number'];
    _mustPlayed = json['must_played'];
  }

  String? _title;
  String? _createdAt;
  int? _viewNumber;
  int? _mustPlayed;

  String? get title => _title;

  String? get createdAt => _createdAt;

  int? get viewNumber => _viewNumber;

  int? get mustPlayed => _mustPlayed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['created_at'] = _createdAt;
    map['view_number'] = _viewNumber;
    map['must_played'] = _mustPlayed;
    return map;
  }
}
