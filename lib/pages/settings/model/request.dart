import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Request {
  Request(
      {@required this.userId,
      @required this.requestBody,
      this.processed = false,
      this.processedBy,
      this.type = RequestType.permissions,
      this.dateSubmitted,
      this.id,
      this.accepted});

  /// The user who created this request
  final String userId;

  /// The body of the request
  final String requestBody;

  /// Boolean value representing whether the request has been processed by admins
  bool processed;

  /// Type of the request
  final RequestType type;

  /// Date and time the request was made
  final Timestamp dateSubmitted;

  /// Unique ID of the request
  final String id;

  /// Boolean value representing whether the request has been accepted by admins
  bool accepted;

  /// Unique ID of the admin that processed the request
  final String processedBy;
}

enum RequestType { permissions }
