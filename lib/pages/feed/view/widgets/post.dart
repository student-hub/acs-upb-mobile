import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/post_item.dart';
import '../../service/post_provider.dart';
import 'post_actions.dart';
import 'post_header.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({this.post, this.refreshCallback});

  final Post post;
  final void Function() refreshCallback;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(final BuildContext context) {
    final PostProvider _postProvider =
        Provider.of<PostProvider>(context, listen: false);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: PostHeader(
              userId: widget.post.userId,
              username: widget.post.userDisplayName,
              date: widget.post.date,
              className: widget.post.className,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.post.text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (widget.post.imageUrl != null)
            FutureBuilder(
              future: _postProvider.getPostPictureURL(widget.post.itemGuid),
              builder: (final context, final snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox();
                }
                final String imageUrl = snapshot.data;
                if (imageUrl == null) {
                  return const SizedBox();
                }
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<Map<dynamic, dynamic>>(
                        builder: (final context) => Scaffold(
                          body: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: FittedBox(
                                child: Image.network(imageUrl),
                                fit: BoxFit.contain),
                          ),
                        ),
                      )),
                  child: FittedBox(
                    child: Image.network(imageUrl),
                  ),
                );
              },
            ),
          Padding(
              padding: const EdgeInsets.all(12),
              child: PostActions(
                post: widget.post,
                refreshCallback: widget.refreshCallback,
              ))
        ],
      ),
    );
  }
}
