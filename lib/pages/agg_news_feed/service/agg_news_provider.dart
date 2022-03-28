import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web_scraper/web_scraper.dart';

import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/toast.dart';
import '../model/agg_news_feed_item.dart';

class AggNewsProvider with ChangeNotifier {
  static const _textSelector = 'title';
  static const _attributesSelector = 'attributes';
  static const _hrefSelector = 'href';

  Future<List<AggNewsFeedItem>> fetchNewsFeedItems({int limit}) async {
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
      final url = kIsWeb ? Utils.corsProxyUrl : 'https://acs.pub.ro';
      final path =
          kIsWeb ? '/https://acs.pub.ro/topic/noutati' : '/topic/noutati';
      final webScraper = WebScraper(url);
      final bool scrapeSuccess = await webScraper.loadWebPage(path);

      if (scrapeSuccess) {
        return _extractFromWebScraper(webScraper, limit);
      }
    } catch (e) {
      // Ignore "no internet" error
      if (!e.message.contains('Failed host lookup')) {
        print(e);
        AppToast.show(S.current.errorSomethingWentWrong);
      }
    }

    return null;
  }

  static Iterable<AggNewsFeedItem> _extractFromWebScraper(
      WebScraper webScraper, int wantedLimit) {
    final List<Map<String, dynamic>> dates =
        webScraper.getElement('div.event > ul > li > div.time', []);
    final List<Map<String, dynamic>> events =
        webScraper.getElement('div.event > ul > li > h3 > a', ['href']);

    final List<AggNewsFeedItem> newsFeed = [];
    var limit = min(dates.length, events.length);
    if (wantedLimit != null) {
      limit = min(limit, wantedLimit);
    }

    for (var i = 0; i < limit; ++i) {
      final date = dates[i][_textSelector];
      final title = events[i][_textSelector];
      final link = events[i][_attributesSelector][_hrefSelector];
      newsFeed.add(AggNewsFeedItem(date, title, link));
    }

    return newsFeed;
  }
}
