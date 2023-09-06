import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../model/post_item.dart';
import '../service/post_provider.dart';
import 'create_post_page.dart';
import 'widgets/post.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({
    @required this.className,
    final Key key,
  }) : super(key: key);
  final String className;

  static const String routeName = '/feed_class';

  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
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
    return AppScaffold(
      title: Text(widget.className),
      actions: [
        AppScaffoldAction(
          icon: Icons.add,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<Map<dynamic, dynamic>>(
              builder: (final context) => PostCreatePage(
                refreshCallback: refreshPosts,
                className: widget.className,
              ),
            ),
          ),
        ),
      ],
      body: FirestoreQueryBuilder<Post>(
        query: _postProvider.queryPostsByClass(widget.className),
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
