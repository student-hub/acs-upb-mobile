import 'dart:math';
import 'package:acs_upb_mobile/pages/news_feed/model/news_feed_item.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:web_scraper/web_scraper.dart';

class NewsProvider with ChangeNotifier {
  static const _textSelector = 'title';
  static const _attributesSelector = 'attributes';
  static const _hrefSelector = 'href';

  Future<List<NewsFeedItem>> fetchNewsFeedItems(
      {BuildContext context, int limit}) async {
    try {
      final webScraper = WebScraper('https://acs.pub.ro');
      final bool scrapeSuccess = await webScraper.loadWebPage('/topic/noutati');

      if (scrapeSuccess) {
        return _extractFromWebScraper(webScraper, limit);
      }
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
    }

    return null;
  }

  static Iterable<NewsFeedItem> _extractFromWebScraper(
      WebScraper webScraper, int wantedLimit) {
    final List<Map<String, dynamic>> dates =
        webScraper.getElement('div.event > ul > li > div.time', []);
    final List<Map<String, dynamic>> events =
        webScraper.getElement('div.event > ul > li > h3 > a', ['href']);

    final List<NewsFeedItem> newsFeed = [];
    var limit = min(dates.length, events.length);
    if (wantedLimit != null) {
      limit = min(limit, wantedLimit);
    }

    for (var i = 0; i < limit; ++i) {
      final date = dates[i][_textSelector];
      final title = events[i][_textSelector];
      final link = events[i][_attributesSelector][_hrefSelector];
      newsFeed.add(NewsFeedItem(date, title, link));
    }

    return newsFeed;
  }
}
