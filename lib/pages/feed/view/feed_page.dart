import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../model/post_item.dart';
import '../service/post_provider.dart';
import 'create_post_page.dart';
import 'feed_search_page.dart';
import 'leaderboard_page.dart';
import 'liked_posts_page.dart';
import 'user_info_page.dart';
import 'widgets/post.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({final Key key}) : super(key: key);

  static const String routeName = '/feed';

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String show = 'only';

  @override
  void initState() {
    super.initState();
  }

  void refreshPosts() {
    setState(() {});
  }

  @override
  Widget build(final BuildContext context) {
    final PostProvider _postProvider =
        Provider.of<PostProvider>(context, listen: false);
    final AuthProvider _authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: const Text('Feed'),
      leading: AppScaffoldAction(
        icon: Icons.add,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<Map<dynamic, dynamic>>(
            builder: (final context) =>
                PostCreatePage(refreshCallback: refreshPosts),
          ),
        ),
      ),
      actions: [
        AppScaffoldAction(
          icon: FeatherIcons.filter,
          items: {
            'Show only my classes': () {
              if (show == 'only') {
                AppToast.show('Already showing your classes');
                return;
              }
              setState(() {
                show = 'only';
              });
            },
            'Show all classes': () {
              if (show == 'all') {
                AppToast.show('Already showing all classes');
                return;
              }
              setState(() {
                show = 'all';
              });
            }
          },
        ),
        AppScaffoldAction(
          icon: FeatherIcons.moreVertical,
          items: {
            'My profile': () => Navigator.push(
                  context,
                  MaterialPageRoute<Map<dynamic, dynamic>>(
                    builder: (final context) => UserInfoPage(
                      userId: _authProvider.currentUserFromCache?.uid,
                    ),
                  ),
                ),
            'Search': () => Navigator.push(
                  context,
                  MaterialPageRoute<Map<dynamic, dynamic>>(
                    builder: (final context) => const FeedSearchPage(),
                  ),
                ),
            'Leaderboard': () => Navigator.push(
                  context,
                  MaterialPageRoute<Map<dynamic, dynamic>>(
                    builder: (final context) => const LeaderboardPage(),
                  ),
                ),
            'Liked posts': () => Navigator.push(
                  context,
                  MaterialPageRoute<Map<dynamic, dynamic>>(
                    builder: (final context) => const LikedPostsPage(),
                  ),
                ),
          },
        ),
      ],
      body: FutureBuilder(
        future: _postProvider
            .fetchUserClassIds(_authProvider.currentUserFromCache?.uid),
        builder: (final context, final snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<String> classes = snapshot.data;
          return RefreshIndicator(
            onRefresh: () {
              refreshPosts();
              return;
            },
            child: FirestoreQueryBuilder<Post>(
              query: show == 'all'
                  ? _postProvider.queryPosts()
                  : _postProvider.queryPostsByClasses(classes),
              builder: (final context, final snapshot, final _) {
                if (snapshot.isFetching) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.docs.isEmpty) {
                  return const ErrorPage(
                    imgPath: 'assets/illustrations/undraw_empty.png',
                    errorMessage: 'No posts here yet :(',
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.docs.length,
                  itemBuilder: (final context, final index) {
                    return PostWidget(
                      post: snapshot.docs[index].data(),
                      refreshCallback: refreshPosts,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  String getNoPostsMessage() {
    return 'No posts';
  }
}
