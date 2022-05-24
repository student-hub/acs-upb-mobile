import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../navigation/routes.dart';
import '../../../widgets/scaffold.dart';
import '../../settings/view/source_page.dart';
import '../service/news_provider.dart';
import 'news_feed_page.dart';

class NewsNavigationBar extends StatefulWidget {
  const NewsNavigationBar({this.tabIndex = 0});

  static const String routeName = '/news_feed';
  final int tabIndex;

  @override
  _NewsNavigationBarState createState() => _NewsNavigationBarState();
}

class _NewsNavigationBarState extends State<NewsNavigationBar>
    with TickerProviderStateMixin {
  int currentTab = 0;
  List<Widget> tabs;
  TabController tabController;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentTab = tabController.index;
        });
      }
    });

    final NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);

    tabs = [
      NewsFeedPage(
          fetchNewsFuture: newsProvider.fetchNewsFeedItems,
          key: const PageStorageKey('NewsFeed')),
      NewsFeedPage(
          fetchNewsFuture: newsProvider.fetchFavoriteNewsFeedItems,
          key: const PageStorageKey('NewsFeedFavorite')),
      NewsFeedPage(
          fetchNewsFuture: newsProvider.fetchPersonalNewsFeedItem,
          key: const PageStorageKey('NewsFeedPersonal')),
    ];

    // Show "Select sources" page if user has no preference set
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAnonymous) {
      authProvider.currentUser.then((final user) {
        if (user?.sources?.isEmpty ?? true) {
          Navigator.of(context).push(MaterialPageRoute<SourcePage>(
              builder: (final context) => SourcePage()));
        }
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: widget.tabIndex,
      child: AppScaffold(
        title: const Text('News feed'),
        body: PageStorage(
          child: TabBarView(controller: tabController, children: tabs),
          bucket: bucket,
        ),
        appBarBottom: newsNavigationBar(context),
        actions: [
          AppScaffoldAction(
            icon: Icons.add,
            tooltip: S.current.navigationSettings,
            route: Routes.settings,
          )
        ],
      ),
    );
  }

  Widget newsNavigationBar(final BuildContext context) => TabBar(
        controller: tabController,
        tabs: [
          const Tab(text: 'News'),
          const Tab(text: 'Favorites'),
          const Tab(text: 'Personal'),
        ],
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
        indicatorColor: Colors.white,
      );
}
