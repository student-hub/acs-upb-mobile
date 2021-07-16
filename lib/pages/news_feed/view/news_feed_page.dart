import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../model/news_feed_item.dart';
import '../service/news_provider.dart';

class NewsFeedPage extends StatefulWidget {
  static const String routeName = '/news_feed';

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  @override
  Widget build(BuildContext context) {
    final newsFeedProvider = Provider.of<NewsProvider>(context);

    return AppScaffold(
      title: Text(S.current.navigationNewsFeed),
      body: FutureBuilder(
        future: newsFeedProvider.fetchNewsFeedItems(),
        builder: (_, snapshot) {
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
                .map((item) => ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.date),
                      trailing: const Icon(Icons.arrow_forward_ios_outlined),
                      onTap: () => Utils.launchURL(item.link),
                      dense: true,
                    ))
                .toList(),
          ).toList());
        },
      ),
    );
  }
}
