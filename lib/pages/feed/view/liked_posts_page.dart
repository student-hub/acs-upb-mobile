import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../model/post_item.dart';
import '../service/post_provider.dart';
import 'widgets/post.dart';

class LikedPostsPage extends StatefulWidget {
  const LikedPostsPage({
    final Key key,
  }) : super(key: key);

  static const String routeName = '/feed_class';

  @override
  _LikedPostsPageState createState() => _LikedPostsPageState();
}

class _LikedPostsPageState extends State<LikedPostsPage> {
  @override
  void initState() {
    super.initState();
  }

  void refreshPosts() {
    setState(() {});
  }

  @override
  Widget build(final BuildContext context) {
    final PostProvider _postProvider = Provider.of<PostProvider>(context);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AppScaffold(
      title: const Text('Liked posts'),
      body: FirestoreQueryBuilder<Post>(
        query: _postProvider
            .queryPostsByLikes(_authProvider.currentUserFromCache.uid),
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
  }

  String getNoPostsMessage() {
    return 'No posts';
  }
}
