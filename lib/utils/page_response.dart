class PageResponse<T> {
  PageResponse({int? count, String? next, String? previous, List<T>? results}) {
    _count = count;
    _next = next;
    _previous = previous;
    _results = results;
  }

  PageResponse.fromJson(dynamic json, T Function(dynamic) fromJson) {
    _count = json['count'];
    _next = json['next'];
    _previous = json['previous'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(fromJson(v));
      });
    }
  }

  int? _count;
  String? _next;
  String? _previous;
  List<T>? _results;

  int? get count => _count;

  String? get next => _next;

  String? get previous => _previous;

  List<T>? get results => _results;

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['next'] = _next;
    map['previous'] = _previous;
    if (_results != null) {
      map['results'] = _results?.map((v) => toJson(v)).toList();
    }
    return map;
  }
}
