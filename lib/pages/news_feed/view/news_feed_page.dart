import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../model/news_feed_item.dart';
import '../service/news_provider.dart';
import 'news_item_details_page.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({this.fetchNewsFuture, final Key key}) : super(key: key);

  final Future<List<NewsFeedItem>> Function({int limit}) fetchNewsFuture;

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  Future<dynamic> newsFuture;

  String _formatDate(final String date) {
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
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (final BuildContext context, final int index) {
        final NewsFeedItem newsFeedItem = children[index];
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _newsDetailsAuthor(author: newsFeedItem.source),
                          _newsDetailsTitle(title: newsFeedItem.title),
                          _newsDetailsTimestamp(
                              createdAt: newsFeedItem.createdAt),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                      ),
                    ),
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
    );
  }

  Widget _newsDetailsAuthor({final String author}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            author,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).primaryColor),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 4, right: 0, top: 0, bottom: 0),
            child: Text(
              'a postat:',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget _newsDetailsTitle({final String title}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );

  Widget _newsDetailsTimestamp({final String createdAt}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Posted on: ${_formatDate(createdAt)}',
              style: const TextStyle(fontSize: 12)),
        ],
      );

  Widget displayListViewItems(
      final BuildContext context, final List<NewsFeedItem> children) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (final BuildContext context, final int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          child: Card(
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(
                  children[index].title,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              dense: true,
              subtitle: Text(
                'Author: ${children[index].source}\nDate: ${_formatDate(children[index].createdAt)}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<Map<dynamic, dynamic>>(
                  builder: (final context) => NewsItemDetailsPage(
                      newsItemGuid: children[index].itemGuid),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
