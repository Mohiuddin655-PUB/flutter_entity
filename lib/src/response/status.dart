part of 'response.dart';

enum Status {
  none(10000, ""),
  alreadyFound(10001, ResponseMessages.alreadyFound),
  canceled(10010, ResponseMessages.processCanceled),
  failure(10020, ResponseMessages.processFailed),
  networkError(10030, ResponseMessages.internetDisconnected),
  nullable(10040, ResponseMessages.invalidData),
  paused(10050, ResponseMessages.processPaused),
  notFound(10060, ResponseMessages.notFound),
  stopped(10070, ResponseMessages.processStopped),
  loading(10090, ResponseMessages.loading),
  timeOut(10080, ResponseMessages.tryAgain),
  ok(10100, ResponseMessages.successful),
  invalid(10110, ResponseMessages.invalidData),
  invalidId(10111, ResponseMessages.invalidId),
  undefined(10120, ResponseMessages.undefined),
  unmodified(10130, ResponseMessages.unmodified),
  undetected(10140, ResponseMessages.unmodified),
  notSupported(10100, ResponseMessages.notSupported),
  error(10100, ResponseMessages.tryAgain);

  final int code;
  final String _message;

  const Status(this.code, this._message);
}
