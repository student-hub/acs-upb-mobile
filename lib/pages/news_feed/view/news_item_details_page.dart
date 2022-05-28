import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

import '../../../resources/utils.dart';
import '../../../widgets/scaffold.dart';
import '../model/news_feed_item.dart';
import '../service/news_provider.dart';
import 'news_item_details_actions.dart';

class NewsItemDetailsPage extends StatefulWidget {
  const NewsItemDetailsPage({@required this.newsItemGuid});
  final String newsItemGuid;

  @override
  _NewsItemDetailsState createState() => _NewsItemDetailsState();
}

class _NewsItemDetailsState extends State<NewsItemDetailsPage> {
  Future<dynamic> detailsFuture;

  @override
  void initState() {
    super.initState();
    detailsFuture = _getDetails();
  }

  Future<NewsFeedItem> _getDetails() async {
    final NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);
    return newsProvider.fetchNewsItemDetails(widget.newsItemGuid);
  }

  String _formatDate(final String date) =>
      DateFormat('yyyy-MM-dd').format(DateTime.parse(date));

  @override
  Widget build(final BuildContext context) {
    return AppScaffold(
      title: const Text('Detalii'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder(
                      future: detailsFuture,
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
        _newsDetailsAuthor(author: newsFeedItem.externalSource),
        _newsDetailsContent(
            content: newsFeedItem.body,
            captionColor: captionColor,
            captionSizeFactor: captionSizeFactor),
        _newsDetailsTimestamp(createdAt: _formatDate(newsFeedItem.createdAt)),
        _newsDetailsActions(),
      ],
    );
  }

  Widget _newsDetailsAuthor({final String author}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              author,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
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
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Widget _newsDetailsTimestamp({final String createdAt}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Posted on: $createdAt',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      );

  Widget _newsDetailsActions() =>
      NewsItemDetailsAction(newsItemGuid: widget.newsItemGuid);
}
