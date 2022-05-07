import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:oktoast/oktoast.dart';

import '../../../resources/utils.dart';
import '../../../widgets/auto_size_markdown.dart';
import '../../../widgets/scaffold.dart';
import '../model/news_feed_item.dart';
import '../service/news_provider.dart';
import 'news_feed_page.dart';

class NewsItemDetailsPage extends StatefulWidget {
  const NewsItemDetailsPage({@required this.newsItemGuid});
  final String newsItemGuid;

  @override
  _NewsItemDetailsState createState() =>
      // ignore: no_logic_in_create_state
      _NewsItemDetailsState(newsItemGuid: newsItemGuid);
}

class _NewsItemDetailsState extends State<NewsItemDetailsPage> {
  _NewsItemDetailsState({@required this.newsItemGuid});

  final String newsItemGuid;
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

  String _returnLongText() {
    return '# Title';
  }

  String _returnShortText() {
    return 'Pokemon';
  }

  String _formatDate(final String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(final BuildContext context) {
    final newsFeedProvider = Provider.of<NewsProvider>(context);

    return AppScaffold(
      title: const Text('Detalii'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder(
                      future:
                          newsFeedProvider.fetchNewsItemDetails(newsItemGuid),
                      builder: (final context, final snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            final NewsFeedItem newsFeedItem = snapshot.data;
                            return _newsDetailsWrapper(
                                context: context, newsFeedItem: newsFeedItem);
                          }
                          return _detailsNotLoadedWidget();
                        }
                        return _detailsCircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailsCircularProgressIndicator() => const Padding(
        padding: EdgeInsets.only(top: 12, bottom: 12),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget _detailsNotLoadedWidget() => const Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Center(
            child: Text(
              'More details could not be loaded',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  Widget _newsDetailsWrapper(
      {final BuildContext context, final NewsFeedItem newsFeedItem}) {
    final captionStyle = Theme.of(context).textTheme.caption;
    final captionSizeFactor =
        captionStyle.fontSize / Theme.of(context).textTheme.bodyText1.fontSize;
    final captionColor = captionStyle.color;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _newsDetailsAuthor(author: newsFeedItem.source),
        _newsDetailsContent(
            content: newsFeedItem.body,
            captionColor: captionColor,
            captionSizeFactor: captionSizeFactor),
        _newsDetailsTimestamp(createdAt: _formatDate(newsFeedItem.createdAt)),
        _newsDetailsAction(),
      ],
    );
  }

  Widget _newsDetailsAuthor({final String author}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Padding(
            padding: EdgeInsets.only(left: 4, right: 0, top: 0, bottom: 0),
            child: Text('a postat:'),
          ),
        ],
      );

  Widget _newsDetailsContent(
          {final String content,
          final Color captionColor,
          final double captionSizeFactor}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: MarkdownBody(
              fitContent: false,
              onTapLink: (final text, final link, final title) =>
                  Utils.launchURL(link),
              /*
                  This is a workaround because the strings in Firebase represent
                  newlines as '\n' and Firebase replaces them with '\\n'. We need
                  to replace them back for them to display properly.
                  (See GitHub issue firebase/firebase-js-sdk#2366)
                  */
              data: content.replaceAll('\\n', '\n'),
              extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes, [
                md.EmojiSyntax(),
                ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
              ]),
            ),
          ))
        ],
      );

  Widget _newsDetailsTimestamp({final String createdAt}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Posted on: $createdAt', style: const TextStyle(fontSize: 12)),
        ],
      );

  Widget _newsDetailsAction() => Row(
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
      );
}
