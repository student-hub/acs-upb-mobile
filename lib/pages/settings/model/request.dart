import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Request {
  Request({
    @required this.userId,
    @required this.requestBody,
    this.processed = false,
    this.type = RequestType.permissions,
    this.dateSubmitted,
  });

  /// The user who created this request
  final String userId;

  /// The body of the request
  final String requestBody;

  /// Boolean value represented whether the request has been processed by mods
  final bool processed;

  /// Type of the request
  final RequestType type;
  
  /// Date and time the request was made
  final Timestamp dateSubmitted;
}

enum RequestType { permissions }
