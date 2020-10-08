import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  Request(this.userId, this.requestBody, this.timestamp);

  /// The user who created this request
  final String userId;

  /// The body of the request
  final String requestBody;

  /// Boolean value represented whether the request has been processed by mods
  final bool processed = false;

  /// Timestamp representing the moment when a request is sent
  final Timestamp timestamp;
}
