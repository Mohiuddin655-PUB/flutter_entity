part 'extensions.dart';
part 'messages.dart';
part 'status.dart';

class Response<T extends Object> {
  final int requestCode;

  T? _data;
  List<T>? _backups;
  List<T>? _result;
  List<T>? _ignores;
  double? _progress;
  Status? _status;
  String? _exception;
  String? _message;
  dynamic feedback;
  dynamic snapshot;

  bool get isAvailable => status == Status.available;

  bool get isBackup => backups.isNotEmpty;

  bool get isCancel => status == Status.canceled;

  bool get isComplete => status == Status.completed;

  bool get isError => status == Status.error;

  bool get isException => _exception?.isNotEmpty ?? status.isExceptionMode;

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

  T? get data => _data ?? result.firstOrNull;

  List<T> get backups => _backups ?? [];

  List<T> get ignores => _ignores ?? [];

  List<T> get result => _result ?? [if (_data != null) _data!];

  double get progress => _progress ?? 0;

  Status get status => _status ?? Status.none;

  String get exception => _exception ?? status.exception;

  String get message => _message ?? status.message;

  Response({
    this.requestCode = 0,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    double? progress,
    Status? status,
    String? exception,
    String? message,
    this.feedback,
    this.snapshot,
  })  : _data = data,
        _backups = backups,
        _ignores = ignores,
        _result = result,
        _progress = progress,
        _status = status,
        _exception = exception,
        _message = message;

  Response<T> from(Response<T> response) {
    return copy(
      data: response._data,
      exception: response._exception,
      feedback: response.feedback,
      message: response._message,
      progress: response._progress,
      requestCode: response.requestCode,
      backups: response._backups,
      ignores: response._ignores,
      result: response._result,
      snapshot: response.snapshot,
      status: response._status,
    );
  }

  Response<T> copy({
    int? requestCode,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
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
    return Response<T>(
      data: data ?? _data,
      exception: exception ?? _exception,
      feedback: feedback ?? this.feedback,
      message: message ?? _message,
      progress: progress ?? _progress,
      requestCode: requestCode ?? this.requestCode,
      backups: backups ?? _backups,
      ignores: ignores ?? _ignores,
      result: result ?? _result,
      snapshot: snapshot ?? this.snapshot,
      status: status ?? _status,
    );
  }

  Response<T> modify({
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    double? progress,
    Status? status,
    String? exception,
    String? message,
    dynamic feedback,
    dynamic snapshot,
  }) {
    status ??= ((data != null || result != null) ? Status.ok : null);
    _data = data ?? _data;
    _backups = backups ?? _backups;
    _ignores = ignores ?? _ignores;
    _result = result ?? _result;
    _progress = progress ?? _progress;
    _status = status ?? _status;
    _exception = exception ?? _exception;
    _message = message ?? _message;
    this.feedback = feedback ?? this.feedback;
    this.snapshot = snapshot ?? this.snapshot;
    return this;
  }

  Snapshot? getSnapshot<Snapshot>() => snapshot is Snapshot ? snapshot : null;

  String get beautify {
    return "Response {\n"
        "\tBackups        : $backups\n"
        "\tData           : $data\n"
        "\tException      : $exception\n"
        "\tFeedback       : $feedback\n"
        "\tIgnores        : $ignores\n"
        "\tMessage        : $message\n"
        "\tProgress       : $progress\n"
        "\tRequest Code   : $requestCode\n"
        "\tResult         : $result\n"
        "\tSnapshot       : $snapshot\n"
        "\tStatus         : $status\n"
        "}";
  }

  @override
  String toString() {
    return "Response (Request Code: $requestCode, Progress: $progress, Status: $status, Exception: $exception, Message: $message, Feedback: $feedback, Snapshot: $snapshot, Data: $data, Result: $result, Backups: $backups, Ignores: $ignores)";
  }
}
