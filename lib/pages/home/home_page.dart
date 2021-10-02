import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/model/routes.dart';
import 'package:acs_upb_mobile/navigation/service/navigation_provider.dart';
import 'package:acs_upb_mobile/navigation/service/navigator.dart';
import 'package:acs_upb_mobile/navigation/view/scaffold.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/home/faq_card.dart';
import 'package:acs_upb_mobile/pages/home/favourite_websites_card.dart';
import 'package:acs_upb_mobile/pages/home/feedback_nudge.dart';
import 'package:acs_upb_mobile/pages/home/news_feed_card.dart';
import 'package:acs_upb_mobile/pages/home/profile_card.dart';
import 'package:acs_upb_mobile/pages/home/upcoming_events_card.dart';
import 'package:acs_upb_mobile/pages/search/view/search_page.dart';
import 'package:acs_upb_mobile/resources/remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.tabController, Key key}) : super(key: key);

  static const String routeName = '/home';

  final TabController tabController;

  void _selectTab(BuildContext context, int index) {
    kIsWeb
        ? Provider.of<NavigationProvider>(context, listen: false).selectedTab =
            index
        : tabController?.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: Text(S.current.navigationHome),
      actions: [
        if (!kIsWeb)
          AppScaffoldAction(
            icon: Icons.search,
            tooltip: S.current.navigationSearch,
            onPressed: () => {
              AppNavigator.push(
                context,
                MaterialPageRoute<ClassesPage>(
                  builder: (_) => SearchPage(),
                ),
                webPath: SearchPage.routeName,
              )
            },
          )
        else
          null,
        AppScaffoldAction(
          icon: Icons.settings_outlined,
          tooltip: S.current.navigationSettings,
          route: Routes.settings,
        )
      ],
      body: ListView(
        children: [
          if (authProvider.isAuthenticated && !kIsWeb) const ProfileCard(),
          if (authProvider.isAuthenticated &&
              !authProvider.isAnonymous &&
              RemoteConfigService.feedbackEnabled)
            FeedbackNudge(),
          if (authProvider.isAuthenticated && !authProvider.isAnonymous)
            UpcomingEventsCard(onShowMore: () => _selectTab(context, 1)),
          if (authProvider.isAuthenticated && !authProvider.isAnonymous)
            FavouriteWebsitesCard(onShowMore: () => _selectTab(context, 2)),
          NewsFeedCard(),
          FaqCard(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
