import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/news_feed/model/news_feed_item.dart';
import 'package:acs_upb_mobile/pages/news_feed/service/news_feed_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsFeedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InfoCard<List<NewsFeedItem>>(
      title: S.of(context).newsFeedTitle,
      showMoreButtonKey: const ValueKey('show_more_news_feed'),
      onShowMore: () => Navigator.of(context).pushNamed(Routes.newsFeed),
      future:
          Provider.of<NewsFeedProvider>(context).fetchNewsFeedItems(limit: 2),
      builder: (newsFeedItems) => Column(
          children: newsFeedItems
              .map((item) => ListTile(
                    title: Text(item.title),
                    subtitle: AutoSizeText(item.date,
                        maxLines: 1, overflow: TextOverflow.fade),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    onTap: () => Utils.launchURL(item.link, context: context),
                  ))
              .toList()),
    );
  }
}
