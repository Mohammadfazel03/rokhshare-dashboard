class LoginResponse {
  LoginResponse({
      String? refresh, 
      String? access,}){
    _refresh = refresh;
    _access = access;
}

  LoginResponse.fromJson(dynamic json) {
    _refresh = json['refresh'];
    _access = json['access'];
  }
  String? _refresh;
  String? _access;

  String? get refresh => _refresh;
  String? get access => _access;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refresh'] = _refresh;
    map['access'] = _access;
    return map;
  }

}