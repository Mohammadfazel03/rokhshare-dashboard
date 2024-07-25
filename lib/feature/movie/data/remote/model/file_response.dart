class FileResponse {
  FileResponse({
    int? id,
    String? uploadId,
    bool? isComplete,
    int? chunkIndex
  }) {
    _id = id;
    _uploadId = uploadId;
    _isComplete = isComplete;
    _chunkIndex = chunkIndex;
  }

  FileResponse.fromJson(dynamic json) {
    _id = json['id'];
    _uploadId = json['upload_id'];
    _isComplete = json['is_complete'];
    _chunkIndex = json['chunk_index'];
  }

  int? _id;
  String? _uploadId;
  bool? _isComplete;
  int? _chunkIndex;

  int? get id => _id;

  String? get uploadId => _uploadId;

  bool? get isComplete => _isComplete;

  int? get chunkIndex => _chunkIndex;
}
