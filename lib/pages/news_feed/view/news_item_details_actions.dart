import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../authentication/service/auth_provider.dart';
import '../model/news_feed_item.dart';
import '../service/news_provider.dart';
import 'news_item_details_page.dart';

class NewsItemDetailsAction extends StatefulWidget {
  const NewsItemDetailsAction({@required this.newsFeedItem});
  final NewsFeedItem newsFeedItem;

  @override
  _NewsItemDetailsActionState createState() => _NewsItemDetailsActionState();
}

class _NewsItemDetailsActionState extends State<NewsItemDetailsAction> {
  bool isBookmarked = false;
  bool isOwner = false;

  Future<void> _toggleBookmark(final NewsProvider newsProvider) async {
    showToast(isBookmarked ? 'Removed from favorites' : 'Added to favorites');
    if (isBookmarked) {
      if (await newsProvider.unbookmarkNewsItem(widget.newsFeedItem.itemGuid)) {
        setState(() => isBookmarked = false);
      }
    } else {
      if (await newsProvider.bookmarkNewsItem(widget.newsFeedItem.itemGuid)) {
        setState(() => isBookmarked = true);
      }
    }
  }

  void _shareNewsItem() {
    final uri = Uri.parse(
        '${NewsItemDetailsPage.uriScheme}://${NewsItemDetailsPage.uriHost}/${NewsItemDetailsPage.uriPath}?${NewsItemDetailsPage.uriQueryParam}=${widget.newsFeedItem.itemGuid}');
    Share.share(uri.toString());
  }

  Future<void> _deletePost() async {
    final NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);
    final result = await newsProvider.deletePost(widget.newsFeedItem.itemGuid);
    showToast(result ? 'Post successfully deleted' : 'Post failed to delete');
  }

  @override
  Widget build(final BuildContext context) {
    final newsFeedProvider = Provider.of<NewsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    isBookmarked =
        newsFeedProvider.isNewsItemBookmarked(widget.newsFeedItem.itemGuid);
    isOwner =
        widget.newsFeedItem.userId == authProvider.currentUserFromCache.uid;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isOwner) ...[
          IconButton(
            onPressed: () async {
              await _deletePost();
            },
            icon: const Icon(Icons.delete),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            constraints: const BoxConstraints(),
          )
        ],
        IconButton(
            icon: const Icon(Icons.share),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            constraints: const BoxConstraints(),
            iconSize: 20,
            onPressed: _shareNewsItem),
        if (!isBookmarked)
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            constraints: const BoxConstraints(),
            iconSize: 20,
            onPressed: () => _toggleBookmark(newsFeedProvider),
          )
        else
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            constraints: const BoxConstraints(),
            iconSize: 20,
            onPressed: () => _toggleBookmark(newsFeedProvider),
          ),
      ],
    );
  }
}
