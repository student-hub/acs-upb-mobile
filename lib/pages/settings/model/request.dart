class Request {
  /// The user who created this request
  final String userId;

  /// The body of the request
  final String requestBody;

  Request(this.userId, this.requestBody);
}
