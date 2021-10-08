import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
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

  /// The answers to the request questions
  final Map<String, FormQuestion> answers;

  /// Boolean value representing whether the request has been processed by admins
  bool processed;

  /// Date and time the request was made
  final Timestamp dateSubmitted;

  /// Boolean value representing whether the request has been accepted by admins
  bool accepted;

  /// Unique ID of the admin that processed the request
  final String processedBy;

  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    for (int i = 0; i < answers.length; ++i) {
      if (answers[i.toString()].answer != null) {
        data[i.toString()] = answers[i.toString()].answer;
      }
    }
    data['addedBy'] = userId;
    data['done'] = processed;
    data['dateSubmitted'] = Timestamp.now();
    data['accepted'] = false;

    return data;
  }
}
