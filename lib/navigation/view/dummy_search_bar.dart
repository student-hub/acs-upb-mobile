import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/app_navigator.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/home/profile_card.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/resources/banner.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:flutter/material.dart';

class DummySearchBar extends StatefulWidget {
  const DummySearchBar({Key key, this.leading}) : super(key: key);

  final Widget leading;

  @override
  _DummySearchBarState createState() => _DummySearchBarState();
}

class _DummySearchBarState extends State<DummySearchBar> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor.withAlpha(60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.leading ?? const SizedBox.shrink(),
          InkWell(
            child: UniBanner(),
            onTap: () => AppNavigator.pushNamed(context, HomePage.routeName),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 200,
                    top: 15,
                    bottom: 15,
                    right: 15,
                  ),
                  child: Text('THIS IS A SEARCHBAR'),
                ),
              ),
            ),
            flex: 3,
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: PopupMenuButton(
                color: Theme.of(context).backgroundColor,
                offset: const Offset(-5, 45),
                tooltip: S.current.navigationProfile,
                child: const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    'assets/illustrations/undraw_profile_pic.png',
                  ),
                ),
                itemBuilder: (context) {
                  return <PopupMenuEntry<void>>[
                    const PopupMenuItem(
                      enabled: false,
                      child: ProfileCard(
                        isMenu: true,
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      child: IconText(
                        icon: Icons.settings,
                        text: S.current.navigationSettings,
                        onTap: () {
                          AppNavigator.pushNamed(
                              context, SettingsPage.routeName);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: IconText(
                        icon: Icons.logout,
                        text: S.current.actionLogOut,
                        onTap: () {
                          Utils.signOut(context);
                        },
                      ),
                    )
                  ];
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
