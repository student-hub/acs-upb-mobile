import 'package:acs_upb_mobile/pages/feed/view/class_page.dart';
import 'package:flutter/material.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../authentication/service/auth_provider.dart';
import '../../../widgets/scaffold.dart';
import '../model/rank.dart';
import '../service/post_provider.dart';

const placeholderImage =
    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({@required this.userId, final Key key}) : super(key: key);
  final String userId;

  static const String routeName = '/userInfo';

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  static List<String> badges = [
    '1st Like',
    '1st Post',
    '1st Comment',
    '50 Likes',
    '10 Likes to a Post',
    '1st Comment to a Post',
  ];

  @override
  void initState() {
    super.initState();
  }

  ListView _classesBuilder(final List<String> classes) {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (final BuildContext context, final int index) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<Map<dynamic, dynamic>>(
              builder: (final context) => ClassPage(
                className: classes[index],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 4),
            child: Row(
              children: [
                CircleAvatar(
                  child: FittedBox(
                    child: Text(classes[index].split('-')[3]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    classes[index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);
    return FutureBuilder(
      future: postProvider.fetchUserInfo(widget.userId),
      builder:
          (final BuildContext context, final AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final User user = snapshot.data;

        return AppScaffold(
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
              children: [
                FutureBuilder(
                  future: authProvider.getProfilePictureURL(),
                  builder: (final BuildContext context,
                      final AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                          child: CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: NetworkImage(placeholderImage),
                      ));
                    }

                    final String pictureUrl = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            maxRadius: 50,
                            backgroundImage: pictureUrl != null
                                ? NetworkImage(user.picturePath)
                                : const NetworkImage(placeholderImage),
                          ),
                          Text(
                            user.displayName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  },
                ),
                const PrefTitle(
                  title: Text('Rank'),
                  padding: EdgeInsets.only(left: 0, bottom: 0, top: 20),
                ),
                FutureBuilder(
                  future:
                      postProvider.fetchUserRank(user.rankProgressionPoints),
                  builder: (final BuildContext context,
                      final AsyncSnapshot<Rank> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final Rank rank = snapshot.data;

                    return Flexible(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: Stack(
                          children: [
                            LinearProgressIndicator(
                              minHeight: 40,
                              value: (user.rankProgressionPoints.toDouble() -
                                      rank.pointsStart) /
                                  (rank.pointsEnd - rank.pointsStart),
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor),
                              backgroundColor: Colors.white,
                            ),
                            Center(
                              child: Text(
                                  '${user.rankProgressionPoints} / ${rank.pointsEnd} (${rank.name})'),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const PrefTitle(
                  title: Text('Badges'),
                  padding: EdgeInsets.only(left: 0, bottom: 0, top: 20),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: badges.length,
                  itemBuilder: (final BuildContext ctx, final index) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: index > 2
                              ? Theme.of(context).primaryColor.withOpacity(0.2)
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                          child: Text(
                        badges[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                    );
                  },
                ),
                const PrefTitle(
                  title: Text('Classes'),
                  padding: EdgeInsets.only(left: 0, bottom: 0, top: 20),
                ),
                FutureBuilder(
                  future: Provider.of<PostProvider>(context)
                      .fetchUserClassIds(user.uid),
                  builder: (final context, final snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List<String> classes = snapshot.data;
                    return SizedBox(
                        height: 300, child: _classesBuilder(classes));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
