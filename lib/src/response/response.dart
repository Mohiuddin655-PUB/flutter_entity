part 'extensions.dart';
part 'messages.dart';
part 'status.dart';

class Response<T extends Object> {
  final int requestCode;

  int? _count;
  T? _data;
  List<T>? _backups;
  List<T>? _ignores;
  List<T>? _result;
  List<T>? _resultByMe;
  List<String>? _selections;
  double? _progress;
  Status? _status;
  String? _error;
  String? _message;
  dynamic feedback;
  dynamic snapshot;

  bool get isAvailable => status == Status.available;

  bool get isBackup => backups.isNotEmpty;

  bool get isCancel => status == Status.canceled;

  bool get isComplete => status == Status.completed;

  bool get isError {
    return status == Status.error ||
        (_error?.isNotEmpty ?? status.isExceptionMode);
  }

  bool get isExistByMe => resultByMe.isNotEmpty;

  bool get isFailed => status == Status.failure;

  bool get isIgnored => ignores.isNotEmpty;

  bool get isInternetError => status == Status.networkError;

  bool get isLoaded => !isLoading;

  bool get isLoading => status == Status.loading;

  bool get isMessage => _message?.isNotEmpty ?? status.isMessageMode;

  bool get isNullable => status == Status.notFound;

  bool get isPaused => status == Status.paused;

  bool get isStopped => status == Status.stopped;

  bool get isSuccessful => status.isSuccessful;

  bool get isTimeout => status == Status.timeOut;

  bool get isValid => isSuccessful && data != null && result.isNotEmpty;

  int get count => _count ?? result.length;

  T? get data => _data ?? result.firstOrNull;

  List<T> get backups => _backups ?? [];

  List<T> get ignores => _ignores ?? [];

  List<T> get result => _result ?? [if (_data != null) _data!];

  List<T> get resultByMe => _resultByMe ?? [];

  List<String> get selections => _selections ?? [];

  double get progress => _progress ?? 0;

  Status get status => _status ?? Status.none;

  String get error => _error ?? status.error;

  String get message => _message ?? status.message;

  bool isExist(String id) => selections.contains(id);

  T? elementOf(bool Function(T) test, [int? index]) {
    try {
      if (index == null) return result.firstWhere(test);
      return result[index];
    } catch (_) {
      return null;
    }
  }

  Snapshot? getSnapshot<Snapshot>() => snapshot is Snapshot ? snapshot : null;

  Response({
    this.requestCode = 0,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    double? progress,
    Status? status,
    String? error,
    String? message,
    this.feedback,
    this.snapshot,
    int? count,
    List<T>? resultByMe,
    List<String>? selections,
  })  : _data = data,
        _backups = backups,
        _ignores = ignores,
        _result = result,
        _progress = progress,
        _error = error,
        _message = message,
        _count = count,
        _resultByMe = resultByMe ?? [],
        _selections = selections ?? [],
        _status = status ??= (data != null || result != null)
            ? Status.ok
            : (error ?? '').isNotEmpty
                ? Status.error
                : null;

  factory Response.failure(Object? error) {
    return Response(
      status: Status.failure,
      error: error.toString(),
    );
  }

  factory Response.ok({
    int? count,
    T? data,
    List<T>? result,
    String? message,
    Object? feedback,
    dynamic snapshot,
    List<T>? resultByMe,
    List<String>? selections,
  }) {
    return Response(
      status: Status.ok,
      data: data,
      result: result,
      message: message,
      feedback: feedback,
      snapshot: snapshot,
      count: count,
      resultByMe: resultByMe,
      selections: selections,
    );
  }

  static Response<E> convert<E extends Object, T extends Object>(
    Response<T> response,
    E Function(T) converter,
  ) {
    return Response<E>(
      count: response._count,
      requestCode: response.requestCode,
      data: response._data != null ? converter(response._data!) : null,
      backups: response._backups?.map(converter).toList(),
      ignores: response._ignores?.map(converter).toList(),
      result: response._result?.map(converter).toList(),
      resultByMe: response._resultByMe?.map(converter).toList(),
      progress: response._progress,
      status: response._status,
      error: response._error,
      message: response._message,
      feedback: response.feedback,
      snapshot: response.snapshot,
      selections: response._selections,
    );
  }

  Response<T> selection(String Function(T) id) {
    _selections = _result?.map(id).toList();
    return this;
  }

  Response<T> copyWith({
    int? count,
    int? requestCode,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    List<T>? resultByMe,
    List<String>? selections,
    double? progress,
    Status? status,
    String? error,
    String? message,
    dynamic feedback,
    dynamic snapshot,
  }) {
    return Response<T>(
      count: count ?? _count,
      data: data ?? _data,
      error: error ?? _error,
      feedback: feedback ?? this.feedback,
      message: message ?? _message,
      progress: progress ?? _progress,
      requestCode: requestCode ?? this.requestCode,
      backups: backups ?? _backups,
      ignores: ignores ?? _ignores,
      result: result ?? _result,
      resultByMe: resultByMe ?? this.resultByMe,
      snapshot: snapshot ?? this.snapshot,
      status: status ?? _status,
      selections: selections ?? this.selections,
    );
  }

  Response<T> modifyWith({
    int? count,
    int? requestCode,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    List<T>? resultByMe,
    List<String>? selections,
    double? progress,
    Status? status,
    String? exception,
    String? message,
    dynamic feedback,
    dynamic snapshot,
  }) {
    status ??= (data != null || result != null)
        ? Status.ok
        : (exception ?? '').isNotEmpty
            ? Status.error
            : null;
    _count = count ?? _count;
    _data = data ?? _data;
    _backups = backups ?? _backups;
    _ignores = ignores ?? _ignores;
    _result = result ?? _result;
    _resultByMe = resultByMe ?? _resultByMe;
    _progress = progress ?? _progress;
    _status = status ?? _status;
    _selections = selections ?? _selections;
    _error = exception ?? _error;
    _message = message ?? _message;
    this.feedback = feedback ?? this.feedback;
    this.snapshot = snapshot ?? this.snapshot;
    return this;
  }

  @override
  int get hashCode =>
      requestCode.hashCode ^
      feedback.hashCode ^
      snapshot.hashCode ^
      _count.hashCode ^
      _status.hashCode ^
      _progress.hashCode ^
      _error.hashCode ^
      _message.hashCode ^
      _backups.hashCode ^
      _data.hashCode ^
      _ignores.hashCode ^
      _result.hashCode ^
      _resultByMe.hashCode ^
      _selections.hashCode;

  String get beautify {
    return "Response {\n"
        "\tBackups        : $backups\n"
        "\tCount          : $count\n"
        "\tData           : $data\n"
        "\tException      : $error\n"
        "\tFeedback       : $feedback\n"
        "\tIgnores        : $ignores\n"
        "\tMessage        : $message\n"
        "\tProgress       : $progress\n"
        "\tRequest Code   : $requestCode\n"
        "\tResult         : $result\n"
        "\tResultByMe     : $resultByMe\n"
        "\tSnapshot       : $snapshot\n"
        "\tSelections     : $selections\n"
        "\tStatus         : $status\n"
        "}";
  }

  @override
  String toString() {
    return "Response (Request Code: $requestCode, Progress: $progress, Status: $status, Exception: $error, Message: $message, Feedback: $feedback, Snapshot: $snapshot, Data: $data, Result: $result, Backups: $backups, Ignores: $ignores)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Response &&
        other.requestCode == requestCode &&
        other.feedback == feedback &&
        other.snapshot == snapshot &&
        other._count == _count &&
        other._status == _status &&
        other._progress == _progress &&
        other._error == _error &&
        other._message == _message &&
        other._backups == _backups &&
        other._data == _data &&
        other._ignores == _ignores &&
        other._result == _result &&
        other._resultByMe == _resultByMe &&
        other._selections == _selections;
  }
}
