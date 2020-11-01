import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/news_feed/model/news_feed_item.dart';
import 'package:acs_upb_mobile/pages/news_feed/service/news_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      title: Text(S.of(context).navigationNewsFeed),
      body: FutureBuilder(
        future: newsFeedProvider.fetchNewsFeedItems(context: context),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<NewsFeedItem> newsFeedItems = snapshot.data;
          if (newsFeedItems == null) {
            return ErrorPage(
              errorMessage: S.of(context).warningUnableToReachNewsFeed,
              info: S.of(context).warningInternetConnection,
              actionText: S.of(context).actionRefresh,
              actionOnTap: () => setState(() {}),
            );
          } else if (newsFeedItems.isEmpty) {
            return ErrorPage(
              imgPath: 'assets/illustrations/undraw_empty.png',
              errorMessage: S.of(context).warningNoNews,
            );
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

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    @required this.errorMessage,
    this.imgPath = 'assets/illustrations/undraw_warning.png',
    this.info,
    this.actionText,
    this.actionOnTap,
    Key key,
  }) : super(key: key);

  final String imgPath;
  final String errorMessage;
  final String info;
  final String actionText;
  final void Function() actionOnTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(image: AssetImage(imgPath)),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      errorMessage,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (info != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          info,
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  if (actionText != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: actionOnTap,
                        child: Text(actionText,
                            style: Theme.of(context)
                                .accentTextTheme
                                .subtitle2
                                .copyWith(fontWeight: FontWeight.w500)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
}
