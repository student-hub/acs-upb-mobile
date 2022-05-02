import 'package:meta/meta.dart';

class NewsFeedItem {
  NewsFeedItem(
      {@required this.itemId,
      @required this.title,
      @required this.body,
      @required this.source,
      @required this.createdAt,
      @required this.type,
      @required this.relevance,
      @required this.sourceTags,
      @required this.sourceLink});

  final String itemId;
  final String title;
  final String body;
  final String source;
  final String createdAt;
  final String type;
  final String relevance;
  final List<String> sourceTags;
  final String sourceLink;
}
