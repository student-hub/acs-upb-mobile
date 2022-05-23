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
  const NewsFeedPage({final Key key}) : super(key: key);

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  Future<dynamic> newsFuture;

  String _formatDate(final String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<List<NewsFeedItem>> _getNewsItems() async {
    final NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);
    return newsProvider.fetchNewsFeedItems();
  }

  @override
  void initState() {
    super.initState();
    newsFuture = _getNewsItems();
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

        return displayListViewItems(context, newsFeedItems);
      },
    );
  }

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
