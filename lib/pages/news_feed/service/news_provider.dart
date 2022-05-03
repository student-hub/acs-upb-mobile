// ignore_for_file: flutter_style_todos

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/toast.dart';
import '../model/news_feed_item.dart';

class NewsProvider with ChangeNotifier {
  Future<List<NewsFeedItem>> fetchNewsFeedItems({final int limit}) async {
    try {
      final CollectionReference news =
          FirebaseFirestore.instance.collection('news');
      final QuerySnapshot<Map<String, dynamic>> qSnapshot =
          limit == null ? await news.get() : await news.limit(limit).get();
      return qSnapshot.docs.map(DatabaseNews.fromSnap).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<NewsFeedItem> fetchNewsItemDetails(final String newsId) async {
    try {
      final DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('news').doc(newsId).get();
      return DatabaseNews.fromSnap(doc);
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }
}

extension DatabaseNews on NewsFeedItem {
  static NewsFeedItem fromSnap(
      final DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data();

    final String itemGuid = snap.id;
    final String title = data['title'];
    final String body = data['body'];
    final String source = data['source'];
    final String type = data['type'];
    final String createdAt = data['createdAt'].toDate().toString();
    final String sourceLink = data['sourceLink'];
    final String relevance = data['relevance'];

    return NewsFeedItem(
        itemGuid: itemGuid,
        title: title,
        body: body,
        source: source,
        createdAt: createdAt,
        type: type,
        relevance: relevance,
        sourceLink: sourceLink);
  }
}
