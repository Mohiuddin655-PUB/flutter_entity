import '../entity/equality.dart';

part 'extensions.dart';
part 'messages.dart';
part 'status.dart';

/// A generic response wrapper class that encapsulates API responses with status,
/// data, and metadata information.
///
/// Type parameter [T] must be a non-nullable Object type.
class Response<T extends Object> extends DeepCollectionEquality {
  // ============================================================================
  // FIELDS
  // ============================================================================

  final int requestCode;

  double? _progress;
  Status? _status;
  String? _error;
  String? _message;
  dynamic _feedback;
  dynamic _snapshot;
  int? _count;
  T? _data;
  List<T>? _backups;
  List<T>? _ignores;
  List<T>? _result;
  List<T>? _resultByMe;
  List<String>? _selections;
  Map<String, bool>? _exists;

  // ============================================================================
  // CONSTRUCTORS
  // ============================================================================

  Response({
    this.requestCode = 0,
    double? progress,
    Status? status,
    String? error,
    String? message,
    Object? feedback,
    Object? snapshot,
    int? count,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    List<T>? resultByMe,
    List<String>? selections,
    Map<String, bool>? exists,
  })  : _data = data,
        _backups = backups,
        _ignores = ignores,
        _result = result,
        _resultByMe = resultByMe ?? [],
        _selections = selections ?? [],
        _exists = exists ?? {},
        _progress = progress,
        _error = error,
        _message = message,
        _count = count,
        _feedback = feedback,
        _snapshot = snapshot,
        _status = status ??
            ((data != null || result != null)
                ? Status.ok
                : (error ?? '').isNotEmpty
                    ? Status.error
                    : null);

  /// Creates a failure response with an error
  factory Response.failure(Object? error) {
    return Response(
      status: Status.failure,
      error: error.toString(),
    );
  }

  /// Creates a successful response with optional data and metadata
  factory Response.ok({
    int? count,
    T? data,
    List<T>? result,
    List<T>? resultByMe,
    List<String>? selections,
    Map<String, bool>? exists,
    String? message,
    Object? feedback,
    Object? snapshot,
  }) {
    return Response(
      status: Status.ok,
      data: data,
      result: result,
      resultByMe: resultByMe,
      selections: selections,
      exists: exists,
      message: message,
      feedback: feedback,
      snapshot: snapshot,
      count: count,
    );
  }

  /// Converts a Response of type [T] to type [E] using the provided converter
  static Response<E> convert<E extends Object, T extends Object>(
    Response<T> response,
    E Function(T) converter,
  ) {
    return Response<E>(
      requestCode: response.requestCode,
      count: response._count,
      data: response._data != null ? converter(response._data!) : null,
      backups: response._backups?.map(converter).toList(),
      ignores: response._ignores?.map(converter).toList(),
      result: response._result?.map(converter).toList(),
      resultByMe: response._resultByMe?.map(converter).toList(),
      selections: response._selections,
      exists: response._exists,
      progress: response._progress,
      status: response._status,
      error: response._error,
      message: response._message,
      feedback: response._feedback,
      snapshot: response._snapshot,
    );
  }

  // ============================================================================
  // GETTERS - Status Checks
  // ============================================================================

  bool get isAvailable => status == Status.available;
  bool get isBackup => backups.isNotEmpty;
  bool get isCancel => status == Status.canceled;
  bool get isComplete => status == Status.completed;
  bool get isExistByMe => resultByMe.isNotEmpty;
  bool get isFailed => status == Status.failure;
  bool get isIgnored => ignores.isNotEmpty;
  bool get isInternetError => status == Status.networkError;
  bool get isLoaded => !isLoading;
  bool get isLoading => status == Status.loading;
  bool get isNullable => status == Status.notFound;
  bool get isPaused => status == Status.paused;
  bool get isStopped => status == Status.stopped;
  bool get isSuccessful => status.isSuccessful;
  bool get isTimeout => status == Status.timeOut;

  bool get isError {
    return status == Status.error ||
        (_error?.isNotEmpty ?? status.isExceptionMode);
  }

  bool get isMessage => _message?.isNotEmpty ?? status.isMessageMode;

  bool get isValid => isSuccessful && data != null && result.isNotEmpty;

  // ============================================================================
  // GETTERS - Data Access
  // ============================================================================

  int get count => _count ?? result.length;
  T? get data => _data ?? result.firstOrNull;
  List<T> get backups => _backups ?? [];
  List<T> get ignores => _ignores ?? [];
  List<T> get result => _result ?? [if (_data != null) _data!];
  List<T> get resultByMe => _resultByMe ?? [];
  List<String> get selections => _selections ?? [];
  Map<String, bool> get exists => _exists ?? {};
  int get page => _snapshot is int ? _snapshot as int : 0;
  double get progress => _progress ?? 0;
  Status get status => _status ?? Status.none;
  String get error => _error ?? status.error;
  String get message => _message ?? status.message;
  Object? get feedback => _feedback;
  Object? get snapshot => _snapshot;

  // ============================================================================
  // METHODS - Query & Utility
  // ============================================================================

  /// Checks if the given [id] exists in selections
  bool isContain(String id) => selections.contains(id);

  /// Checks if the given [id] exists in the exists map
  bool isExist(String id, [bool defaultValue = false]) {
    return _exists?[id] ?? defaultValue;
  }

  /// Gets the snapshot cast to the specified type [Snapshot]
  Snapshot? snapshotAs<Snapshot>() {
    return _snapshot is Snapshot ? _snapshot as Snapshot : null;
  }

  // ============================================================================
  // METHODS - Copying & Modification
  // ============================================================================

  /// Creates a copy of this Response with the given fields replaced
  Response<T> copyWith({
    double? progress,
    Status? status,
    String? error,
    String? message,
    dynamic feedback,
    dynamic snapshot,
    int? count,
    int? requestCode,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    List<T>? resultByMe,
    List<String>? selections,
    Map<String, bool>? exists,
  }) {
    return Response<T>(
      requestCode: requestCode ?? this.requestCode,
      count: count ?? _count,
      data: data ?? _data,
      backups: backups ?? _backups,
      ignores: ignores ?? _ignores,
      result: result ?? _result,
      resultByMe: resultByMe ?? this.resultByMe,
      selections: selections ?? this.selections,
      exists: exists ?? this.exists,
      progress: progress ?? _progress,
      status: status ?? _status,
      error: error ?? _error,
      message: message ?? _message,
      feedback: feedback ?? this.feedback,
      snapshot: snapshot ?? this.snapshot,
    );
  }

  /// Modifies this Response in-place with the given fields
  Response<T> modifyWith({
    double? progress,
    Status? status,
    String? exception,
    String? message,
    dynamic feedback,
    dynamic snapshot,
    int? count,
    int? requestCode,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    List<T>? resultByMe,
    List<String>? selections,
    Map<String, bool>? exists,
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
    _selections = selections ?? _selections;
    _exists = exists ?? _exists;
    _progress = progress ?? _progress;
    _status = status ?? _status;
    _error = exception ?? _error;
    _message = message ?? _message;
    _feedback = feedback ?? _feedback;
    _snapshot = snapshot ?? _snapshot;

    return this;
  }

  // ============================================================================
  // OVERRIDES
  // ============================================================================

  @override
  int get hashCode {
    return Object.hashAll([
      requestCode,
      _count,
      _status,
      _progress,
      _error,
      _message,
      hash(_feedback),
      hash(_snapshot),
      hash(_data),
      hash(_backups),
      hash(_ignores),
      hash(_result),
      hash(_resultByMe),
      hash(_exists),
      hash(_selections),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! Response) return false;
    if (other.requestCode != requestCode) return false;
    if (other._count != _count) return false;
    if (other._status != _status) return false;
    if (other._progress != _progress) return false;
    if (other._error != _error) return false;
    if (other._message != _message) return false;
    if (notEquals(other._feedback, _feedback)) return false;
    if (notEquals(other._snapshot, _snapshot)) return false;
    if (notEquals(other._data, _data)) return false;
    if (notEquals(other._backups, _backups)) return false;
    if (notEquals(other._ignores, _ignores)) return false;
    if (notEquals(other._result, _result)) return false;
    if (notEquals(other._resultByMe, _resultByMe)) return false;
    if (notEquals(other._exists, _exists)) return false;
    if (notEquals(other._selections, _selections)) return false;
    return true;
  }

  @override
  String toString() => "Response#$hashCode";
}
