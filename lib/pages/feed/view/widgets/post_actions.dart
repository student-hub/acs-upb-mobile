import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../authentication/service/auth_provider.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/dialog.dart';
import '../../../../widgets/toast.dart';
import '../../model/post_item.dart';
import '../../service/post_provider.dart';
import '../comments_page.dart';
import '../likes_page.dart';

class PostActions extends StatefulWidget {
  const PostActions({@required this.post, this.refreshCallback});
  final Post post;
  final void Function() refreshCallback;

  @override
  _PostActionsState createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  Future<void> _onConfirmedDeletePost() async {
    final PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);
    final result = await postProvider.deletePost(widget.post);
    AppToast.show(
        result ? 'Post successfully deleted' : 'Post failed to delete');
    if (widget.refreshCallback != null) {
      widget.refreshCallback();
    }
  }

  AppDialog _deletionConfirmationDialog(
          {final BuildContext context, final Function onDelete}) =>
      AppDialog(
        icon: const Icon(Icons.delete_outlined),
        title: 'Delete post',
        message: 'Are you sure you want to delete this post?',
        info: 'This action cannot be undo',
        actions: [
          AppButton(
            text: 'Delete post',
            width: 130,
            onTap: onDelete,
          )
        ],
      );

  Future<void> _deletePost(final BuildContext context) async {
    if (!mounted) return;
    await showDialog<dynamic>(
      context: context,
      builder: (final context) => _deletionConfirmationDialog(
        context: context,
        onDelete: () async {
          Navigator.pop(context);
          await _onConfirmedDeletePost();
        },
      ),
    );
  }

  void like(final BuildContext context) {
    Provider.of<PostProvider>(context, listen: false)
        .likeOrUnlikePost(widget.post);
  }

  @override
  Widget build(final BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context, listen: true);
    final bool isOwner =
        widget.post.userId == authProvider.currentUserFromCache.uid;
    final bool isLiked =
        widget.post.likes.contains(authProvider.currentUserFromCache.uid);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.thumb_up,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '${widget.post.likes.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<Map<dynamic, dynamic>>(
                  builder: (final context) => LikesPage(
                    likes: widget.post.likes,
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Comments: ${widget.post.comments.length}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<Map<dynamic, dynamic>>(
                  builder: (final context) => CommentsPage(
                    post: widget.post,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isLiked)
              IconButton(
                icon: const Icon(Icons.thumb_up_outlined),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                constraints: const BoxConstraints(),
                iconSize: 20,
                onPressed: () => postProvider.likeOrUnlikePost(widget.post),
              )
            else
              IconButton(
                icon:
                    Icon(Icons.thumb_up, color: Theme.of(context).primaryColor),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                constraints: const BoxConstraints(),
                iconSize: 20,
                onPressed: () => postProvider.likeOrUnlikePost(widget.post),
              ),
            IconButton(
              icon: const Icon(Icons.comment),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              constraints: const BoxConstraints(),
              iconSize: 20,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<Map<dynamic, dynamic>>(
                  builder: (final context) => CommentsPage(
                    post: widget.post,
                  ),
                ),
              ),
            ),
            if (isOwner) ...[
              IconButton(
                onPressed: () async {
                  await _deletePost(context);
                },
                icon: const Icon(Icons.delete),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                constraints: const BoxConstraints(),
              )
            ],
          ],
        ),
      ],
    );
  }
}
