import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class RoleRequest {
  RoleRequest({
    @required this.userId,
    @required this.roleName,
    @required this.requestBody,
    @required this.userEmail,
    this.requestId,
    this.processed = false,
    this.processedBy,
    this.dateSubmitted,
    this.accepted,
  });

  /// Unique ID of the request
  final String id = const Uuid().v4();
  final String requestId;

  /// The user who created this request
  final String userId;

  /// The email of the user who created this request
  final String userEmail;

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
