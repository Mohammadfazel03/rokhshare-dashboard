class HeaderInformation {
  HeaderInformation({
      int? users, 
      num? userRatio,
      int? movies, 
      num? movieRatio,
      int? ads, 
      num? adsRatio,
      int? vip, 
      num? vipRatio,}){
    _users = users;
    _userRatio = userRatio;
    _movies = movies;
    _movieRatio = movieRatio;
    _ads = ads;
    _adsRatio = adsRatio;
    _vip = vip;
    _vipRatio = vipRatio;
}

  HeaderInformation.fromJson(dynamic json) {
    _users = json['users'];
    _userRatio = json['user_ratio'];
    _movies = json['movies'];
    _movieRatio = json['movie_ratio'];
    _ads = json['ads'];
    _adsRatio = json['ads_ratio'];
    _vip = json['vip'];
    _vipRatio = json['vip_ratio'];
  }
  int? _users;
  num? _userRatio;
  int? _movies;
  num? _movieRatio;
  int? _ads;
  num? _adsRatio;
  int? _vip;
  num? _vipRatio;

  int? get users => _users;
  num? get userRatio => _userRatio;
  int? get movies => _movies;
  num? get movieRatio => _movieRatio;
  int? get ads => _ads;
  num? get adsRatio => _adsRatio;
  int? get vip => _vip;
  num? get vipRatio => _vipRatio;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['users'] = _users;
    map['user_ratio'] = _userRatio;
    map['movies'] = _movies;
    map['movie_ratio'] = _movieRatio;
    map['ads'] = _ads;
    map['ads_ratio'] = _adsRatio;
    map['vip'] = _vip;
    map['vip_ratio'] = _vipRatio;
    return map;
  }

}