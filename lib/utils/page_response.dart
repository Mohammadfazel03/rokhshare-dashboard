class PageResponse<T> {
  PageResponse({int? count, int? totalPages, List<T>? results}) {
    _count = count;
    _results = results;
    _totalPages = totalPages;
  }

  PageResponse.fromJson(dynamic json, T Function(dynamic) fromJson) {
    _count = json['count'];
    _totalPages = json['total_pages'];

    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(fromJson(v));
      });
    }
  }

  int? _count;
  int? _totalPages;
  List<T>? _results;

  int? get count => _count;

  int? get totalPages => _totalPages;

  List<T>? get results => _results;
}
