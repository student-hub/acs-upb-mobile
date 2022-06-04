import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../service/news_provider.dart';

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

  void _copyToClipboard(final String text) {
    showToast('Copied content to clipboard');
    Clipboard.setData(ClipboardData(text: text));
  }

  void _shareNewsItem() {
    print('Share news item');
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
        IconButton(
          icon: const Icon(Icons.copy_outlined),
          onPressed: () => _copyToClipboard('ola'),
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
