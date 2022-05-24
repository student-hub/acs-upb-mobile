// ignore_for_file: flutter_style_todos

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/toast.dart';
import '../model/news_feed_item.dart';

class NewsProvider with ChangeNotifier {
  AuthProvider _authProvider;

  // ignore: prefer_final_parameters, use_setters_to_change_properties
  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  List<String> getBookmarkedNews() =>
      _authProvider.currentUserFromCache?.bookmarkedNews;

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

  Future<List<NewsFeedItem>> fetchFavoriteNewsFeedItems(
      {final int limit}) async {
    try {
      final bookmarkedNews = getBookmarkedNews();
      if (bookmarkedNews == null || bookmarkedNews.isEmpty) {
        return [];
      }
      final CollectionReference news =
          FirebaseFirestore.instance.collection('news');
      final QuerySnapshot<Map<String, dynamic>> qSnapshot = await news
          .where(FieldPath.documentId, whereIn: getBookmarkedNews())
          .get();
      return qSnapshot.docs.map(DatabaseNews.fromSnap).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<List<NewsFeedItem>> fetchPersonalNewsFeedItem(
      {final int limit}) async {
    try {
      return [];
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

  bool isNewsItemBookmarked(final String newsItemGuid) {
    final _currentUser = _authProvider.currentUserFromCache;
    if (_currentUser.bookmarkedNews == null ||
        _currentUser.bookmarkedNews.isEmpty) {
      return false;
    }
    return _currentUser.bookmarkedNews.contains(newsItemGuid);
  }

  Future<bool> bookmarkNewsItem(final String newsItemGuid) async {
    try {
      print('bookmarking news item $newsItemGuid');
      final _currentUser = _authProvider.currentUserFromCache;

      if (_currentUser.bookmarkedNews.contains(newsItemGuid)) {
        throw Exception('News item already bookmarked');
      }

      _currentUser.bookmarkedNews.add(newsItemGuid);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update(_currentUser.toData());

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> unbookmarkNewsItem(final String newsItemGuid) async {
    try {
      print('un-bookmarking news item $newsItemGuid');
      final _currentUser = _authProvider.currentUserFromCache;
      _currentUser.bookmarkedNews
          .removeWhere((final item) => item == newsItemGuid);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update(_currentUser.toData());

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  void _errorHandler(final dynamic e, {bool showToast = true}) {
    try {
      print('${e.message} code: ${e.code}');
      if (showToast) {
        switch (e.code) {
          case 'invalid-email':
          case 'invalid-credential':
            AppToast.show(S.current.errorInvalidEmail);
            break;
          case 'wrong-password':
            AppToast.show(S.current.errorIncorrectPassword);
            break;
          case 'user-not-found':
            AppToast.show(S.current.errorEmailNotFound);
            break;
          case 'user-disabled':
            AppToast.show(S.current.errorAccountDisabled);
            break;
          case 'too-many-requests':
            AppToast.show(
                '${S.current.errorTooManyRequests} ${S.current.warningTryAgainLater}');
            break;
          case 'email-already-in-use':
            AppToast.show(S.current.errorEmailInUse);
            break;
          default:
            AppToast.show(e.message);
        }
      }
    } catch (_) {
      // Unknown exception
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
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
        sourceTags: null,
        sourceLink: sourceLink);
  }
}
