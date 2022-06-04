import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../navigation/routes.dart';
import '../../resources/utils.dart';
import '../../widgets/info_card.dart';
import '../news_feed/model/news_feed_item.dart';
import '../news_feed/service/news_provider.dart';
import '../news_feed/view/news_item_details_page.dart';

class NewsFeedCard extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return InfoCard<List<NewsFeedItem>>(
      title: S.current.navigationNewsFeed,
      showMoreButtonKey: const ValueKey('show_more_news_feed'),
      onShowMore: () => Navigator.of(context).pushNamed(Routes.newsFeed),
      future: Provider.of<NewsProvider>(context).fetchNewsFeedItems(limit: 2),
      builder: (final newsFeedItems) {
        return Column(
          children: newsFeedItems
              .map(
                (final item) => ListTile(
                  title: Text(item.title),
                  subtitle: Text('Posted on: ${item.createdAt}'),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<Map<dynamic, dynamic>>(
                      builder: (final context) =>
                          NewsItemDetailsPage(newsItemGuid: item.itemGuid),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
