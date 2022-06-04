import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/news_feed/view/news_item_details_page.dart';

class RedirectDynamicLink extends StatefulWidget {
  const RedirectDynamicLink({this.redirectLink, this.page, final Key key})
      : super(key: key);

  final Uri redirectLink;
  final Widget page;

  @override
  _RedirectDynamicLinkState createState() => _RedirectDynamicLinkState();
}

class _RedirectDynamicLinkState extends State<RedirectDynamicLink> {
  Future<void> _navigateAndDisplaySelection(final BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<Map<dynamic, dynamic>>(
        builder: (final context) => NewsItemDetailsPage(
            newsItemGuid: widget.redirectLink.queryParameters['guid']),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('RedirectDynamicLink initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (true) {
        // condition here
        print('Redirecting to ${widget.redirectLink}');
        _navigateAndDisplaySelection(context);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    print('RedirectDynamicLink build');
    return widget.page;
  }
}
