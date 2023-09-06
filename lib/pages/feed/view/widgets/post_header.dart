import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/post_provider.dart';
import '../class_page.dart';
import '../user_info_page.dart';

String convertToAgo(final String dateTime) {
  final DateTime input = DateTime.parse(dateTime);
  final Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 1) {
    return '${diff.inDays}d';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours}h';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes}m';
  } else if (diff.inSeconds >= 1) {
    return '${diff.inSeconds}s';
  } else {
    return 'just now';
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    @required this.username,
    @required this.date,
    @required this.className,
    @required this.userId,
    this.avatarUrl,
  });

  final String username;
  final String userId;
  final String date;
  final String avatarUrl;
  final String className;

  @override
  Widget build(final BuildContext context) {
    final PostProvider _postProvider =
        Provider.of<PostProvider>(context, listen: false);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            child: FutureBuilder(
                future: _postProvider.getProfilePictureURL(userId),
                builder: (final context, final snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                        child: CircleAvatar(
                      backgroundImage: NetworkImage(placeholderImage),
                    ));
                  }
                  final String photoUrl = snapshot.data;
                  return CircleAvatar(
                    backgroundImage: photoUrl != null
                        ? NetworkImage(photoUrl)
                        : const NetworkImage(placeholderImage),
                  );
                }),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<Map<dynamic, dynamic>>(
                builder: (final context) => UserInfoPage(userId: userId),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Text(
                username,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<Map<dynamic, dynamic>>(
                  builder: (final context) => UserInfoPage(userId: userId),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text(
                    className,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<Map<dynamic, dynamic>>(
                      builder: (final context) => ClassPage(
                        className: className,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text('·'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(convertToAgo(date)),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
