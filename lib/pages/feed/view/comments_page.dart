import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../authentication/service/auth_provider.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../model/post_item.dart';
import '../service/post_provider.dart';
import 'user_info_page.dart';
import 'widgets/post_header.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({@required this.post, final Key key}) : super(key: key);
  final Post post;

  static const String routeName = '/likes';

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  Future<List<User>> users;
  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context);
    final _postProvider = Provider.of<PostProvider>(context);
    return AppScaffold(
      title: const Text('Comments'),
      body: Column(
        children: [
          if (widget.post.comments.isNotEmpty)
            _commentList(_authProvider, _postProvider)
          else
            const Expanded(
              child: ErrorPage(
                imgPath: 'assets/illustrations/undraw_empty.png',
                errorMessage: 'No comments yet :(',
              ),
            ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Comment',
                      suffixIcon: IconButton(
                          onPressed: () {
                            _postProvider.addComment(
                                _controller.text, widget.post);
                            _controller.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.send)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _commentList(
      final AuthProvider _authProvider, final PostProvider _postProvider) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.post.comments.length,
        itemBuilder: (final BuildContext context, final int index) {
          final bool isOwnComment = widget.post.comments[index].userId ==
              _authProvider.currentUserFromCache.uid;
          final commentSize = isOwnComment ? 124 : 84;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<Map<dynamic, dynamic>>(
                  builder: (final context) => UserInfoPage(
                    userId: widget.post.comments[index].userId,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: _postProvider.getProfilePictureURL(
                        widget.post.comments[index].userId),
                    builder: (final context, final snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(placeholderImage),
                          ),
                        );
                      }

                      final String photoUrl = snapshot.data;
                      return CircleAvatar(
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : const NetworkImage(placeholderImage),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text(
                              widget.post.comments[index].userDisplayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text('·'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(convertToAgo(widget
                                  .post.comments[index].createdAt
                                  .toString())),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: SizedBox(
                          width:
                              MediaQuery.of(context).size.width - commentSize,
                          child: Text(
                            widget.post.comments[index].text,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isOwnComment)
                    IconButton(
                      onPressed: () =>
                          _postProvider.deleteComment(index, widget.post),
                      icon: const Icon(Icons.delete),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
