abstract class DataResponse<T> {
  final T? data;
  final String? error;
  final int? code;

  const DataResponse(this.data, this.error, this.code);
}

class DataSuccess<T> extends DataResponse<T> {
  const DataSuccess(T? data) : super(data, null, null);
}

class DataFailed<T> extends DataResponse<T> {
  const DataFailed(String error, {int? code}) : super(null, error, code);
}
