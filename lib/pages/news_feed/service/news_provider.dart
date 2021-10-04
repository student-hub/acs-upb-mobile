import 'dart:math';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/news_feed/model/news_feed_item.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web_scraper/web_scraper.dart';

class NewsProvider with ChangeNotifier {
  static const _textSelector = 'title';
  static const _attributesSelector = 'attributes';
  static const _hrefSelector = 'href';

  Future<List<NewsFeedItem>> fetchNewsFeedItems({int limit}) async {
    try {
      // The internet is a scary place. CORS (cross origin resource sharing)
      // prevents websites from accessing resources outside the server that
      // hosts it. Unless the server we access returns a special header, letting
      // the browser know that it's ok to access its resources from somewhere
      // else. In our case we can't modify the acs.pub.ro server to return this
      // header, so we need to use a proxy. This proxy makes the request for us
      // and returns the needed header and the content. Utils.wrapUrlWithCORS
      // prepends the URL of the proxy to the wanted URL so that any request
      // will go through the proxy. This is needed only for the web version,
      // as CORS is a web browser thing.
      // See more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
      final url = Platform.isWeb ? Utils.corsProxyUrl : 'https://acs.pub.ro';
      final path = Platform.isWeb
          ? 'https://acs.pub.ro/topic/noutati'
          : '/topic/noutati';

      print('[news_provider] url: $url');
      final webScraper = WebScraper(url);
      print('[news_provider] webScraper = ${webScraper.baseUrl}');
      final bool scrapeSuccess = await webScraper.loadWebPage(path);
      print('[news_provider] scrapeSuccess: $scrapeSuccess');
      if (scrapeSuccess) {
        print('scrap successful');
        return _extractFromWebScraper(webScraper, limit);
      }
    } catch (e) {
      // Ignore "no internet" error
      print(
          '[news_provider] error: $e message: ${(e as WebScraperException).errorMessage()}');
      if (e.message && !e.message.contains('Failed host lookup')) {
        print(e);
      }
      AppToast.show(S.current.errorSomethingWentWrong);
    }

    return null;
  }

  static Iterable<NewsFeedItem> _extractFromWebScraper(
      WebScraper webScraper, int wantedLimit) {
    final List<Map<String, dynamic>> dates =
        webScraper.getElement('div.event > ul > li > div.time', []);
    print(dates);
    final List<Map<String, dynamic>> events =
        webScraper.getElement('div.event > ul > li > h3 > a', ['href']);
    print(events);

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
