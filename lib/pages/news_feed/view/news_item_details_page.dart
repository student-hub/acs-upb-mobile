import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import '../../../widgets/scaffold.dart';
import 'news_feed_page.dart';

class NewsItemDetailsPage extends StatefulWidget {
  static const String routeName = '/news-item-details';

  @override
  _NewsItemDetailsState createState() => _NewsItemDetailsState();
}

class _NewsItemDetailsState extends State<NewsItemDetailsPage> {
  static const String routeName = '/news-feed-items';

  bool isBookmarked = false;

  void _toggleBookmark() {
    showToast(isBookmarked ? 'Removed from favorites' : 'Added to favorites');
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void _copyToClipboard(text) {
    showToast('Copied content to clipboard');
    Clipboard.setData(ClipboardData(text: text));
  }

  void _shareNewsItem() {
    print('Share news item');
  }

  String _extractUrl(final BuildContext context) {
    final NewsItemDetailsRouteArguments args =
        ModalRoute.of(context).settings.arguments;
    return args.itemId;
  }

  String returnLongText() {
    return 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s\n\nwith the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing';
  }

  @override
  Widget build(final BuildContext context) {
    final String longText = returnLongText();
    return AppScaffold(
      title: const Text('Detalii'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const Text('Ola',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Padding(
                      padding:
                          EdgeInsets.only(left: 4, right: 0, top: 0, bottom: 0),
                      child: Text('a postat:'),
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          longText,
                          style: const TextStyle(fontSize: 12),
                        ),
                      )),
                    ],
                  ),
                  Row(
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
                          onPressed: _toggleBookmark,
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.bookmark_rounded),
                          onPressed: _toggleBookmark,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
