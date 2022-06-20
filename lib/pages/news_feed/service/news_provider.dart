import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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

  List<String> getUserSources() =>
      _authProvider.currentUserFromCache?.sourcesList;

  Query filterBySource(final Query query) =>
      query.where('category', whereIn: getUserSources());

  Future<List<NewsFeedItem>> fetchNewsFeedItems({final int limit}) async {
    try {
      final CollectionReference news =
          FirebaseFirestore.instance.collection('news');
      final QuerySnapshot<Map<String, dynamic>> qSnapshot = limit == null
          ? await filterBySource(news).get()
          : await filterBySource(news.limit(limit)).get();

      final userClasses = _authProvider.currentUserFromCache?.classes;
      return qSnapshot.docs.map(DatabaseNews.fromSnap).where((final item) {
        final itemRelevance = item.relevance;
        //if item has no relevance, it is always visible
        if (itemRelevance == null || itemRelevance.isEmpty) {
          return true;
        }
        if (userClasses == null || userClasses.isEmpty) {
          return true;
        }
        //computes the intersection between the item's relevance and the user's classes
        //if the intersection is empty, the item is not relevant
        itemRelevance.removeWhere(
            (final relevanceItem) => !userClasses.contains(relevanceItem));
        return itemRelevance.isNotEmpty;
      }).toList()
        ..sort((final a, final b) => a.createdAt.compareTo(b.createdAt) * -1);
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
      return qSnapshot.docs.map(DatabaseNews.fromSnap).toList()
        ..sort((final a, final b) => a.createdAt.compareTo(b.createdAt) * -1);
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<List<NewsFeedItem>> fetchPersonalNewsFeedItem(
      {final int limit}) async {
    try {
      final userId = _authProvider.currentUserFromCache.uid;
      final CollectionReference news =
          FirebaseFirestore.instance.collection('news');
      final QuerySnapshot<Map<String, dynamic>> qSnapshot = limit == null
          ? await news.where('userId', isEqualTo: userId).get()
          : await news.where('userId', isEqualTo: userId).limit(limit).get();
      return qSnapshot.docs.map(DatabaseNews.fromSnap).toList()
        ..sort((final a, final b) => a.createdAt.compareTo(b.createdAt) * -1);
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

  Future<bool> deletePost(final String newsItemGuid) async {
    try {
      final _currentUser = _authProvider.currentUserFromCache;
      _currentUser.bookmarkedNews
          .removeWhere((final item) => item == newsItemGuid);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update(_currentUser.toData());

      await FirebaseFirestore.instance
          .collection('news')
          .doc(newsItemGuid)
          .delete();

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> savePost(final Map<String, dynamic> info) async {
    try {
      await FirebaseFirestore.instance.collection('news').add({
        'title': info['title'],
        'body': info['body'],
        'userId': _authProvider.currentUserFromCache.uid,
        'authorDisplayName': _authProvider.currentUserFromCache.displayName,
        'authorAvatarUrl': null,
        'externalLink': '',
        'relevance': info['relevance'],
        'category': info['category'],
        'categoryRole': info['categoryRole'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
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
    final String authorDisplayName = data['authorDisplayName'];
    final String authorAvatarUrl = data['authorAvatarUrl'];
    final String externalLink = data['externalLink'];
    final String userId = data['userId'];
    final String category = data['category'];
    final String categoryRole = data['categoryRole'];
    final List<dynamic> relevance = data['relevance'] as List<dynamic>;
    final String createdAt =
        DateFormat('yyyy-MM-dd').format(data['createdAt'].toDate());

    return NewsFeedItem(
        itemGuid: itemGuid,
        title: title,
        body: body,
        authorDisplayName: authorDisplayName,
        authorAvatarUrl: authorAvatarUrl,
        externalLink: externalLink,
        userId: userId,
        category: category,
        categoryRole: categoryRole,
        relevance: relevance,
        createdAt: createdAt);
  }
}
