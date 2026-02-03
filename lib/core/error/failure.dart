enum FailureType { network, unauthorized, timeout, server, parsing, unknown }

class Failure {
  final FailureType type;
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const Failure(this.type, this.message, {this.cause, this.stackTrace});

  bool get isNetwork => type == FailureType.network;
  bool get isTimeout => type == FailureType.timeout;
  bool get isUnauthorized => type == FailureType.unauthorized;
}
