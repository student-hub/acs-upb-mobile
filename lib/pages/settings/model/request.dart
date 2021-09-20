import 'package:acs_upb_mobile/pages/class_feedback/model/form_answer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionRequest {
  PermissionRequest(
      {this.userId,
      this.answers,
      this.processed = false,
      this.processedBy,
      this.dateSubmitted,
      this.accepted = false});

  /// The user who created this request
  final String userId;

  /// The body of the request
  final List<FormAnswer> answers;

  /// Boolean value representing whether the request has been processed by admins
  bool processed;

  /// Date and time the request was made
  final Timestamp dateSubmitted;

  /// Boolean value representing whether the request has been accepted by admins
  bool accepted;

  /// Unique ID of the admin that processed the request
  final String processedBy;
}
