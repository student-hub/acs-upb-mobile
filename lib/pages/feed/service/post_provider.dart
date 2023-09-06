// ignore_for_file: unnecessary_this
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../authentication/model/user.dart';
import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../resources/storage_provider.dart';
import '../../../widgets/toast.dart';
import '../../classes/model/class.dart';
import '../../classes/service/class_provider.dart';
import '../model/comment.dart';
import '../model/post_item.dart';
import '../model/rank.dart';

class PostProvider with ChangeNotifier {
  AuthProvider _authProvider;

  List<String> getUserSources() => _authProvider.currentUserFromCache?.classes;

  Query filterBySource(final Query query) => query;

  Future<List<Post>> fetchPosts({final int limit}) async {
    try {
      final CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');

      final QuerySnapshot<Map<String, dynamic>> qSnapshot =
          limit == null ? await posts.get() : await posts.limit(limit).get();
      notifyListeners();
      return qSnapshot.docs.map(DatabasePost.fromSnap).toList();
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Query<Post> queryPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .withConverter<Post>(
          fromFirestore: (final snapshot, final options) =>
              DatabasePost.fromSnap(snapshot),
          toFirestore: (final post, final options) => post.toData(),
        );
  }

  Query<Post> queryPostsByLikes(final String uid) {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .where('likes', arrayContains: uid)
        .withConverter<Post>(
          fromFirestore: (final snapshot, final options) =>
              DatabasePost.fromSnap(snapshot),
          toFirestore: (final post, final options) => post.toData(),
        );
  }

  Query<Post> queryPostsByClass(final String className) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('class', isEqualTo: className)
        .orderBy('createdAt', descending: true)
        .withConverter<Post>(
          fromFirestore: (final snapshot, final options) =>
              DatabasePost.fromSnap(snapshot),
          toFirestore: (final post, final options) => post.toData(),
        );
  }

  Query<Post> queryPostsByClasses(final List<String> classes) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('class', whereIn: classes)
        .orderBy('createdAt', descending: true)
        .withConverter<Post>(
          fromFirestore: (final snapshot, final options) =>
              DatabasePost.fromSnap(snapshot),
          toFirestore: (final post, final options) => post.toData(),
        );
  }

  Future<List<User>> searchUsers(final String searchQuery) async {
    try {
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      final QuerySnapshot<Map<String, dynamic>> qSnapshot =
          await usersRef.get();
      final List<User> users =
          qSnapshot.docs.map(DatabaseUser.fromSnap).toList();

      final List<String> searchedWords = searchQuery
          .toLowerCase()
          .split(' ')
          .where((final element) => element != '')
          .toList();

      return users
              .where((final user) => searchedWords.fold(
                    true,
                    (final previousValue, final filter) =>
                        previousValue &&
                        user.displayName.toLowerCase().contains(
                              filter.toLowerCase(),
                            ),
                  ))
              .toList() ??
          <User>[];
    } catch (e) {
      _errorHandler(e);
      return null;
    }
  }

  Future<List<ClassHeader>> searchClasses(final String searchQuery) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> qSnapshot =
          await FirebaseFirestore.instance.collection('import_moodle').get();
      final List<DocumentSnapshot<Map<String, dynamic>>> docs = qSnapshot.docs;

      final classHeaders = docs
          .map(ClassHeaderExtension.fromSnap)
          .where((final e) => e != null)
          .toList();

      final List<String> searchedWords = searchQuery
          .toLowerCase()
          .split(' ')
          .where((final element) => element != '')
          .toList();

      return classHeaders
              .where((final classHeader) => searchedWords.fold(
                    true,
                    (final previousValue, final filter) =>
                        previousValue &&
                        (classHeader.id
                                .toLowerCase()
                                .contains(filter.toLowerCase()) ||
                            classHeader.name
                                .toLowerCase()
                                .contains(filter.toLowerCase())),
                  ))
              .toList() ??
          <ClassHeader>[];
    } catch (e) {
      _errorHandler(e);
      return null;
    }
  }

  Future<List<String>> fetchUserClassIds(final String uid) async {
    try {
      final snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snap.data() == null) {
        return [];
      }
      return List<String>.from(snap.data()['classes'] ?? []);
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<List<Post>> fetchPostsByClasses({final int limit}) async {
    try {
      final CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');
      final List<String> classes =
          await fetchUserClassIds(_authProvider.currentUserFromCache.uid);
      final QuerySnapshot<Map<String, dynamic>> qSnapshot = limit == null
          ? await posts.where('class', whereIn: classes).get()
          : await posts.where('class', whereIn: classes).limit(limit).get();

      notifyListeners();
      return qSnapshot.docs.map(DatabasePost.fromSnap).toList();
    } catch (e) {
      print(e);
      _errorHandler(e);
      return null;
    }
  }

  Future<List<Post>> fetchPostsByClass(final String className,
      {final int limit}) async {
    try {
      final CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');
      final QuerySnapshot<Map<String, dynamic>> qSnapshot = limit == null
          ? await posts.where('class', isEqualTo: className).get()
          : await posts.where('class', isEqualTo: className).limit(limit).get();
      return qSnapshot.docs.map(DatabasePost.fromSnap).toList();
    } catch (e) {
      print(e);
      _errorHandler(e);
      return null;
    }
  }

  Future<Post> fetchPost(final String postGuid) async {
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postGuid)
          .get();
      return DatabasePost.fromSnap(doc);
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<User> fetchUserInfo(final String userId) async {
    try {
      final DocumentSnapshot user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return DatabaseUser.fromSnap(user);
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<Rank> fetchUserRank(final int rankProgressionPoints) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('ranks')
              .where('pointsEnd', isGreaterThan: rankProgressionPoints)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        return DatabaseRank.fromSnap(documentSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      _errorHandler(e);
      return null;
    }
  }

  Future<bool> deletePost(final Post post) async {
    try {
      if (post.imageUrl != null) {
        await StorageProvider.deleteImage(post.imageUrl);
      }

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.itemGuid)
          .delete();

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> addComment(final String text, final Post p) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(p.itemGuid)
          .update({
        'comments': FieldValue.arrayUnion([
          {
            'text': text,
            'userDisplayName': _authProvider.currentUserFromCache.displayName,
            'userId': _authProvider.currentUserFromCache.uid,
            'createdAt': Timestamp.now(),
            'userAvatar': _authProvider.currentUserFromCache.picturePath
          }
        ])
      });

      final DocumentSnapshot dbPost = await FirebaseFirestore.instance
          .collection('posts')
          .doc(p.itemGuid)
          .get();

      final Post post = DatabasePost.fromSnap(dbPost);
      p.comments = post.comments;

      notifyListeners();

      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> deleteComment(final int index, final Post post) async {
    try {
      post.comments.removeAt(index);
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.itemGuid)
          .update({
        'comments': post.comments.map((final e) => e.toData()).toList()
      });

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> likeOrUnlikePost(final Post post) async {
    try {
      final _currentUser = _authProvider.currentUserFromCache;
      final bool isLiked = post.likes.contains(_currentUser.uid);

      if (isLiked) {
        post.likes.remove(_currentUser.uid);
      } else {
        post.likes.add(_currentUser.uid);
      }

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.itemGuid)
          .update({'likes': post.likes});

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<List<User>> getUsersByLikes(final List<String> likes) async {
    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      if (likes == null || likes.isEmpty) {
        return [];
      }

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await users.where(FieldPath.documentId, whereIn: likes ?? []).get();

      return querySnapshot.docs.map(DatabaseUser.fromSnap).toList();
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  // ignore: use_setters_to_change_properties
  void updateAuth(final AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future<bool> uploadPostPicture(
      final Uint8List file, final String postId) async {
    try {
      final uid = _authProvider.currentUserFromCache.uid;
      final result = await StorageProvider.uploadImage(
          file, 'posts/$postId/$uid/picture.png');
      if (!result) {
        if (file.length > 5 * 1024 * 1024) {
          AppToast.show(S.current.errorPictureSizeToBig);
        } else {
          AppToast.show(S.current.errorSomethingWentWrong);
        }
      }
      return result;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> savePost(final Map<String, dynamic> info,
      {final Uint8List image}) async {
    try {
      final uid = _authProvider.currentUserFromCache.uid;
      final DocumentReference doc =
          await FirebaseFirestore.instance.collection('posts').add({
        'text': info['text'],
        'userId': _authProvider.currentUserFromCache.uid,
        'userDisplayName': _authProvider.currentUserFromCache.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'userAvatarUrl': _authProvider.currentUserFromCache.picturePath,
        'class': info['class'],
        'score': 0
      });

      if (image != null) {
        await uploadPostPicture(image, doc.id);
        await doc.update({'imageUrl': 'posts/${doc.id}/$uid/picture.png'});
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> duplicatePost(final String postId) async {
    DocumentSnapshot<Map<String, dynamic>> post =
        await FirebaseFirestore.instance.collection('posts').doc(postId).get();
    await FirebaseFirestore.instance.collection('posts').add(post.data());
    return true;
  }

  Future<String> getProfilePictureURL(final String uuid) async {
    try {
      final imageUrl = StorageProvider.findImageUrl('users/$uuid/picture.png');
      notifyListeners();
      return imageUrl;
    } catch (e) {
      _errorHandler(e, showToast: false);
      return null;
    }
  }

  Future<String> getPostPictureURL(final String postUid) async {
    try {
      final uid = _authProvider.currentUserFromCache.uid;
      final imageUrl =
          StorageProvider.findImageUrl('posts/$postUid/$uid/picture.png');
      notifyListeners();
      return imageUrl;
    } catch (e) {
      _errorHandler(e, showToast: false);
      return null;
    }
  }

  void _errorHandler(final dynamic e, {final bool showToast = true}) {
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
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }

  Future<List<User>> getPointsLeaderboard() async {
    try {
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await usersRef.where('rankProgressionPoints', isGreaterThan: 0).get();

      final List<User> users =
          querySnapshot.docs.map(DatabaseUser.fromSnap).toList();

      // ignore: cascade_invocations
      users.sort((final a, final b) {
        final int scoreComp = b.rankProgressionPoints - a.rankProgressionPoints;
        if (scoreComp == 0) {
          return a.displayName.compareTo(b.displayName);
        }
        return scoreComp;
      });
      return users;
    } catch (e) {
      _errorHandler(e);
      return null;
    }
  }

  Future<List<Pair<User, int>>> getPostsLeaderboard() async {
    try {
      final List<Post> posts = await fetchPosts();
      print(posts);

      final Map<String, int> postCounts = {};

      for (final post in posts) {
        final userId = post.userId;
        if (postCounts.containsKey(userId)) {
          postCounts[userId]++;
        } else {
          postCounts[userId] = 1;
        }
      }

      print(postCounts);

      final List<String> userIds = postCounts.keys.toList();
      print(userIds);

      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      final QuerySnapshot<Map<String, dynamic>> userQuerySnapshot =
          await usersRef.where(FieldPath.documentId, whereIn: userIds).get();

      print(userQuerySnapshot.docs);

      final List<User> users =
          userQuerySnapshot.docs.map(DatabaseUser.fromSnap).toList();

      final List<Pair<User, int>> userPostCounts = [];
      for (final user in users) {
        final userId = user.uid;
        final postCount = postCounts[userId];
        userPostCounts.add(Pair(user, postCount));
      }

      userPostCounts.sort((final a, final b) => b.second - a.second);

      return userPostCounts;
    } catch (e) {
      _errorHandler(e);
      return null;
    }
  }
}

extension DatabaseRank on Rank {
  static Rank fromSnap(final DocumentSnapshot<Map<String, dynamic>> snap) {
    final String name = snap['name'];
    final int pointsStart = snap['pointsStart'];
    final int pointsEnd = snap['pointsEnd'];
    final bool requiresApproval = snap['requiresApproval'];

    return Rank(
        name: name,
        pointsStart: pointsStart,
        pointsEnd: pointsEnd,
        requiresApproval: requiresApproval);
  }
}

extension DatabaseComment on Comment {
  static Comment fromMap(final Map<String, dynamic> map) {
    final String text = map['text'];
    final String userDisplayName = map['userDisplayName'];
    final String userId = map['userId'];
    final DateTime createdAt = map['createdAt'].toDate();
    final List<String> upvotes = List.from(map['upvotes'] ?? []);
    final String userAvatar = map['userAvatar'];

    return Comment(
      text: text,
      userDisplayName: userDisplayName,
      userId: userId,
      createdAt: createdAt,
      upvotes: upvotes,
      userAvatar: userAvatar,
    );
  }

  Map<String, dynamic> toData() {
    return {
      'text': text,
      'userDisplayName': userDisplayName,
      'userId': userId,
      'createdAt': createdAt,
      'upvotes': upvotes,
      'userAvatar': userAvatar,
    };
  }
}

extension DatabasePost on Post {
  static Post fromSnap(final DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data();

    final List<dynamic> commentList = data['comments']; // here
    final List<Comment> comments = commentList != null
        // ignore: unnecessary_lambdas
        ? commentList.map((final commentData) {
            return DatabaseComment.fromMap(commentData);
          }).toList()
        : [];

    final String itemGuid = snap.id;
    final String text = data['text'];
    final String userId = data['userId'];
    final String userDisplayName = data['userDisplayName'];
    final String userAvatarUrl = data['userAvatarUrl'];
    final String createdAt =
        DateFormat('yyyy-MM-dd HH:mm').format(data['createdAt'].toDate());
    final DateTime modifiedAt = data['modifiedAt']?.toDateTime();
    final List<String> likes = data['likes'] != null
        ? (data['likes'] as List<dynamic>).map((final likeData) {
            final String likeUserId = likeData;
            return likeUserId;
          }).toList()
        : [];
    final int score = data['score'];
    final String imageUrl = data['imageUrl'];
    final String className = data['class'];

    final Post post = Post(
        className: className,
        comments: comments,
        itemGuid: itemGuid,
        text: text,
        userDisplayName: userDisplayName,
        userAvatarUrl: userAvatarUrl,
        userId: userId,
        date: modifiedAt != null
            ? DateFormat('yyyy-MM-dd HH:mm').format(modifiedAt)
            : createdAt,
        likes: likes,
        score: score,
        imageUrl: imageUrl);

    return post;
  }

  Map<String, dynamic> toData() {
    return {
      'text': text,
      'userId': userId,
      'userDisplayName': userDisplayName,
      'userAvatarUrl': userAvatarUrl,
      'createdAt': Timestamp.now(),
      'modifiedAt': this.date != null
          ? Timestamp.fromDate(DateTime.parse(this.date))
          : null,
      'likes': likes,
      'score': this.score,
      'imageUrl': this.imageUrl,
      'class': this.className,
      'comments':
          this.comments.map((final comment) => comment.toData()).toList()
    };
  }
}
