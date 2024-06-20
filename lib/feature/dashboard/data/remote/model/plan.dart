class Plan {
  String? _title;
  int? _days;
  int? _price;
  bool? _isEnable;

  Plan({String? title, int? days, int? price, bool? isEnable}) {
    _days = days;
    _isEnable = isEnable;
    _price = price;
    _title = title;
  }

  bool? get isEnable => _isEnable;

  int? get price => _price;

  int? get days => _days;

  String? get title => _title;

  Plan.fromJson(dynamic json) {
    _title = json['title'];
    _price = json['price'];
    _isEnable = json['is_enable'];
    _days = json['days'];
  }
}
