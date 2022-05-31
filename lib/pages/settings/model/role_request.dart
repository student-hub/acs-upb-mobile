import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RoleRequest {
  RoleRequest({
    @required this.userId,
    @required this.roleName,
    @required this.requestBody,
    this.processed = false,
    this.processedBy,
    this.dateSubmitted,
    this.accepted,
  });

  /// The user who created this request
  final String userId;

  /// The name of the role
  final String roleName;

  /// The body of the request
  final String requestBody;

  /// Boolean value representing whether the request has been accepted by admins
  bool accepted;

  /// Boolean value representing whether the request has been processed by admins
  bool processed;

  /// Unique ID of the admin that processed the request
  final String processedBy;

  /// Date and time the request was made
  final Timestamp dateSubmitted;
}
