import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication/model/user.dart';
import '../../authentication/service/auth_provider.dart';
import '../../authentication/view/edit_profile_page.dart';
import '../../generated/l10n.dart';
import '../../resources/theme.dart';
import '../../resources/utils.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String profilePictureURL;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getProfilePictureURL().then((final value) => setState(() {
          profilePictureURL = value;
        }));
  }

  @override
  Widget build(final BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    String userName;
    final User user = authProvider.currentUserFromCache;
    String userGroup;
    if (user != null) {
      userName = '${user.firstName} ${user.lastName}';
      userGroup = user.classes?.isNotEmpty ?? false ? user.classes.last : null;
    }

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            user != null && profilePictureURL != null
                                ? NetworkImage(profilePictureURL)
                                : const AssetImage(
                                    'assets/illustrations/undraw_profile_pic.png',
                                  )),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              userName ?? S.current.stringAnonymous,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .apply(fontWeightDelta: 2, fontSizeDelta: 2),
                            ),
                          ),
                          if (userGroup != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(userGroup,
                                  style: Theme.of(context).textTheme.subtitle1),
                            ),
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
                                      .coloredTextTheme
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
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<EditProfilePage>(
                                  builder: (final context) =>
                                      const EditProfilePage(),
                                ),
                              );
                              if (!mounted) return;
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              final value =
                                  await authProvider.getProfilePictureURL();
                              setState(() {
                                profilePictureURL = value;
                              });
                            }),
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
