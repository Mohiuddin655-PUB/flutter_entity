part of 'response.dart';

extension ResponseStatusExtension on Status? {
  Status get use => this ?? Status.none;

  bool get isAvailable => use == Status.available;

  bool get isAlreadyFound => use == Status.alreadyFound;

  bool get isCanceled => use == Status.canceled;

  bool get isCompleted => use == Status.completed;

  bool get isError => use == Status.error;

  bool get isFailure => use == Status.failure;

  bool get isInvalid => use == Status.invalid;

  bool get isInvalidId => use == Status.invalidId;

  bool get isLoading => use == Status.loading;

  bool get isNetworkError => use == Status.networkError;

  bool get isNullable => use == Status.nullable;

  bool get isPaused => use == Status.paused;

  bool get isResultNotFound => use == Status.notFound;

  bool get isStopped => use == Status.stopped;

  bool get isSuccessful => use == Status.ok;

  bool get isTimeout => use == Status.timeOut;

  bool get isUndefined => use == Status.undefined;

  bool get isUnmodified => use == Status.unmodified;

  bool get isExceptionMode {
    return isAlreadyFound ||
        isCanceled ||
        isError ||
        isFailure ||
        isInvalid ||
        isNetworkError ||
        isNullable ||
        isResultNotFound ||
        isStopped ||
        isTimeout ||
        isUndefined ||
        isUnmodified;
  }

  bool get isMessageMode {
    return isPaused || isLoading || isSuccessful;
  }

  String get error => isExceptionMode ? use._message : "";

  String get message => isMessageMode ? use._message : "";
}
