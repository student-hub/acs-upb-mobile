import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication/service/auth_provider.dart';
import '../../generated/l10n.dart';
import '../../navigation/routes.dart';
import '../../resources/remote_config.dart';
import '../../widgets/scaffold.dart';
import '../classes/view/classes_page.dart';
import '../search/view/search_page.dart';
import 'faq_card.dart';
import 'favourite_websites_card.dart';
import 'feedback_nudge.dart';
import 'news_feed_card.dart';
import 'profile_card.dart';
import 'upcoming_events_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.tabController, Key key}) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: Text(S.current.navigationHome),
      actions: [
        AppScaffoldAction(
          icon: Icons.search,
          tooltip: S.current.navigationSearch,
          onPressed: () => {
            Navigator.of(context).push(MaterialPageRoute<ClassesPage>(
              builder: (_) => SearchPage(),
            ))
          },
        ),
        AppScaffoldAction(
          icon: Icons.settings_outlined,
          tooltip: S.current.navigationSettings,
          route: Routes.settings,
        )
      ],
      body: ListView(
        children: [
          if (authProvider.isAuthenticated) ProfileCard(),
          if (authProvider.isAuthenticated &&
              !authProvider.isAnonymous &&
              RemoteConfigService.feedbackEnabled)
            FeedbackNudge(),
          if (authProvider.isAuthenticated && !authProvider.isAnonymous)
            UpcomingEventsCard(onShowMore: () => tabController?.animateTo(1)),
          if (authProvider.isAuthenticated && !authProvider.isAnonymous)
            FavouriteWebsitesCard(
                onShowMore: () => tabController?.animateTo(2)),
          NewsFeedCard(),
          FaqCard(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
