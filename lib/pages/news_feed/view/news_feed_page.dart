import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/news_feed/model/news_feed_item.dart';
import 'package:acs_upb_mobile/pages/news_feed/service/news_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsFeedPage extends StatelessWidget {
  static const String routeName = '/news_feed';

  @override
  Widget build(BuildContext context) {
    final newsFeedProvider = Provider.of<NewsProvider>(context);

    return AppScaffold(
      title: S.of(context).navigationNewsFeed,
      body: FutureBuilder(
        future: newsFeedProvider.fetchNewsFeedItems(context: context),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<NewsFeedItem> newsFeedItems = snapshot.data;
          return ListView(
              children: ListTile.divideTiles(
            context: context,
            tiles: newsFeedItems
                .map((item) => ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.date),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).accentColor),
                      onTap: () => Utils.launchURL(item.link, context: context),
                      dense: true,
                    ))
                .toList(),
          ).toList());
        },
      ),
    );
  }
}
