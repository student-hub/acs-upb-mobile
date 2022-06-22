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
  int currentEditorTab = 0;
  int currentUserTab = 0;
  //List<Widget> tabs;
  TabController userTabController;
  TabController editorTabController;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();

    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    userTabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        if (!userTabController.indexIsChanging) {
          setState(() {
            currentUserTab = userTabController.index;
          });
        }
      });
    editorTabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        if (!editorTabController.indexIsChanging) {
          setState(() {
            currentEditorTab = editorTabController.index;
          });
        }
      });

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

  List<Widget> getEditorTabs(final NewsProvider newsProvider) {
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

  List<Widget> getEditorTabsNames() {
    return [
      const Tab(text: 'News'),
      const Tab(text: 'Favorites'),
      const Tab(text: 'Authored'),
    ];
  }

  List<Widget> getUserTabs(final NewsProvider newsProvider) {
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

  List<Widget> getUserTabsNames() {
    return [
      const Tab(text: 'News'),
      const Tab(text: 'Favorites'),
    ];
  }

  Widget getAnonymousTab(final NewsProvider newsProvider) => NewsFeedPage(
        fetchNewsFuture: newsProvider.fetchNewsFeedItems,
        key: const PageStorageKey('NewsFeed'),
      );

  @override
  void dispose() {
    userTabController.dispose();
    editorTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isUser = !authProvider.isAnonymous && authProvider.isAuthenticated;
    if (isUser) {
      final isEditor = authProvider.currentUserFromCache?.canEditPublicInfo;
      return isEditor
          ? newsTabControllerEditor(authProvider, context)
          : newsTabControllerUser(authProvider, context);
    } else {
      return anonymousNewsFeedPage(context);
    }
  }

  Widget anonymousNewsFeedPage(final BuildContext context) {
    final NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);
    return AppScaffold(
      title: const Text('News feed'),
      body: getAnonymousTab(newsProvider),
    );
  }

  Widget newsTabControllerEditor(
      final AuthProvider authProvider, final BuildContext context) {
    final NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);
    return DefaultTabController(
      length: 3,
      initialIndex: widget.tabIndex,
      child: AppScaffold(
        title: const Text('News feed'),
        body: PageStorage(
          child: TabBarView(
            controller: editorTabController,
            children: getEditorTabs(newsProvider),
          ),
          bucket: bucket,
        ),
        appBarBottom: newsNavigationBarEditor(authProvider, context),
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

  Widget newsTabControllerUser(
      final AuthProvider authProvider, final BuildContext context) {
    final NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);
    return DefaultTabController(
      length: 2,
      initialIndex: widget.tabIndex,
      child: AppScaffold(
        title: const Text('News feed'),
        body: PageStorage(
          child: TabBarView(
            controller: userTabController,
            children: getUserTabs(newsProvider),
          ),
          bucket: bucket,
        ),
        appBarBottom: newsNavigationBarUser(authProvider, context),
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

  Widget newsNavigationBarEditor(
      final AuthProvider authProvider, final BuildContext context) {
    return TabBar(
      controller: editorTabController,
      tabs: getEditorTabsNames(),
      labelColor: Colors.white,
      unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
      indicatorColor: Colors.white,
    );
  }

  Widget newsNavigationBarUser(
      final AuthProvider authProvider, final BuildContext context) {
    return TabBar(
      controller: userTabController,
      tabs: getUserTabsNames(),
      labelColor: Colors.white,
      unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
      indicatorColor: Colors.white,
    );
  }
}
