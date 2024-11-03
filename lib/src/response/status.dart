part of 'response.dart';

enum Status {
  none(""),
  available(ResponseMessages.alreadyFound),
  alreadyFound(ResponseMessages.alreadyFound),
  canceled(ResponseMessages.processCanceled),
  completed(ResponseMessages.processCompleted),
  failure(ResponseMessages.processFailed),
  networkError(ResponseMessages.internetDisconnected),
  nullable(ResponseMessages.invalidData),
  paused(ResponseMessages.processPaused),
  notFound(ResponseMessages.notFound),
  stopped(ResponseMessages.processStopped),
  loading(ResponseMessages.loading),
  timeOut(ResponseMessages.tryAgain),
  ok(ResponseMessages.successful),
  invalid(ResponseMessages.invalidData),
  invalidId(ResponseMessages.invalidId),
  undefined(ResponseMessages.undefined),
  unmodified(ResponseMessages.unmodified),
  undetected(ResponseMessages.unmodified),
  notSupported(ResponseMessages.notSupported),
  error(ResponseMessages.tryAgain);

  final String _message;

  const Status(this._message);
}
