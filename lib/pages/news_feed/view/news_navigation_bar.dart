import 'package:flutter/material.dart';
import 'package:googleapis/servicecontrol/v2.dart';
import 'package:oktoast/oktoast.dart';
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

    final NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final tabsCount = !authProvider.isAnonymous &&
            authProvider.currentUserFromCache.canAddPublicInfo
        ? 3
        : 2;

    tabController = TabController(vsync: this, length: tabsCount);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentTab = tabController.index;
        });
      }
    });

    tabs = !authProvider.isAnonymous &&
            authProvider.currentUserFromCache.canAddPublicInfo
        ? getFullTabs(newsProvider)
        : getLimitedTabs(newsProvider);

    // Show "Select sources" page if user has no preference set
    if (!authProvider.isAnonymous) {
      authProvider.currentUser.then((final user) {
        if (user?.sources?.isEmpty ?? true) {
          Navigator.of(context).push(MaterialPageRoute<SourcePage>(
              builder: (final context) => SourcePage()));
        }
      });
    }
  }

  List<Widget> getFullTabs(final NewsProvider newsProvider) {
    return [
      NewsFeedPage(
        fetchNewsFuture: newsProvider.fetchNewsFeedItems,
        key: const PageStorageKey('NewsFeed'),
      ),
      NewsFeedPage(
        fetchNewsFuture: newsProvider.fetchFavoriteNewsFeedItems,
        key: const PageStorageKey('NewsFeedFavorite'),
      ),
      NewsFeedPage(
        fetchNewsFuture: newsProvider.fetchPersonalNewsFeedItem,
        key: const PageStorageKey('NewsFeedPublished'),
      ),
    ];
  }

  List<Widget> getFullTabsNames() {
    return [
      const Tab(text: 'News'),
      const Tab(text: 'Favorites'),
      const Tab(text: 'Authored'),
    ];
  }

  List<Widget> getLimitedTabs(final NewsProvider newsProvider) {
    return [
      NewsFeedPage(
        fetchNewsFuture: newsProvider.fetchNewsFeedItems,
        key: const PageStorageKey('NewsFeed'),
      ),
      NewsFeedPage(
        fetchNewsFuture: newsProvider.fetchFavoriteNewsFeedItems,
        key: const PageStorageKey('NewsFeedFavorite'),
      ),
    ];
  }

  List<Widget> getLimitedTabsNames() {
    return [
      const Tab(text: 'News'),
      const Tab(text: 'Favorites'),
    ];
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    return !authProvider.isAnonymous && authProvider.isAuthenticated
        ? newsTabController(authProvider, context)
        : anonymousNewsFeedPage();
  }

  Widget anonymousNewsFeedPage() {
    return AppScaffold(
      title: const Text('News feed'),
      body: tabs[0],
    );
  }

  Widget newsTabController(
      final AuthProvider authProvider, final BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: widget.tabIndex,
      child: AppScaffold(
        title: const Text('News feed'),
        body: PageStorage(
          child: TabBarView(controller: tabController, children: tabs),
          bucket: bucket,
        ),
        appBarBottom: newsNavigationBar(authProvider, context),
        actions: [
          authProvider.currentUserFromCache.canAddPublicInfo
              ? AppScaffoldAction(
                  icon: Icons.add,
                  tooltip: S.current.navigationSettings,
                  route: Routes.newsCreate,
                )
              : AppScaffoldAction(
                  icon: Icons.add,
                  tooltip: S.current.navigationSettings,
                  onPressed: () => showToast(
                    'You need to have editing permissions to publish. Navigate to Settings and apply for these permissions!',
                    duration: const Duration(seconds: 4),
                  ),
                ),
        ],
      ),
    );
  }

  Widget newsNavigationBar(
      final AuthProvider authProvider, final BuildContext context) {
    final tabsNames = !authProvider.isAnonymous &&
            authProvider.currentUserFromCache.canAddPublicInfo
        ? getFullTabsNames()
        : getLimitedTabsNames();

    return TabBar(
      controller: tabController,
      tabs: tabsNames,
      labelColor: Colors.white,
      unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
      indicatorColor: Colors.white,
    );
  }
}
