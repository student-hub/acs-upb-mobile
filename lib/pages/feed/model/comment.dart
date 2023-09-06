import 'package:meta/meta.dart';

class Comment {
  Comment(
      {@required this.text,
      @required this.userDisplayName,
      @required this.userId,
      @required this.createdAt,
      @required this.upvotes,
      this.userAvatar});
  final String text;
  final String userDisplayName;
  final String userId;
  final DateTime createdAt;
  final List<String> upvotes;
  final String userAvatar;

  @override
  String toString() {
    return 'Comment{text: $text, userDisplayName: $userDisplayName, userId: $userId, createdAt: $createdAt, upvotes: $upvotes, userAvatar: $userAvatar}';
  }
}
