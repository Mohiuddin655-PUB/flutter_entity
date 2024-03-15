part 'extensions.dart';
part 'messages.dart';
part 'status.dart';

/// Represents the response of an operation, containing various flags, data, and status.
/// [T] represents the type of data being handled.
class Response<T extends Object> {
  /// The request code associated with the response.
  final int requestCode;

  // Flags indicating various states of the response.
  bool? _available;
  bool? _cancel;
  bool? _complete;
  bool? _error;
  bool? _failed;
  bool? _internetError;
  bool? _loading;
  bool? _nullable;
  bool? _paused;
  bool? _stopped;
  bool? _successful;
  bool? _timeout;
  bool? _valid;

  // Data associated with the response.
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

  /// Indicates if the response is available.
  bool get isAvailable => _available ?? false;

  /// Sets the availability status of the response.
  set isAvailable(bool value) => _available = value;

  /// Indicates if there are backup data available.
  bool get isBackup => backups.isNotEmpty;

  /// Indicates if the response has been cancelled.
  bool get isCancel => _cancel ?? false;

  /// Sets the cancellation status of the response.
  set isCancel(bool value) => _cancel = value;

  /// Indicates if the response is complete.
  bool get isComplete => _complete ?? false;

  /// Sets the completion status of the response.
  set isComplete(bool value) => _complete = value;

  /// Indicates if an error occurred in the response.
  bool get isError => _error ?? false;

  /// Sets the error status of the response.
  set isError(bool value) => _error = value;

  bool get isException => _exception?.isNotEmpty ?? status.isExceptionMode;

  bool get isFailed => _failed ?? false;

  set isFailed(bool value) => _failed = value;

  bool get isIgnored => ignores.isNotEmpty;

  bool get isInternetError => _internetError ?? false;

  set isInternetError(bool value) => _internetError = value;

  bool get isLoaded => !(_loading ?? false);

  set isLoaded(bool value) => _loading = !value;

  bool get isLoading => _loading ?? false;

  set isLoading(bool value) => _loading = value;

  bool get isMessage => _message?.isNotEmpty ?? status.isMessageMode;

  bool get isNullable => _nullable ?? false;

  set isNullable(bool value) => _nullable = value;

  bool get isPaused => _paused ?? false;

  set isPaused(bool value) => _paused = value;

  bool get isStopped => _stopped ?? false;

  set isStopped(bool value) => _stopped = value;

  bool get isSuccessful => _successful ?? status.isSuccessful;

  set isSuccessful(bool value) => _successful = value;

  bool get isTimeout => _timeout ?? false;

  set isTimeout(bool value) => _timeout = value;

  bool get isValid => _valid ?? false;

  set isValid(bool value) => _valid = value;

  T? get data => _data is T ? _data : null;

  set data(T? value) => _data = value;

  List<T> get backups => _backups ?? [];

  set backups(List<T> value) => _backups = value;

  List<T> get ignores => _ignores ?? [];

  set ignores(List<T> value) => _ignores = value;

  List<T> get result => _result ?? [];

  set result(List<T> value) => _result = value;

  double get progress => _progress ?? 0;

  set progress(double value) => _progress = value;

  Status get status => _status ?? Status.none;

  set status(Status value) => _status = value;

  String get exception => _exception ?? status.exception;

  set exception(String value) => _exception = value;

  String get message => _message ?? status.message;

  set message(String value) => _message = value;

  /// Constructs a [Response] object with optional initial values.
  ///
  /// [requestCode]: The request code associated with the response.
  /// [available]: Indicates if the response is available.
  /// [cancel]: Indicates if the response has been cancelled.
  /// [complete]: Indicates if the response is complete.
  /// [error]: Indicates if an error occurred.
  /// [failed]: Indicates if the operation failed.
  /// [internetError]: Indicates if there's an internet error.
  /// [loading]: Indicates if the response is currently loading.
  /// [nullable]: Indicates if the response can be null.
  /// [paused]: Indicates if the response is paused.
  /// [stopped]: Indicates if the response is stopped.
  /// [successful]: Indicates if the operation was successful.
  /// [timeout]: Indicates if there was a timeout.
  /// [valid]: Indicates if the response is valid.
  /// [data]: The data associated with the response.
  /// [backups]: List of backup data.
  /// [ignores]: List of ignored data.
  /// [result]: List of results.
  /// [progress]: Progress value.
  /// [status]: Status of the response.
  /// [exception]: Exception message.
  /// [message]: Additional message.
  /// [feedback]: Feedback data.
  /// [snapshot]: Snapshot data.
  Response({
    this.requestCode = 0,
    bool? available,
    bool? cancel,
    bool? complete,
    bool? error,
    bool? failed,
    bool? internetError,
    bool? loading,
    bool? nullable,
    bool? paused,
    bool? stopped,
    bool? successful,
    bool? timeout,
    bool? valid,
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
  })  : _available = available,
        _cancel = cancel,
        _complete = complete,
        _error = error,
        _failed = failed,
        _internetError = internetError,
        _loading = loading,
        _nullable = nullable,
        _paused = paused,
        _stopped = stopped,
        _successful = successful,
        _timeout = timeout,
        _valid = valid,
        _data = data,
        _backups = backups,
        _ignores = ignores,
        _result = result,
        _progress = progress,
        _status = status,
        _exception = exception,
        _message = message;

  /// Creates a new [Response] object from an existing response.
  ///
  /// [response]: The existing response to copy from.
  Response<T> from(Response<T> response) {
    return copy(
      available: response._available,
      cancel: response._cancel,
      complete: response._complete,
      data: response._data,
      error: response._error,
      exception: response._exception,
      failed: response._failed,
      feedback: response.feedback,
      internetError: response._internetError,
      loading: response._loading,
      message: response._message,
      nullable: response._nullable,
      paused: response._paused,
      progress: response._progress,
      requestCode: response.requestCode,
      backups: response._backups,
      ignores: response._ignores,
      result: response._result,
      snapshot: response.snapshot,
      status: response._status,
      stopped: response._stopped,
      successful: response._successful,
      timeout: response._timeout,
      valid: response._valid,
    );
  }

  /// Creates a copy of the current [Response] object with optional modifications.
  ///
  /// [requestCode]: The request code associated with the response.
  /// [available]: Indicates if the response is available.
  /// [cancel]: Indicates if the response has been cancelled.
  /// [complete]: Indicates if the response is complete.
  /// [error]: Indicates if an error occurred.
  /// [failed]: Indicates if the operation failed.
  /// [internetError]: Indicates if there's an internet error.
  /// [loading]: Indicates if the response is currently loading.
  /// [nullable]: Indicates if the response can be null.
  /// [paused]: Indicates if the response is paused.
  /// [stopped]: Indicates if the response is stopped.
  /// [successful]: Indicates if the operation was successful.
  /// [timeout]: Indicates if there was a timeout.
  /// [valid]: Indicates if the response is valid.
  /// [data]: The data associated with the response.
  /// [backups]: List of backup data.
  /// [ignores]: List of ignored data.
  /// [result]: List of results.
  /// [progress]: Progress value.
  /// [status]: Status of the response.
  /// [exception]: Exception message.
  /// [message]: Additional message.
  /// [feedback]: Feedback data.
  /// [snapshot]: Snapshot data.
  Response<T> copy({
    int? requestCode,
    bool? available,
    bool? cancel,
    bool? complete,
    bool? error,
    bool? failed,
    bool? internetError,
    bool? loading,
    bool? nullable,
    bool? paused,
    bool? stopped,
    bool? successful,
    bool? timeout,
    bool? valid,
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
    return Response<T>(
      available: available,
      cancel: cancel,
      complete: complete,
      data: data,
      error: error,
      exception: exception,
      failed: failed,
      feedback: feedback,
      internetError: internetError,
      loading: loading ?? false,
      message: message,
      nullable: nullable,
      paused: paused,
      progress: progress ?? _progress,
      requestCode: requestCode ?? this.requestCode,
      backups: backups,
      ignores: ignores,
      result: result,
      snapshot: snapshot,
      status: status,
      stopped: stopped,
      successful: successful,
      timeout: timeout,
      valid: valid,
    );
  }

  /// Modifies the current [Response] object with optional changes.
  ///
  /// [available]: Indicates if the response is available.
  /// [cancel]: Indicates if the response has been cancelled.
  /// [complete]: Indicates if the response is complete.
  /// [error]: Indicates if an error occurred.
  /// [failed]: Indicates if the operation failed.
  /// [internetError]: Indicates if there's an internet error.
  /// [loading]: Indicates if the response is currently loading.
  /// [nullable]: Indicates if the response can be null.
  /// [paused]: Indicates if the response is paused.
  /// [stopped]: Indicates if the response is stopped.
  /// [successful]: Indicates if the operation was successful.
  /// [timeout]: Indicates if there was a timeout.
  /// [valid]: Indicates if the response is valid.
  /// [data]: The data associated with the response.
  /// [backups]: List of backup data.
  /// [ignores]: List of ignored data.
  /// [result]: List of results.
  /// [progress]: Progress value.
  /// [status]: Status of the response.
  /// [exception]: Exception message.
  /// [message]: Additional message.
  /// [feedback]: Feedback data.
  /// [snapshot]: Snapshot data.
  Response<T> modify({
    bool? available,
    bool? cancel,
    bool? complete,
    bool? error,
    bool? failed,
    bool? internetError,
    bool? loading,
    bool? nullable,
    bool? paused,
    bool? stopped,
    bool? successful,
    bool? timeout,
    bool? valid,
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
    successful = successful ?? ((data != null || result != null) ? true : null);
    _available = available ?? _available;
    _cancel = cancel ?? _cancel;
    _complete = complete ?? _complete;
    _error = error ?? _error;
    _failed = failed ?? _failed;
    _internetError = internetError ?? _internetError;
    _loading = loading ?? _loading;
    _nullable = nullable ?? _nullable;
    _paused = paused ?? _paused;
    _stopped = stopped ?? _stopped;
    _successful = successful ?? _successful;
    _timeout = timeout ?? _timeout;
    _valid = valid ?? _valid;
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

  /// Sets the response as available and optionally provides data, status, and message.
  ///
  /// [available]: Indicates if the response is available.
  /// [data]: The data associated with the response.
  /// [status]: Status of the response.
  /// [message]: Additional message.
  /// Returns the modified [Response] object with updated availability status and data.
  Response<T> withAvailable(
    bool available, {
    T? data,
    Status? status,
    String? message,
  }) {
    _available = available;
    _status = status;
    _data = data;
    _message = message;
    _loading = false;
    return this;
  }

  /// Sets the response as cancelled and optionally provides a cancellation message.
  ///
  /// [cancel]: Indicates if the response is cancelled.
  /// [message]: Cancellation message.
  /// Returns the modified [Response] object with updated cancellation status.
  Response<T> withCancel(bool cancel, {String? message}) {
    _cancel = cancel;
    _loading = false;
    _message = message;
    return this;
  }

  /// Sets the response as complete and optionally provides a completion message.
  ///
  /// [complete]: Indicates if the response is complete.
  /// [message]: Completion message.
  /// Returns the modified [Response] object with updated completion status.
  Response<T> withComplete(bool complete, {String? message}) {
    _complete = complete;
    _loading = false;
    _message = message;
    return this;
  }

  /// Sets the data associated with the response and marks the response as successful.
  ///
  /// [data]: The data to be associated with the response.
  /// [message]: Additional message.
  /// [status]: Status of the response.
  /// Returns the modified [Response] object with updated data and success status.
  Response<T> withData(T? data, {String? message, Status? status}) {
    _status = status ?? Status.ok;
    _data = data;
    _message = message;
    _successful = true;
    _complete = true;
    _loading = false;
    return this;
  }

  /// Sets the response as having encountered an exception.
  ///
  /// [exception]: The exception encountered.
  /// [status]: Status of the response.
  /// Returns the modified [Response] object with updated exception status.
  Response<T> withException(dynamic exception, {Status? status}) {
    _status = status;
    _exception = exception;
    _successful = false;
    _error = true;
    _message = null;
    _loading = false;
    return this;
  }

  /// Sets the response as failed.
  ///
  /// [failed]: Indicates if the operation failed.
  /// Returns the modified [Response] object with updated failed status.
  Response<T> withFailed(bool failed) {
    _failed = failed;
    _loading = false;
    return this;
  }

  /// Sets feedback data and associated properties with the response.
  ///
  /// [feedback]: Feedback data.
  /// [message]: Additional message.
  /// [exception]: Exception message.
  /// [status]: Status of the response.
  /// [loaded]: Indicates if the response is loaded.
  /// Returns the modified [Response] object with updated feedback and status.
  Response<T> withFeedback(
    dynamic feedback, {
    String? message,
    String? exception,
    Status status = Status.ok,
    bool loaded = true,
  }) {
    this.feedback = feedback;
    _status = status;
    _successful = status.isSuccessful;
    _message = message;
    _exception = exception;
    _complete = loaded;
    _loading = false;
    return this;
  }

  /// Sets a backup value and associated properties with the response.
  ///
  /// [value]: The backup value.
  /// [feedback]: Feedback data.
  /// [message]: Additional message.
  /// [status]: Status of the response.
  /// Returns the modified [Response] object with updated backup data.
  Response<T> withBackup(
    T? value, {
    dynamic feedback,
    String? message,
    Status? status,
  }) {
    this.feedback = feedback;
    _backups = _backups.set(value);
    _status = status;
    _message = message;
    _successful = status.isSuccessful;
    _data = null;
    _loading = false;
    return this;
  }

  /// Attaches a list of backup values to the response.
  ///
  /// [value]: List of backup values.
  /// [feedback]: Feedback data.
  /// [message]: Additional message.
  /// [status]: Status of the response.
  /// Returns the modified [Response] object with updated list of backup data.
  Response<T> withBackups(
    List<T>? value, {
    dynamic feedback,
    String? message,
    Status? status,
  }) {
    this.feedback = feedback;
    _backups = _backups.attach(value);
    _result = [];
    _status = status;
    _message = message;
    _successful = status.isSuccessful;
    _loading = false;
    return this;
  }

  /// Sets an ignored value and associated properties with the response.
  ///
  /// [value]: The ignored value.
  /// [message]: Additional message.
  /// [status]: Status of the response.
  /// Returns the modified [Response] object with updated ignored data.
  Response<T> withIgnore(T? value, {String? message, Status? status}) {
    _ignores = _ignores.setAt(0, value);
    _status = status;
    _successful = false;
    _message = message;
    _loading = false;
    return this;
  }

  /// Sets the response as having encountered an internet error.
  ///
  /// [message]: Error message.
  /// Returns the modified [Response] object with updated internet error status.
  Response<T> withInternetError(String message) {
    withException(message, status: Status.networkError);
    _internetError = true;
    return this;
  }

  /// Sets the loading status of the response.
  ///
  /// [loaded]: Indicates if the response is loaded.
  /// Returns the modified [Response] object with updated loading status.
  Response<T> withLoaded(bool loaded) {
    _loading = !loaded;
    return this;
  }

  /// Sets a message and status for the response.
  ///
  /// [message]: Message to be set.
  /// [status]: Status of the response.
  /// Returns the modified [Response] object with updated message and status.
  Response<T> withMessage(String? message, {Status status = Status.ok}) {
    _status = status;
    _message = message;
    _successful = true;
    _loading = false;
    return this;
  }

  /// Sets the nullable status of the response.
  ///
  /// [nullable]: Indicates if the response is nullable.
  /// Returns the modified [Response] object with updated nullable status.
  Response<T> withNullable(bool nullable) {
    _nullable = nullable;
    _loading = false;
    return this;
  }

  /// Sets the paused status of the response.
  ///
  /// [paused]: Indicates if the response is paused.
  /// Returns the modified [Response] object with updated paused status.
  Response<T> withPaused(bool paused) {
    _paused = paused;
    _loading = false;
    return this;
  }

  /// Sets the progress value and optionally provides a message.
  ///
  /// [progress]: Progress value to be set.
  /// [message]: Additional message.
  /// Returns the modified [Response] object with updated progress value.
  Response<T> withProgress(double progress, {String? message}) {
    _status = Status.loading;
    _progress = progress;
    _message = message;
    return this;
  }

  /// Sets the result list and associated properties with the response.
  ///
  /// [result]: List of results.
  /// [message]: Additional message.
  /// [status]: Status of the response.
  /// Returns the modified [Response] object with updated result list.
  Response<T> withResult(List<T>? result, {String? message, Status? status}) {
    _status = status ?? Status.ok;
    _result = result;
    _message = message;
    _successful = true;
    _complete = true;
    _loading = false;
    return this;
  }

  /// Sets the snapshot data and associated properties with the response.
  ///
  /// [snapshot]: Snapshot data.
  /// [message]: Additional message.
  /// [status]: Status of the response.
  /// Returns the modified [Response] object with updated snapshot data.
  Response<T> withSnapshot(dynamic snapshot,
      {String? message, Status? status}) {
    this.snapshot = snapshot;
    _status = status;
    _successful = status.isSuccessful;
    _message = message;
    _complete = true;
    _loading = false;
    return this;
  }

  /// Sets the status of the response.
  ///
  /// [status]: Status to be set.
  /// [message]: Additional message.
  /// Returns the modified [Response] object with updated status.
  Response<T> withStatus(Status status, {String? message}) {
    _status = status;
    _successful = status.isSuccessful;
    _loading = false;
    _message = message;
    return this;
  }

  /// Sets the stopped status of the response.
  ///
  /// [stopped]: Indicates if the response is stopped.
  /// Returns the modified [Response] object with updated stopped status.
  Response<T> withStopped(bool stopped) {
    _stopped = stopped;
    _loading = false;
    return this;
  }

  /// Sets the success status of the response.
  ///
  /// [successful]: Indicates if the operation was successful.
  /// [message]: Additional message.
  /// Returns the modified [Response] object with updated success status.
  Response<T> withSuccessful(bool successful, {String? message}) {
    _status = Status.ok;
    _successful = successful;
    _message = message;
    _complete = true;
    _loading = false;
    return this;
  }

  /// Sets the timeout status of the response.
  ///
  /// [timeout]: Indicates if there was a timeout.
  /// Returns the modified [Response] object with updated timeout status.
  Response<T> withTimeout(bool timeout) {
    _timeout = timeout;
    _loading = false;
    return this;
  }

  /// Sets the validity status of the response.
  ///
  /// [valid]: Indicates if the response is valid.
  /// Returns the modified [Response] object with updated validity status.
  Response<T> withValid(bool valid) {
    _valid = valid;
    _loading = false;
    return this;
  }

  /// Gets the snapshot data if available.
  ///
  /// Returns the snapshot data if it exists, otherwise returns null.
  Snapshot? getSnapshot<Snapshot>() => snapshot is Snapshot ? snapshot : null;

  /// Returns a beautified string representation of the response.
  ///
  /// Returns a string containing a formatted representation of the response object.
  String get beautify {
    return "Response {\n"
        "\tAvailable      : $_available\n"
        "\tBackups        : $backups\n"
        "\tCancel         : $_cancel\n"
        "\tComplete       : $_complete\n"
        "\tData           : $data\n"
        "\tError          : $_error\n"
        "\tException      : $exception\n"
        "\tFailed         : $_failed\n"
        "\tFeedback       : $feedback\n"
        "\tIgnores        : $ignores\n"
        "\tInternet Error : $_internetError\n"
        "\tLoading        : $_loading\n"
        "\tMessage        : $message\n"
        "\tNullable       : $_nullable\n"
        "\tPaused         : $_paused\n"
        "\tProgress       : $progress\n"
        "\tRequest Code   : $requestCode\n"
        "\tResult         : $result\n"
        "\tSnapshot       : $snapshot\n"
        "\tStopped        : $_stopped\n"
        "\tStatus         : $status\n"
        "\tSuccessful     : $_successful\n"
        "\tTimeout        : $_timeout\n"
        "\tValid          : $_valid\n"
        "}";
  }

  /// Returns a string representation of the response.
  ///
  /// Returns a string containing a concise representation of the response object.

  @override
  String toString() {
    return "Response (Request Code: $requestCode, Available: $_available, Cancel: $_cancel, Complete: $_complete, Error: $_error, Failed: $_failed, Internet Error: $_internetError, Loading: $_loading, Nullable: $_nullable, Paused: $_paused, Stopped: $_stopped, Successful: $_successful, Timeout: $_timeout, Valid: $_valid, Progress: $progress, Status: $status, Exception: $exception, Message: $message, Feedback: $feedback, Snapshot: $snapshot, Data: $data, Result: $result, Backups: $backups, Ignores: $ignores)";
  }
}
