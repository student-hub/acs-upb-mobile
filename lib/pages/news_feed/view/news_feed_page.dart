import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../navigation/routes.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../model/news_feed_item.dart';
import '../service/news_provider.dart';
import 'news_item_details_page.dart';

class NewsFeedPage extends StatefulWidget {
  static const String routeName = '/news_feed';

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class NewsItemDetailsRouteArguments {
  NewsItemDetailsRouteArguments({@required this.itemId});
  final String itemId;
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  @override
  Widget build(final BuildContext context) {
    final newsFeedProvider = Provider.of<NewsProvider>(context);

    return AppScaffold(
      title: Text(S.current.navigationNewsFeed),
      body: FutureBuilder(
        future: newsFeedProvider.fetchNewsFeedItems(),
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
                .map((final item) => ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.createdAt),
                      trailing: const Icon(Icons.arrow_forward_ios_outlined),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (final context) => NewsItemDetailsPage(
                                  newsItemGuid: item.itemGuid))),
                      dense: true,
                    ))
                .toList(),
          ).toList());
        },
      ),
    );
  }
}
