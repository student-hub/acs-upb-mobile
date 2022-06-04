import 'package:flutter/material.dart';

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
          newsItemGuid: widget
              .redirectLink.queryParameters[NewsItemDetailsPage.uriQueryParam],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (final _) => _navigateAndDisplaySelection(context),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return widget.page;
  }
}
