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

  Widget _noNewsWidget(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 1, child: Container()),
            const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                    image: AssetImage('assets/illustrations/undraw_empty.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                S.of(context).warningNoNews,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final newsFeedProvider = Provider.of<NewsProvider>(context);

    return AppScaffold(
      title: Text(S.of(context).navigationNewsFeed),
      body: FutureBuilder(
        future: newsFeedProvider.fetchNewsFeedItems(context: context),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<NewsFeedItem> newsFeedItems = snapshot.data;
          if (newsFeedItems == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  S.of(context).warningUnableToReachNewsFeed,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            );
          } else if (newsFeedItems.isEmpty) {
            return _noNewsWidget(context);
          }

          return ListView(
              children: ListTile.divideTiles(
            context: context,
            tiles: newsFeedItems
                .map((item) => ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.date),
                      trailing: const Icon(Icons.arrow_forward_ios),
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
