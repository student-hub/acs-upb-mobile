import 'package:meta/meta.dart';

import 'comment.dart';

class Post {
  Post(
      {@required this.itemGuid,
      @required this.text,
      @required this.userDisplayName,
      @required this.userId,
      @required this.score,
      @required this.date,
      @required this.className,
      this.comments,
      this.likes,
      this.imageUrl,
      this.userAvatarUrl});
  List<Comment> comments;
  final String date;
  final String itemGuid;
  final String imageUrl;
  List<String> likes;
  final int score;
  final String text;
  final String userAvatarUrl;
  final String userDisplayName;
  final String userId;
  final String className;
}
