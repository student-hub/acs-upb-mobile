import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../model/news_feed_item.dart';
import '../service/news_provider.dart';
import 'news_item_details_page.dart';

class NewsFeedFavoritePage extends StatefulWidget {
  const NewsFeedFavoritePage({final Key key}) : super(key: key);

  @override
  _NewsFeedFavoritePageState createState() => _NewsFeedFavoritePageState();
}

class _NewsFeedFavoritePageState extends State<NewsFeedFavoritePage> {
  String _formatDate(final String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(final BuildContext context) {
    final newsFeedProvider = Provider.of<NewsProvider>(context);

    return FutureBuilder(
      future: newsFeedProvider.fetchFavoriteNewsFeedItems(),
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

        return ListView(
            children: ListTile.divideTiles(
          context: context,
          tiles: newsFeedItems
              .map(
                (final item) => ListTile(
                  title: Text(item.title),
                  subtitle: Text(_formatDate(item.createdAt)),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<Map<dynamic, dynamic>>(
                      builder: (final context) =>
                          NewsItemDetailsPage(newsItemGuid: item.itemGuid),
                    ),
                  ),
                  dense: true,
                ),
              )
              .toList(),
        ).toList());
      },
    );
  }
}
