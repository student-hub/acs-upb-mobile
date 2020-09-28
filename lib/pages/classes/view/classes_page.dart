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
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({Key key}) : super(key: key);

  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  Future<List<String>> userClassIdsFuture;
  List<ClassHeader> headers;
  bool updating;

  Future<void> updateClasses() async {
    // If updating is null, classes haven't been initialized yet so they're not
    // technically "updating"
    if (updating != null) {
      updating = true;
    }

    final ClassProvider classProvider =
        Provider.of<ClassProvider>(context, listen: false);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    headers = await classProvider.fetchClassHeaders(uid: authProvider.uid);

    updating = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    updateClasses();

    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    userClassIdsFuture = classProvider.fetchUserClassIds(
        uid: authProvider.uid, context: context);
  }

  Widget _noClassesView() => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 1, child: Container()),
            const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                    image: AssetImage('assets/illustrations/undraw_empty.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(S.of(context).messageNoClassesYet,
                  style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                S.of(context).messageGetStartedButton,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: S.of(context).navigationClasses,
      // TODO(IoanaAlexandru): Simply show all classes if user is not authenticated
      needsToBeAuthenticated: true,
      actions: [
        AppScaffoldAction(
          icon: Icons.edit,
          tooltip: S.of(context).actionTakeClasses,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<ChangeNotifierProvider>(
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
                              unawaited(updateClasses());
                              Navigator.pop(context);
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
            ),
          ),
        ),
      ],
      body: Stack(
        children: [
          if (updating != null)
            headers != null && headers.isNotEmpty
                ? ClassList(
                    classes: headers,
                    sectioned: false,
                    onTap: (classHeader) => Navigator.of(context)
                        .push(MaterialPageRoute<ChangeNotifierProvider>(
                      builder: (context) => ChangeNotifierProvider.value(
                        value: classProvider,
                        child: ClassView(classHeader: classHeader),
                      ),
                    )),
                  )
                : _noClassesView(),
          if (updating == null)
            const Center(child: CircularProgressIndicator()),
          if (updating == true)
            Container(
                color: Theme.of(context).disabledColor,
                child: const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}

class AddClassesPage extends StatefulWidget {
  const AddClassesPage({Key key, this.initialClassIds, this.onSave})
      : super(key: key);

  final List<String> initialClassIds;
  final void Function(List<String>) onSave;

  @override
  _AddClassesPageState createState() =>
      _AddClassesPageState(classIds: initialClassIds);
}

class _AddClassesPageState extends State<AddClassesPage> {
  _AddClassesPageState({List<String> classIds}) : classIds = classIds ?? [];

  List<String> classIds;
  List<ClassHeader> headers;

  Future<void> updateClasses() async {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    headers = await classProvider.fetchClassHeaders();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    updateClasses();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).actionTakeClasses,
      actions: [
        AppScaffoldAction(
          text: S.of(context).buttonSave,
          onPressed: () => widget.onSave(classIds),
        )
      ],
      body: ClassList(
        classes: headers,
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
  ClassList(
      {this.classes,
      void Function(bool, String) onSelected,
      List<String> initiallySelected,
      this.selectable = false,
      this.sectioned = true,
      void Function(ClassHeader) onTap})
      : onSelected = onSelected ?? ((selected, classId) {}),
        onTap = onTap ?? ((_) {}),
        initiallySelected = initiallySelected ?? [];

  final List<ClassHeader> classes;
  final void Function(bool, String) onSelected;
  final List<String> initiallySelected;
  final bool selectable;
  final void Function(ClassHeader) onTap;
  final bool sectioned;

  String sectionName(BuildContext context, String year, String semester) =>
      '${S.of(context).labelYear} $year, ${S.of(context).labelSemester} $semester';

  Map<String, dynamic> classesBySection(
      List<ClassHeader> classes, BuildContext context) {
    final map = <String, dynamic>{};

    for (final c in classes) {
      final List<String> category = c.category.split('/');
      var currentPath = map;
      for (int i = 0; i < category.length; i++) {
        final String section = category[i].trim();

        if (!currentPath.containsKey(section)) {
          currentPath[section] = <String, dynamic>{};
        }
        currentPath = currentPath[section];
      }

      if (!currentPath.containsKey('/')) {
        currentPath['/'] = <ClassHeader>[];
      }
      currentPath['/'].add(c);
    }

    return map;
  }

  List<Widget> buildSections(
      BuildContext context, Map<String, dynamic> sections,
      {int level = 0}) {
    final List<Widget> children = [const SizedBox(height: 4)];

    sections.forEach((section, values) {
      if (section == '/') {
        children.addAll(values.map<Widget>(buildClassItem));
      } else {
        children.add(AppSpoiler(
          title: section,
          level: level,
          initiallyExpanded: false,
          content: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children:
                  buildSections(context, sections[section], level: level + 1),
            ),
          ),
        ));
      }
    });

    return children;
  }

  Widget buildClassItem(ClassHeader header) => Column(
        children: [
          ClassListItem(
            selectable: selectable,
            initiallySelected: initiallySelected.contains(header.id),
            classHeader: header,
            onSelected: (selected) => onSelected(selected, header.id),
            onTap: () => onTap(header),
          ),
          const Divider(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (classes != null) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
                children: sectioned
                    ? buildSections(context, classesBySection(classes, context))
                    : classes.map(buildClassItem).toList()),
          ),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class ClassListItem extends StatefulWidget {
  ClassListItem(
      {Key key,
      this.classHeader,
      this.initiallySelected = false,
      void Function(bool) onSelected,
      this.selectable = false,
      void Function() onTap})
      : onSelected = onSelected ?? ((_) {}),
        onTap = onTap ?? (() {}),
        super(key: key);

  final ClassHeader classHeader;
  final bool initiallySelected;
  final void Function(bool) onSelected;
  final bool selectable;
  final void Function() onTap;

  @override
  _ClassListItemState createState() =>
      _ClassListItemState(selected: initiallySelected);
}

class _ClassListItemState extends State<ClassListItem> {
  _ClassListItemState({this.selected});

  bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.classHeader.colorFromAcronym,
        child: (widget.selectable && selected)
            ? Icon(
                Icons.check,
                color: widget.classHeader.colorFromAcronym.highEmphasisOnColor,
              )
            : AutoSizeText(
                widget.classHeader.acronym,
                minFontSize: 5,
                maxLines: 1,
                style: TextStyle(
                  color:
                      widget.classHeader.colorFromAcronym.highEmphasisOnColor,
                ),
              ),
      ),
      title: Text(
        widget.classHeader.name,
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
