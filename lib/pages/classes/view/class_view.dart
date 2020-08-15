import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/grading_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/shortcut_view.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

extension ClassExtension on ClassHeader {
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

class ClassView extends StatefulWidget {
  final ClassHeader classHeader;

  const ClassView({Key key, this.classHeader}) : super(key: key);

  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  Class classInfo;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.classHeader.name,
      body: FutureBuilder(
          future: Provider.of<ClassProvider>(context)
              .fetchClassInfo(widget.classHeader, context: context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              classInfo = snapshot.data;

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        shortcuts(context),
                        SizedBox(height: 8),
                        GradingChart(grading: classInfo.grading),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
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
                    S.of(context).sectionShortcuts,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                        value: classProvider,
                        child: ShortcutView(onSave: (shortcut) {
                          setState(() => classInfo.shortcuts.add(shortcut));
                          classProvider.addShortcut(
                              classId: widget.classHeader.id,
                              shortcut: shortcut,
                              context: context);
                        }),
                      ),
                    )),
                  ),
                ],
              ),
              Divider()
            ] +
            (classInfo.shortcuts.isEmpty
                ? <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          S.of(context).labelUnknown,
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        ),
                      ),
                    )
                  ]
                : classInfo.shortcuts
                    .asMap()
                    .map((i, s) => MapEntry(
                        i, shortcut(index: i, shortcut: s, context: context)))
                    .values
                    .toList()),
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

  AppDialog _deletionConfirmationDialog(
          {BuildContext context, String shortcutName, Function onDelete}) =>
      AppDialog(
        icon: Icon(Icons.delete),
        title: S.of(context).actionDeleteShortcut,
        message: S.of(context).messageDeleteShortcut(shortcutName),
        info: S.of(context).messageThisCouldAffectOtherStudents,
        actions: [
          AppButton(
            text: S.of(context).actionDeleteShortcut,
            width: 130,
            onTap: onDelete,
          )
        ],
      );

  Widget shortcut({int index, Shortcut shortcut, BuildContext context}) {
    var classProvider = Provider.of<ClassProvider>(context);
    var classViewContext = context;

    return PositionedTapDetector(
      onTap: (_) => _launchURL(shortcut.link, context),
      onLongPress: (position) async {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject();
        var option = await showMenu(
            context: context,
            position: RelativeRect.fromRect(
                Rect.fromPoints(position.global, position.global),
                Offset.zero & overlay.size),
            items: [
              PopupMenuItem(
                value: S.of(context).actionDeleteShortcut,
                child: Text(S.of(context).actionDeleteShortcut),
              )
            ]);
        if (option == S.of(context).actionDeleteShortcut) {
          showDialog(
              context: context,
              builder: (context) => _deletionConfirmationDialog(
                  context: context,
                  shortcutName: shortcut.name,
                  onDelete: () async {
                    Navigator.pop(context); // Pop dialog window

                    var success = await classProvider.deleteShortcut(
                        classId: widget.classHeader.id,
                        shortcutIndex: index,
                        context: context);
                    if (success) {
                      setState(() {
                        classInfo.shortcuts.removeAt(index);
                      });
                      AppToast.show(
                          S.of(classViewContext).messageShortcutDeleted);
                    }
                  }));
        }
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(shortcutIcon(shortcut.type)),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).iconTheme.color,
        ),
        title: Text(shortcut.name ?? shortcut.type.toLocalizedString(context)),
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
