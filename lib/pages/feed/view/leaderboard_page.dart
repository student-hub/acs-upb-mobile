import 'package:acs_upb_mobile/pages/feed/view/user_info_page.dart';
import 'package:acs_upb_mobile/pages/feed/view/widgets/post_header.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../service/post_provider.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({final Key key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return AppScaffold(
      title: const Text('Leaderboard'),
      appBarBottom: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        indicatorColor: Colors.white,
        unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
        tabs: [
          const Tab(text: 'Points'),
          const Tab(text: 'Posts'),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Widget for contributions tab
                _points(),
                // Widget for points tab
                _posts(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _posts() {
    final PostProvider _postProvider = Provider.of(context, listen: false);
    return FutureBuilder(
      future: _postProvider.getPostsLeaderboard(),
      builder: (final context, final snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Pair<User, int>> userPosts = snapshot.data;
        print(userPosts);

        if (userPosts == null || userPosts.isEmpty) {
          return ErrorPage(
            errorMessage: 'Something went wrong fetching the leaderboard',
            info: [TextSpan(text: S.current.warningInternetConnection)],
            actionText: S.current.actionRefresh,
            actionOnTap: () => setState(() {}),
          );
        }

        return ListView.builder(
          itemCount: userPosts.length > 20 ? 20 : userPosts.length,
          itemBuilder: (final context, final index) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, top: 4, right: 16),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    width: 35,
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${index + 1}.',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: _postProvider
                        .getProfilePictureURL(userPosts[index].first.uid),
                    builder: (final context, final snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(placeholderImage),
                          ),
                        );
                      }

                      final String photoUrl = snapshot.data;
                      return CircleAvatar(
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : const NetworkImage(placeholderImage),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userPosts[index].first.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${userPosts[index].second} posts',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getRank(final int rankProgressionPoints) {
    String rank;
    if (rankProgressionPoints < 100) {
      rank = 'Freshman';
    } else if (rankProgressionPoints < 300) {
      rank = 'Junior';
    } else if (rankProgressionPoints < 500) {
      rank = 'Senior';
    } else {
      rank = 'Master';
    }

    return '$rank';
  }

  Widget _points() {
    final PostProvider _postProvider = Provider.of(context, listen: false);
    return FutureBuilder(
      future: _postProvider.getPointsLeaderboard(),
      builder: (final context, final snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<User> users = snapshot.data;

        if (users == null || users.isEmpty) {
          return ErrorPage(
            errorMessage: 'Something went wrong fetching the leaderboard',
            info: [TextSpan(text: S.current.warningInternetConnection)],
            actionText: S.current.actionRefresh,
            actionOnTap: () => setState(() {}),
          );
        }

        return ListView.builder(
          itemCount: users.length > 20 ? 20 : users.length,
          itemBuilder: (final context, final index) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, top: 4, right: 16),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    width: 35,
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${index + 1}.',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future:
                        _postProvider.getProfilePictureURL(users[index].uid),
                    builder: (final context, final snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(placeholderImage),
                          ),
                        );
                      }

                      final String photoUrl = snapshot.data;
                      return CircleAvatar(
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : const NetworkImage(placeholderImage),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          users[index].displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${users[index].rankProgressionPoints}p',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(_getRank(users[index].rankProgressionPoints))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
