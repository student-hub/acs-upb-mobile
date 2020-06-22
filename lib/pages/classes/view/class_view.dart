import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/person_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/shortcut_view.dart';
import 'package:acs_upb_mobile/pages/timetable/view/event_view.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

extension ClassExtension on Class {
  Color get colorFromAcronym {
    int r = 0,
        g = 0,
        b = 0;
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

class ClassView extends StatefulWidget {
  final Class classInfo;

  const ClassView({Key key, this.classInfo}) : super(key: key);

  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.classInfo.completeName,
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
    var classProvider = Provider.of<ClassProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S
                    .of(context)
                    .sectionShortcuts,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider.value(
                            value: classProvider,
                            child: ShortcutView(
                                onSave: (shortcut) {
                                  setState(() =>
                                  widget.classInfo.shortcuts.add(shortcut));
                                  classProvider.addShortcut(
                                      classId: widget.classInfo.id,
                                      shortcut: shortcut,
                                      context: context);
                                }
                            ),
                          ),
                    )),
              ),
            ],
          ),
          Divider()
        ] +
            widget.classInfo.shortcuts.map((s) => shortcut(s, context)).toList(),
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
        foregroundColor: Theme
            .of(context)
            .iconTheme
            .color,
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
                S
                    .of(context)
                    .sectionEvents,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EventView(
                            addNew: true,
                          ),
                    )),
              ),
            ],
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.2),
              child:
              Icon(Icons.laptop, color: Theme
                  .of(context)
                  .iconTheme
                  .color),
            ),
            title: Text('Tema 1'),
            subtitle: Text('5 Oct 2020 | 23:55'),
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.2),
              child: Icon(Icons.spellcheck,
                  color: Theme
                      .of(context)
                      .iconTheme
                      .color),
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
              backgroundColor: widget.classInfo.colorFromAcronym,
              child: AutoSizeText(
                widget.classInfo.acronym,
                minFontSize: 5,
                maxLines: 1,
                style: TextStyle(
                  color: widget.classInfo.colorFromAcronym.highEmphasisOnColor,
                ),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () =>
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          // TODO: Fix size for landscape
                          builder: (context) =>
                              FractionallySizedBox(
                                heightFactor: 0.25,
                                child: PersonView(
                                  person: widget.classInfo.lecturer,
                                ),
                              )),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 4),
                      Text(widget.classInfo.lecturer?.name ?? ''),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 4),
                    Text(S.of(context).labelTeam(widget.classInfo.shortName)),
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
