import 'package:meta/meta.dart';

class NewsFeedItem {
  NewsFeedItem({
    @required this.itemGuid,
    @required this.title,
    @required this.body,
    this.externalSource,
    this.externalSourceLink,
    this.authorId,
    this.createdAt,
    this.relevance,
    this.category,
    this.categoryRole,
  });

  final String itemGuid;
  final String title;
  final String body;
  final String externalSource;
  final String externalSourceLink;
  final String authorId;
  final List<dynamic> relevance;
  final String category;
  final String categoryRole;
  final String createdAt;
}
