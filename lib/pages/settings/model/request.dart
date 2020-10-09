class Request {
  Request(this.userId, this.requestBody, this.processed, this.typeOfRequest);

  /// The user who created this request
  final String userId;

  /// The body of the request
  final String requestBody;

  /// Boolean value represented whether the request has been processed by mods
  final bool processed;

  /// Type of the request
  final RequestType typeOfRequest;
}

enum RequestType { permissions }

extension ParseToString on RequestType {
  String toShortString() {
    return toString().split('.').last;
  }
}
