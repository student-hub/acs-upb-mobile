import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/spoiler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  Future<List<String>> userClassIdsFuture;
  List<Class> classes;
  bool updating;

  void updateClasses() async {
    // If updating is null, classes haven't been initialized yet so they're not
    // technically "updating"
    if (updating != null) {
      updating = true;
    }

    ClassProvider classProvider =
        Provider.of<ClassProvider>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    classes = await classProvider.fetchClasses(uid: authProvider.uid);

    updating = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    updateClasses();

    ClassProvider classProvider =
        Provider.of<ClassProvider>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    userClassIdsFuture = classProvider.fetchUserClassIds(
        uid: authProvider.uid, context: context);
  }

  @override
  Widget build(BuildContext context) {
    ClassProvider classProvider = Provider.of<ClassProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: S.of(context).navigationClasses,
      actions: [
        AppScaffoldAction(
          icon: Icons.add,
          tooltip: S.of(context).actionAddClasses,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                  value: classProvider,
                  child: FutureBuilder(
                    future: userClassIdsFuture,
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return AddClassesPage(
                            initialClassIds: snap.data,
                            onSave: (classIds) async {
                              await classProvider.setUserClassIds(
                                  classIds: classIds, uid: authProvider.uid);
                              updateClasses();
                              Navigator.pop(context);
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
            ),
          ),
        ),
      ],
      body: Stack(
        children: [
          ClassList(
            classes: classes,
            onTap: (classInfo) => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: classProvider,
                child: ClassView(classInfo: classInfo),
              ),
            )),
          ),
          if (updating == true)
            Container(
                color: Theme.of(context).disabledColor,
                child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}

class AddClassesPage extends StatefulWidget {
  final List<String> initialClassIds;
  final Function(List<String>) onSave;

  const AddClassesPage({Key key, this.initialClassIds, this.onSave})
      : super(key: key);

  @override
  _AddClassesPageState createState() =>
      _AddClassesPageState(classIds: initialClassIds);
}

class _AddClassesPageState extends State<AddClassesPage> {
  List<String> classIds;
  List<Class> classes;

  _AddClassesPageState({List<String> classIds})
      : this.classIds = classIds ?? [];

  void updateClasses() async {
    ClassProvider classProvider =
        Provider.of<ClassProvider>(context, listen: false);
    classes = await classProvider.fetchClasses();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateClasses();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).actionAddClasses,
      actions: [
        AppScaffoldAction(
          text: S.of(context).buttonSave,
          onPressed: () => widget.onSave(classIds),
        )
      ],
      body: ClassList(
        classes: classes,
        initiallySelected: classIds,
        selectable: true,
        onSelected: (selected, classId) {
          if (selected) {
            classIds.add(classId);
          } else {
            classIds.remove(classId);
          }
        },
      ),
    );
  }
}

class ClassList extends StatelessWidget {
  final List<Class> classes;
  final Function(bool, String) onSelected;
  final List<String> initiallySelected;
  final bool selectable;
  final Function(Class) onTap;

  ClassList(
      {this.classes,
      Function(bool, String) onSelected,
      List<String> initiallySelected,
      this.selectable = false,
      Function(Class) onTap})
      : onSelected = onSelected ?? ((selected, classId) {}),
        onTap = onTap ?? ((_) {}),
        initiallySelected = initiallySelected ?? [];

  String sectionName(BuildContext context, String year, String semester) =>
      S.of(context).labelYear +
      ' ' +
      year +
      ', ' +
      S.of(context).labelSemester +
      ' ' +
      semester;

  Map<String, List<Class>> sections(List<Class> classes, BuildContext context) {
    Map<String, List<Class>> classSections = {};
    for (var year in ['1', '2', '3', '4']) {
      for (var semester in ['1', '2']) {
        classSections[sectionName(context, year, semester)] = [];
      }
    }
    classes.forEach((c) {
      classSections[sectionName(context, c.year, c.semester)].add(c);
    });
    classSections.keys.forEach(
        (key) => classSections[key].sort((a, b) => a.name.compareTo(b.name)));
    classSections.removeWhere((key, classes) => classes.length == 0);
    return classSections;
  }

  @override
  Widget build(BuildContext context) {
    if (classes != null) {
      var classSections = sections(classes, context);

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: classSections
              .map((sectionName, classes) => MapEntry(
                  sectionName,
                  Column(
                    children: [
                      AppSpoiler(
                        title: sectionName,
                        content: Column(
                          children: <Widget>[Divider()] +
                              classes
                                  .map<Widget>(
                                    (c) => Column(
                                      children: [
                                        ClassListItem(
                                          selectable: selectable,
                                          initiallySelected:
                                              initiallySelected.contains(c.id),
                                          classInfo: c,
                                          onSelected: (selected) =>
                                              onSelected(selected, c.id),
                                          onTap: () => onTap(c),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  )))
              .values
              .toList(),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

class ClassListItem extends StatefulWidget {
  final Class classInfo;
  final bool initiallySelected;
  final Function(bool) onSelected;
  final bool selectable;
  final Function() onTap;

  ClassListItem(
      {Key key,
      this.classInfo,
      this.initiallySelected = false,
      Function(bool) onSelected,
      this.selectable = false,
      Function() onTap})
      : this.onSelected = onSelected ?? ((_) {}),
        this.onTap = onTap ?? (() {}),
        super(key: key);

  @override
  _ClassListItemState createState() =>
      _ClassListItemState(selected: initiallySelected);
}

class _ClassListItemState extends State<ClassListItem> {
  bool selected;

  _ClassListItemState({this.selected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.classInfo.colorFromAcronym,
        child: (widget.selectable && selected)
            ? Icon(
                Icons.check,
                color: widget.classInfo.colorFromAcronym.highEmphasisOnColor,
              )
            : AutoSizeText(
                widget.classInfo.acronym,
                minFontSize: 5,
                maxLines: 1,
                style: TextStyle(
                  color: widget.classInfo.colorFromAcronym.highEmphasisOnColor,
                ),
              ),
      ),
      title: Text(
        widget.classInfo.completeName,
        style: widget.selectable
            ? (selected
                ? Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.bold)
                : TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.normal))
            : Theme.of(context).textTheme.subtitle1,
      ),
      onTap: () => setState(() {
        if (widget.selectable) {
          selected = !selected;
          widget.onSelected(selected);
        }
        widget.onTap();
      }),
    );
  }
}
