class Request {
  Request(this.userId, this.requestBody);

  /// The user who created this request
  final String userId;

  /// The body of the request
  final String requestBody;
}
