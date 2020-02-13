import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppDrawer extends StatefulWidget {
  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(
            icon: Icons.home,
            text: S.of(context).drawerHeaderHome,
            onTap: () => Navigator.pushReplacementNamed(context, Routes.home),
          ),
          _createDrawerItem(
            icon: Icons.public,
            text: S.of(context).drawerItemWebsites,
          ),
          _createDrawerItem(
            icon: Icons.calendar_today,
            text: S.of(context).drawerItemTimetable,
          ),
          _createDrawerItem(
            icon: Icons.class_,
            text: S.of(context).drawerItemClasses,
          ),
          _createDrawerItem(
            icon: Icons.library_books,
            text: S.of(context).drawerItemNews,
          ),
          _createDrawerItem(
            icon: Icons.map,
            text: S.of(context).drawerItemMap,
          ),
          _createDrawerItem(
            icon: Icons.people,
            text: S.of(context).drawerItemPeople,
          ),
          _createDrawerItem(
            icon: Icons.note,
            text: S.of(context).drawerItemNotes,
          ),
          Divider(),
          _createDrawerItem(
              icon: Icons.settings,
              text: S.of(context).drawerItemSettings,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.settings),
              dense: true),
          _createDrawerItem(
            icon: Icons.help,
            text: S.of(context).drawerItemHelp,
            dense: true,
          ),
          _createDrawerItem(
            icon: Icons.code,
            text: S.of(context).drawerItemContribute,
            dense: true,
          ),
          _packageInfo.version == 'Unknown'
              ? Container(
                  width: 0,
                  height: 0,
                ) // If PackageInfo is not supported (i.e. on web), don't display
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Divider(),
                  Padding(
                      padding: EdgeInsets.only(left: 20, top: 5, bottom: 10),
                      child: Text(
                        _packageInfo.version,
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      ))
                ]),
        ],
      ),
    );
  }

  Widget _createHeader({IconData icon, String text, GestureTapCallback onTap}) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.centerRight,
                fit: BoxFit.fill,
                image:
                    AssetImage('assets/images/drawer_header_backgroud.jpg'))),
        child: Stack(children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
              onTap: onTap,
            ),
          ),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon,
      String text,
      GestureTapCallback onTap,
      bool dense = false}) {
    if (onTap == null && kReleaseMode) {
      return Container(width: 0, height: 0);
    }
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      dense: dense,
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}
