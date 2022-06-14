import 'package:meta/meta.dart';

class NewsFeedItem {
  NewsFeedItem({
    @required this.itemGuid,
    @required this.title,
    @required this.body,
    this.authorDisplayName,
    this.externalLink,
    this.userId,
    this.createdAt,
    this.relevance,
    this.category,
    this.categoryRole,
  });

  final String itemGuid;
  final String title;
  final String body;
  final String authorDisplayName;
  final String externalLink;
  final String userId;
  final List<dynamic> relevance;
  final String category;
  final String categoryRole;
  final String createdAt;
}
