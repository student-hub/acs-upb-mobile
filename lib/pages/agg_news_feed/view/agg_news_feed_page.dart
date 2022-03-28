import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../model/agg_news_feed_item.dart';
import '../service/agg_news_provider.dart';

class AggNewsFeedPage extends StatefulWidget {
  static const String routeName = '/agg_news_feed';

  @override
  _AggNewsFeedPageState createState() => _AggNewsFeedPageState();
}

class _AggNewsFeedPageState extends State<AggNewsFeedPage> {
  @override
  Widget build(BuildContext context) {
    final aggNewsFeedProvider = Provider.of<AggNewsProvider>(context);

    return AppScaffold(
      title: Text(S.current.aggNavigationNewsFeed),
      body: FutureBuilder(
        future: aggNewsFeedProvider.fetchNewsFeedItems(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<AggNewsFeedItem> newsFeedItems = snapshot.data;
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
