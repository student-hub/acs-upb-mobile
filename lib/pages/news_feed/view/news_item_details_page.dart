import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../resources/utils.dart';
import '../../../widgets/scaffold.dart';
import '../model/news_feed_item.dart';
import '../service/news_provider.dart';
import 'news_item_details_actions.dart';

const placeholderImage =
    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';

class NewsItemDetailsPage extends StatefulWidget {
  const NewsItemDetailsPage({@required this.newsItemGuid});
  final String newsItemGuid;

  static const String uriScheme = 'acs';
  static const String uriHost = 'acs.upb.mobile.dev';
  static const String uriPath = 'news-details';
  static const String uriQueryParam = 'guid';

  static String buildUri(final String guid) {
    return '$uriScheme://$uriHost/$uriPath?$uriQueryParam=$guid';
  }

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
      title: const Text('Details'),
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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final displayActions =
        authProvider.isAuthenticated && !authProvider.isAnonymous;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _newsPostHeader(newsFeedItem),
        const SizedBox(height: 20),
        _newsDetailsTitle(title: newsFeedItem.title),
        _newsDetailsContent(
            content: newsFeedItem.body,
            captionColor: captionColor,
            captionSizeFactor: captionSizeFactor),
        const SizedBox(height: 20),
        displayActions ? _newsDetailsActions(newsFeedItem) : const SizedBox(),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _newsPostHeader(final NewsFeedItem newsFeedItem) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            maxRadius: 15,
            backgroundImage:
                NetworkImage(newsFeedItem.authorAvatarUrl ?? placeholderImage),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _newsDetailsAuthor(newsFeedItem: newsFeedItem),
            _newsDetailsTimestamp(createdAt: newsFeedItem.createdAt),
          ],
        )
      ],
    );
  }

  String _computeDisplayName({final NewsFeedItem newsFeedItem}) {
    final categoryRole = newsFeedItem.categoryRole;
    final parts = categoryRole.split('-');
    if (parts[0] == 'organizations') {
      return '${newsFeedItem.authorDisplayName} (${parts[1]})';
    } else if (parts[0] == 'representatives') {
      return '${newsFeedItem.authorDisplayName} (${parts[1]})';
    } else {
      return newsFeedItem.authorDisplayName;
    }
  }

  Widget _newsDetailsAuthor({final NewsFeedItem newsFeedItem}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            _computeDisplayName(newsFeedItem: newsFeedItem),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Theme.of(context).primaryColor),
          ),
        ],
      );

  Widget _newsDetailsTitle({final String title}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
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
              padding: const EdgeInsets.only(top: 5, bottom: 0),
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
          Text(_formatDate(createdAt), style: const TextStyle(fontSize: 12)),
        ],
      );

  Widget _newsDetailsActions(final NewsFeedItem newsFeedItem) =>
      NewsItemDetailsAction(
        newsFeedItem: newsFeedItem,
      );
}
