import 'dart:math';
import 'package:web_scraper/web_scraper.dart';

class NewsFeedItem {
  NewsFeedItem(this.date, this.title, this.link) {}

  static const _textSelector = 'title';
  static const _attributesSelector = 'attributes';
  static const _hrefSelector = 'href';

  String date, title, link;

  static List<NewsFeedItem> extractFromWebScraper(WebScraper webScraper) {
    final List<Map<String, dynamic>> dates = webScraper.getElement(
        'div.event > ul > li > div.time', []);
    final List<Map<String, dynamic>> events = webScraper.getElement(
        'div.event > ul > li > h3 > a', ['href']);

    final List<NewsFeedItem> newsFeed = [];
    for (var i = 0; i < min(dates.length, events.length); ++i) {
      final date = dates[i][_textSelector];
      final title = events[i][_textSelector];
      final link = events[i][_attributesSelector][_hrefSelector];
      newsFeed.add(NewsFeedItem(date, title, link));
    }

    return newsFeed;
  }
}