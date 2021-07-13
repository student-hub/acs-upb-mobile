import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/model/app_state.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({Key key, this.isMenu = false}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();

  final bool isMenu;
}

class _ProfileCardState extends State<ProfileCard> {
  String profilePictureURL;
  String userName;
  String userGroup;
  User user;
  AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getProfilePictureURL().then((value) => setState(() {
          profilePictureURL = value;
        }));

    user = authProvider.currentUserFromCache;
    if (user != null) {
      userName = '${user.firstName} ${user.lastName}';
      userGroup = user.classes?.isNotEmpty ?? false ? user.classes.last : null;
    }
  }

  Future<void> _loadEditMenu() async {
    Provider.of<AppStateProvider>(context, listen: false).editProfile = true;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final value = await authProvider.getProfilePictureURL();
    setState(() {
      profilePictureURL = value;
    });
  }

  Widget get userNameWidget {
    return FittedBox(
      child: Text(
        userName ?? S.current.stringAnonymous,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .apply(fontWeightDelta: 2, fontSizeDelta: 2),
      ),
    );
  }

  Widget get profilePictureWidget {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CircleAvatar(
          radius: 40,
          backgroundImage: user != null && profilePictureURL != null
              ? NetworkImage(profilePictureURL)
              : const AssetImage(
                  'assets/illustrations/undraw_profile_pic.png',
                )),
    );
  }

  Widget get userGroupWidget {
    if (userGroup != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(userGroup, style: Theme.of(context).textTheme.subtitle1),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMenu) {
      return menu;
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    profilePictureWidget,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            userNameWidget,
                            userGroupWidget,
                            InkWell(
                              onTap: () {
                                Utils.signOut(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                    authProvider.isAnonymous
                                        ? S.current.actionLogIn
                                        : S.current.actionLogOut,
                                    style: Theme.of(context)
                                        .accentTextTheme
                                        .subtitle2
                                        .copyWith(fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (user != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: Theme.of(context).textTheme.button.color,
                            onPressed: _loadEditMenu,
                          ),
                        ],
                      ),
                  ],
                ),
                AccountNotVerifiedWarning(),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget get menu {
    return FittedBox(
      child: Row(
        children: [
          profilePictureWidget,
          Column(
            children: [
              userNameWidget,
              userGroupWidget,
            ],
          )
        ],
      ),
    );
  }
}
