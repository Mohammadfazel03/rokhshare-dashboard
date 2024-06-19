class HeaderInformation {
  HeaderInformation({
      int? users, 
      double? userRatio,
      int? movies, 
      double? movieRatio,
      int? ads, 
      double? adsRatio,
      int? vip, 
      double? vipRatio,}){
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
  double? _userRatio;
  int? _movies;
  double? _movieRatio;
  int? _ads;
  double? _adsRatio;
  int? _vip;
  double? _vipRatio;

  int? get users => _users;
  double? get userRatio => _userRatio;
  int? get movies => _movies;
  double? get movieRatio => _movieRatio;
  int? get ads => _ads;
  double? get adsRatio => _adsRatio;
  int? get vip => _vip;
  double? get vipRatio => _vipRatio;

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