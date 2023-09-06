import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../service/post_provider.dart';
import 'user_info_page.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({@required this.likes, final Key key}) : super(key: key);
  final List<String> likes;

  static const String routeName = '/likes';

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  Future<List<User>> users;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return AppScaffold(
      title: const Text('Likes'),
      body: FutureBuilder(
        future: Provider.of<PostProvider>(context, listen: false)
            .getUsersByLikes(widget.likes),
        builder: (final BuildContext context,
            final AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<User> users = snapshot.data;

          if (users == null) {
            return ErrorPage(
              errorMessage: 'Unable to see the likes',
              info: [TextSpan(text: S.current.warningInternetConnection)],
              actionText: S.current.actionRefresh,
              actionOnTap: () => setState(() {}),
            );
          } else if (users.isEmpty) {
            return const ErrorPage(
              imgPath: 'assets/illustrations/undraw_empty.png',
              errorMessage: 'No likes yet :(',
            );
          }

          return ListView.builder(
            itemCount: users != null ? users.length : 0,
            itemBuilder: (final BuildContext context, final int index) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<Map<dynamic, dynamic>>(
                      builder: (final context) => UserInfoPage(
                        userId: users[index].uid,
                      ),
                    ),
                  ),
                  child: Row(children: [
                    FutureBuilder(
                        future: Provider.of<PostProvider>(context)
                            .getProfilePictureURL(users[index].uid),
                        builder: (final context, final snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                                child: CircleAvatar(
                              backgroundImage: NetworkImage(placeholderImage),
                            ));
                          }

                          final String photoUrl = snapshot.data;
                          return CircleAvatar(
                            backgroundImage: photoUrl != null
                                ? NetworkImage(photoUrl)
                                : const NetworkImage(placeholderImage),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        users[index].displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
