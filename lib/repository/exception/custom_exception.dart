/// A base class for creating custom exceptions with an optional prefix and message.
class CustomException implements Exception {
  final String? _prefix;
  final String? _message;

  CustomException([this._prefix, this._message]);

  @override
  String toString() {
    return "$_prefix $_message";
  }
}

class BadRequestException extends CustomException {
  /// Thrown when the server returns a 400 Bad Request response.
  BadRequestException([String? message]) : super("Invalid Request: ", message);
}

class UnauthorisedException extends CustomException {
  /// Thrown when the server returns a 401 Unauthorised request response.
  /// Indicates that authentication is required or has failed.
  UnauthorisedException([String? message]) : super("Unauthorised: ", message);
}

class ForbiddenRequestException extends CustomException {
  /// Thrown when the server returns a 403 Forbidden response.
  /// Indicates that the request is understood but access is denied.
  ForbiddenRequestException([String? message]) : super("Forbidden: ", message);
}

class RequestTimeoutException extends CustomException {
  /// Thrown when the server takes too long to respond
  RequestTimeoutException([String? message]) : super("Timeout: ", message);
}

class RateLimitException extends CustomException {
  /// Thrown when the server indicates too many requests.
  RateLimitException([String? message]) : super("Rate Limit: ", message);
}

class InternalServerException extends CustomException {
  /// Thrown when the server returns a 500 Internal Server Error response.
  InternalServerException([String? message])
    : super("Internal Server Error: ", message);
}

class UnknownApiException extends CustomException {
  /// Thrown when the server returns an unexpected or unhandled status code.
  UnknownApiException([String? message])
    : super("Unknown API Error: ", message);
}
