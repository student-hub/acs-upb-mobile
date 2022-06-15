import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/error_page.dart';
import '../model/news_feed_item.dart';
import 'news_item_details_actions.dart';
import 'news_item_details_page.dart';

const placeholderImage =
    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({this.fetchNewsFuture, final Key key}) : super(key: key);

  final Future<List<NewsFeedItem>> Function({int limit}) fetchNewsFuture;

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  Future<dynamic> newsFuture;

  String _formatDate(final String date) {
    return date;
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    newsFuture = _getNews();
  }

  Future<List<NewsFeedItem>> _getNews() async {
    return widget.fetchNewsFuture();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder(
      future: newsFuture,
      builder: (final _, final snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<NewsFeedItem> newsFeedItems = snapshot.data;
        if (newsFeedItems == null) {
          return ErrorPage(
            errorMessage: S.current.warningUnableToReachNewsFeed,
            info: [TextSpan(text: S.current.warningInternetConnection)],
            actionText: S.current.actionRefresh,
            actionOnTap: () => setState(() {}),
          );
        } else if (newsFeedItems.isEmpty) {
          return ErrorPage(
            imgPath: 'assets/illustrations/undraw_empty.png',
            errorMessage: S.current.warningNoNews,
          );
        }

        return displayCustomListViewItems(context, newsFeedItems);
      },
    );
  }

  Widget displayCustomListViewItems(
      final BuildContext context, final List<NewsFeedItem> children) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final captionStyle = Theme.of(context).textTheme.caption;
    final captionSizeFactor =
        captionStyle.fontSize / Theme.of(context).textTheme.bodyText1.fontSize;
    final captionColor = captionStyle.color;
    final displayActions =
        authProvider.isAuthenticated && !authProvider.isAnonymous;

    return RefreshIndicator(
      onRefresh: _refreshNews,
      child: ListView.builder(
        itemCount: children.length,
        itemBuilder: (final BuildContext context, final int index) {
          final NewsFeedItem newsFeedItem = children[index];
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _newsPostHeader(newsFeedItem),
                      const SizedBox(height: 10),
                      _newsDetailsTitle(title: newsFeedItem.title),
                      _newsDetailsContent(
                          content: newsFeedItem.body,
                          captionColor: captionColor,
                          captionSizeFactor: captionSizeFactor),
                      const SizedBox(height: 20),
                      displayActions
                          ? _newsDetailsActions(newsFeedItem)
                          : const SizedBox(),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<Map<dynamic, dynamic>>(
                builder: (final context) =>
                    NewsItemDetailsPage(newsItemGuid: children[index].itemGuid),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _newsPostHeader(final NewsFeedItem newsFeedItem) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(
            maxRadius: 15,
            backgroundImage: NetworkImage(
              placeholderImage,
            ),
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
          Text(createdAt, style: const TextStyle(fontSize: 12)),
        ],
      );

  Widget _newsDetailsActions(final NewsFeedItem newsFeedItem) =>
      NewsItemDetailsAction(
        newsFeedItem: newsFeedItem,
      );

  Future<void> _refreshNews() async {
    final List<NewsFeedItem> refreshedNewsItems = await _getNews();
    setState(() {
      newsFuture = Future.value(refreshedNewsItems);
    });
  }
}
