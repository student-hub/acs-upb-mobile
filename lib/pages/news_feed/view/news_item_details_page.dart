import 'package:flutter/material.dart';

import 'news_feed_page.dart';

class NewsItemDetailsPage extends StatefulWidget {
  static const String routeName = '/news-item-details';

  @override
  _NewsItemDetailsState createState() => _NewsItemDetailsState();
}

class _NewsItemDetailsState extends State<NewsItemDetailsPage> {
  String extractUrl() {
    final NewsItemDetailsRouteArguments args =  ModalRoute.of(context).settings.arguments;
    return args.itemId;
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalii'),
      ),
      body: Center(
        child: Text(extractUrl()),
      ),
    );
  }
}
