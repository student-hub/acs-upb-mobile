class Request {
  Request(this.userId, this.requestBody);

  /// The user who created this request
  final String userId;

  /// The body of the request
  final String requestBody;

  /// Boolean value represented whether the request has been processed by mods
  final bool processed = false;
}
