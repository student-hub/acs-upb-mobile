import 'dart:math';

import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/navigator.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/home/profile_card.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/resources/banner.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebpageHeader extends StatefulWidget {
  const WebpageHeader({Key key, this.leading, this.height = 60})
      : super(key: key);

  final Widget leading;
  final double height;

  @override
  _WebpageHeaderState createState() => _WebpageHeaderState();
}

class _WebpageHeaderState extends State<WebpageHeader> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor.withAlpha(60),
      child: SizedBox(
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.leading ?? const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: InkWell(
                child: UniBanner(),
                onTap: () =>
                    AppNavigator.pushNamed(context, HomePage.routeName),
              ),
            ),
            const Spacer(),
            const _DummySearchBar(),
            _ProfileDropdownMenu(
              headerHeight: widget.height,
            )
          ],
        ),
      ),
    );
  }
}

class _DummySearchBar extends StatelessWidget {
  const _DummySearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 60),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Card(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'THIS IS A SEARCHBAR',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileDropdownMenu extends StatelessWidget {
  const _ProfileDropdownMenu({Key key, this.headerHeight}) : super(key: key);

  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = min(headerHeight, 60);
    final padding = size / 8;

    return SizedBox(
      width: size,
      height: size,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: PopupMenuButton(
          color: Theme.of(context).backgroundColor,
          offset: Offset(-5, size),
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
                    AppNavigator.pushNamed(context, SettingsPage.routeName);
                  },
                ),
              ),
              PopupMenuItem(
                child: authProvider.isAnonymous
                    ? IconText(
                        icon: Icons.login,
                        text: S.current.actionLogIn,
                        onTap: () {
                          Utils.signOut(context);
                        },
                      )
                    : IconText(
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
    );
  }
}
