import 'dart:math';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/navigator.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/home/profile_card.dart';
import 'package:acs_upb_mobile/pages/search/view/search_dropdown.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/resources/banner.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/resources/web_layout_sizes.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebPageHeader extends StatefulWidget {
  const WebPageHeader({Key key, this.leading, this.height = 60})
      : super(key: key);

  final Widget leading;
  final double height;

  @override
  _WebPageHeaderState createState() => _WebPageHeaderState();
}

class _WebPageHeaderState extends State<WebPageHeader> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;

    return Container(
      color: Theme.of(context).accentColor.withAlpha(60),
      child: SizedBox(
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.leading ?? const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(6),
              child: InkWell(
                child: UniBanner(),
                onTap: () =>
                    AppNavigator.pushNamed(context, HomePage.routeName),
              ),
            ),
            if (screenSize > Sizes.narrowScreen)
              const Spacer(flex: 1)
            else
              const SizedBox.shrink(),
            const _SearchBar(),
            if (screenSize > Sizes.narrowScreen)
              const Spacer(flex: 1)
            else
              const SizedBox.shrink(),
            _ProfileDropdownMenu(
              headerHeight: widget.height,
            )
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({Key key}) : super(key: key);

  @override
  __SearchBarState createState() => __SearchBarState();
}

class __SearchBarState extends State<_SearchBar> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 3,
      child: FractionallySizedBox(
        heightFactor: 0.75,
        child: SearchDropdown(),
      ),
    );
  }
}

class _ProfileDropdownMenu extends StatefulWidget {
  const _ProfileDropdownMenu({Key key, this.headerHeight}) : super(key: key);

  final double headerHeight;

  @override
  __ProfileDropdownMenuState createState() => __ProfileDropdownMenuState();
}

class __ProfileDropdownMenuState extends State<_ProfileDropdownMenu> {
  final List<_PopupItem> _popupItems = [
    _PopupItem(
      onTap: (context) =>
          AppNavigator.pushNamed(context, SettingsPage.routeName),
      icon: Icons.settings,
      text: S.current.navigationSettings,
    ),
    _PopupItem(
      onTap: (context) =>
          AppNavigator.pushNamed(context, EditProfilePage.routeName),
      icon: Icons.person,
      text: S.current.actionEditProfile,
    ),
    _PopupItem(
      onTap: Utils.signOut,
      icon: Icons.logout,
      text: S.current.actionLogOut,
      anonymousIcon: Icons.login,
      anonymousText: S.current.actionLogIn,
    )
  ];

  String profilePictureURL;
  User user;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getProfilePictureURL().then((value) => setState(() {
          profilePictureURL = value;
        }));

    user = authProvider.currentUserFromCache;
  }

  @override
  Widget build(BuildContext context) {
    final size = min(widget.headerHeight, 60);
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
          child: CircleAvatar(
            radius: 25,
            backgroundImage: user != null && profilePictureURL != null
                ? NetworkImage(profilePictureURL)
                : const AssetImage(
                    'assets/illustrations/undraw_profile_pic.png',
                  ),
          ),
          onSelected: (value) => _popupItems[value].onTap(context),
          itemBuilder: (context) {
            return <PopupMenuEntry<void>>[
              const PopupMenuItem(
                enabled: false,
                child: ProfileCard(
                  isMenu: true,
                ),
              ),
              const PopupMenuDivider(),
              ..._popupItems.asMap().keys.toList()
                  .map((index) => _popupItems[index].build(context, index)),
            ];
          },
        ),
      ),
    );
  }
}

class _PopupItem {
  const _PopupItem({
    this.onTap,
    this.icon,
    this.text,
    this.anonymousText,
    this.anonymousIcon,
  });

  final void Function(BuildContext context) onTap;
  final IconData icon;
  final IconData anonymousIcon;
  final String text;
  final String anonymousText;

  Widget build(BuildContext context, int value) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return PopupMenuItem(
      value: value,
      child: IconText(
        icon: authProvider.isAnonymous && anonymousIcon != null
            ? anonymousIcon
            : icon,
        text: authProvider.isAnonymous && anonymousIcon != null
            ? anonymousText
            : text,
        onTap: () => onTap(context),
      ),
    );
  }
}
