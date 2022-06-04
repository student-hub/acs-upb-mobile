import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../service/news_provider.dart';
import 'news_item_details_page.dart';

class NewsItemDetailsAction extends StatefulWidget {
  const NewsItemDetailsAction({@required this.newsItemGuid});
  final String newsItemGuid;

  @override
  _NewsItemDetailsActionState createState() => _NewsItemDetailsActionState();
}

class _NewsItemDetailsActionState extends State<NewsItemDetailsAction> {
  bool isBookmarked = false;

  Future<void> _toggleBookmark(final NewsProvider newsProvider) async {
    showToast(isBookmarked ? 'Removed from favorites' : 'Added to favorites');
    if (isBookmarked) {
      if (await newsProvider.unbookmarkNewsItem(widget.newsItemGuid)) {
        setState(() => isBookmarked = false);
      }
    } else {
      if (await newsProvider.bookmarkNewsItem(widget.newsItemGuid)) {
        setState(() => isBookmarked = true);
      }
    }
  }

  void _shareNewsItem() {
    final uri = Uri.parse(
        '${NewsItemDetailsPage.uriScheme}://${NewsItemDetailsPage.uriHost}/${NewsItemDetailsPage.uriPath}?${NewsItemDetailsPage.uriQueryParam}=${widget.newsItemGuid}');
    Share.share(uri.toString());
  }

  @override
  Widget build(final BuildContext context) {
    final newsFeedProvider = Provider.of<NewsProvider>(context);
    isBookmarked = newsFeedProvider.isNewsItemBookmarked(widget.newsItemGuid);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareNewsItem,
        ),
        if (!isBookmarked)
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            onPressed: () => _toggleBookmark(newsFeedProvider),
          )
        else
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            onPressed: () => _toggleBookmark(newsFeedProvider),
          ),
      ],
    );
  }
}
