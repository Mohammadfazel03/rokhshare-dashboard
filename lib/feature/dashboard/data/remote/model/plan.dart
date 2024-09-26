class Plan {
  int? _id;
  String? _title;
  int? _days;
  int? _price;
  bool? _isEnable;
  String? _description;

  Plan(
      {String? title,
      int? days,
      int? id,
      int? price,
      bool? isEnable,
      String? description}) {
    _days = days;
    _isEnable = isEnable;
    _price = price;
    _title = title;
    _description = _description;
    _id = id;
  }

  bool? get isEnable => _isEnable;

  int? get price => _price;

  int? get days => _days;

  String? get title => _title;

  String? get description => _description;

  int? get id => _id;

  Plan.fromJson(dynamic json) {
    _title = json['title'];
    _description = json['description'];
    _price = json['price'];
    _isEnable = json['is_enable'];
    _days = json['days'];
    _id = json['id'];
  }
}
