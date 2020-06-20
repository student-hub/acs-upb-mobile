import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/view/person_view.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

extension ClassExtension on Class {
  Color get colorFromAcronym {
    int r = 0, g = 0, b = 0;
    if (acronym.length >= 1) {
      b = acronym[0].codeUnitAt(0);
      if (acronym.length >= 2) {
        g = acronym[1].codeUnitAt(0);
        if (acronym.length >= 3) {
          r = acronym[2].codeUnitAt(0);
        }
      }
    }
    int brightnessFactor = 2;
    return Color.fromRGBO(
        r * brightnessFactor, g * brightnessFactor, b * brightnessFactor, 1);
  }
}

class ClassView extends StatelessWidget {
  final Class classInfo;

  const ClassView({Key key, this.classInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: classInfo.completeName,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            headerCard(context),
            SizedBox(height: 8),
            shortcuts(context),
            SizedBox(height: 8),
            events(context),
          ],
        ),
      ),
    );
  }

  Widget shortcuts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).sectionShortcuts,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Icon(Icons.add),
                ],
              ),
              Divider()
            ] +
            classInfo.shortcuts.map((s) => shortcut(s, context)).toList(),
      ),
    );
  }

  IconData shortcutIcon(ShortcutType type) {
    switch (type) {
      case ShortcutType.main:
        return Icons.home;
      case ShortcutType.classbook:
        return CustomIcons.book;
      case ShortcutType.resource:
        return Icons.insert_drive_file;
      case ShortcutType.other:
        return Icons.public;
    }
  }

  _launchURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppToast.show(S.of(context).errorCouldNotLaunchURL(url));
    }
  }

  Widget shortcut(Shortcut shortcut, BuildContext context) {
    return ListTile(
      onTap: () => _launchURL(shortcut.link, context),
      leading: CircleAvatar(
        child: Icon(shortcutIcon(shortcut.type)),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).iconTheme.color,
      ),
      title: Text(shortcut.name ?? shortcut.type.toLocalizedString(context)),
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget events(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).sectionEvents,
                style: Theme.of(context).textTheme.headline6,
              ),
              Icon(Icons.add),
            ],
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.2),
              child:
                  Icon(Icons.laptop, color: Theme.of(context).iconTheme.color),
            ),
            title: Text('Tema 1'),
            subtitle: Text('5 Oct 2020 | 23:55'),
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.2),
              child:
              Icon(Icons.spellcheck, color: Theme.of(context).iconTheme.color),
            ),
            title: Text('Test'),
            subtitle: Text('1 Nov 2020 | 16:00'),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget headerCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: classInfo.colorFromAcronym,
              child: AutoSizeText(
                classInfo.acronym,
                minFontSize: 5,
                maxLines: 1,
                style: TextStyle(
                  color: classInfo.colorFromAcronym.highEmphasisOnColor,
                ),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                      context: context,
                      builder: (context) => FractionallySizedBox(
                        heightFactor: 0.25,
                        child: PersonView(
                              person: classInfo.lecturer,
                            ),
                      )),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 4),
                      Text(classInfo.lecturer?.name ?? ''),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 4),
                    Text(classInfo.shortName + ' team'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
