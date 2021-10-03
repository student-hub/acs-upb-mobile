import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../resources/remote_config.dart';
import '../../../resources/utils.dart';
import '../../../widgets/button.dart';
import '../../../widgets/class_icon.dart';
import '../../../widgets/dialog.dart';
import '../../../widgets/icon_text.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../../class_feedback/service/feedback_provider.dart';
import '../../class_feedback/view/class_feedback_view.dart';
import '../../people/service/person_provider.dart';
import '../../people/view/person_view.dart';
import '../model/class.dart';
import '../service/class_provider.dart';
import 'grading_view.dart';
import 'shortcut_view.dart';

class ClassView extends StatefulWidget {
  const ClassView({Key key, this.classHeader}) : super(key: key);

  final ClassHeader classHeader;

  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  Class classInfo;
  String lecturerName = '';
  bool alreadyCompletedFeedback;

  @override
  void initState() {
    super.initState();
    final personProvider = Provider.of<PersonProvider>(context, listen: false);
    personProvider
        .mostRecentLecturer(widget.classHeader.id)
        .then((lecturer) => setState(() => lecturerName = lecturer));
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    feedbackProvider
        .userSubmittedFeedbackForClass(authProvider.uid, widget.classHeader.id)
        .then((value) => alreadyCompletedFeedback = value);

    return AppScaffold(
      title: Text(S.current.navigationClassInfo),
      actions: [
        if (RemoteConfigService.feedbackEnabled)
          AppScaffoldAction(
              icon: Icons.rate_review_outlined,
              tooltip: S.current.navigationClassFeedback,
              onPressed: alreadyCompletedFeedback == null
                  ? null
                  : () {
                      if (!alreadyCompletedFeedback) {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute<ClassFeedbackView>(
                                builder: (_) => ClassFeedbackView(
                                    classHeader: widget.classHeader),
                              ),
                            )
                            .then((value) => setState(() {}));
                      } else {
                        AppToast.show(S.current.warningFeedbackAlreadySent);
                      }
                    }),
      ],
      body: FutureBuilder(
          future: classProvider.fetchClassInfo(widget.classHeader),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              classInfo = snapshot.data;

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        lecturerCard(context),
                        const SizedBox(height: 12),
                        shortcuts(context),
                        const SizedBox(height: 12),
//                        ClassEventsCard(widget.classHeader.id),
                        const SizedBox(height: 12),
                        GradingChart(
                          grading: classInfo.grading,
                          lastUpdated: classInfo.gradingLastUpdated,
                          onSave: (grading) => classProvider.setGrading(
                              widget.classHeader.id, grading),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget shortcuts(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.sectionShortcuts,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  GestureDetector(
                    onTap: authProvider.currentUserFromCache.canEditClassInfo
                        ? () {}
                        : () => AppToast.show(
                            S.current.warningNoPermissionToEditClassInfo),
                    child: IconButton(
                      icon: const Icon(Icons.add_outlined),
                      onPressed:
                          authProvider.currentUserFromCache.canEditClassInfo
                              ? () => Navigator.of(context).push(
                                      MaterialPageRoute<ChangeNotifierProvider>(
                                    builder: (context) =>
                                        ChangeNotifierProvider.value(
                                      value: classProvider,
                                      child: ShortcutView(onSave: (shortcut) {
                                        setState(() =>
                                            classInfo.shortcuts.add(shortcut));
                                        classProvider.addShortcut(
                                            widget.classHeader.id, shortcut);
                                      }),
                                    ),
                                  ))
                              : null,
                    ),
                  ),
                ],
              ),
              const Divider()
            ] +
            (classInfo.shortcuts.isEmpty
                ? <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          S.current.labelUnknown,
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
        return Icons.home_outlined;
      case ShortcutType.classbook:
        return FeatherIcons.book;
      case ShortcutType.resource:
        return Icons.insert_drive_file_outlined;
      case ShortcutType.other:
        return FeatherIcons.globe;
    }
    return FeatherIcons.globe;
  }

  AppDialog _deletionConfirmationDialog(
          {BuildContext context, String shortcutName, Function onDelete}) =>
      AppDialog(
        icon: const Icon(Icons.delete_outlined),
        title: S.current.actionDeleteShortcut,
        message: S.current.messageDeleteShortcut(shortcutName),
        info: S.current.messageThisCouldAffectOtherStudents,
        actions: [
          AppButton(
            text: S.current.actionDeleteShortcut,
            width: 130,
            onTap: onDelete,
          )
        ],
      );

  Widget shortcut({int index, Shortcut shortcut, BuildContext context}) {
    final classProvider = Provider.of<ClassProvider>(context);

    return PositionedTapDetector2(
      onTap: (_) => Utils.launchURL(shortcut.link),
      onLongPress: (position) async {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject();
        final option = await showMenu(
            context: context,
            position: RelativeRect.fromRect(
                Rect.fromPoints(position.global, position.global),
                Offset.zero & overlay.size),
            items: [
              PopupMenuItem(
                value: S.current.actionDeleteShortcut,
                child: Text(S.current.actionDeleteShortcut),
              )
            ]);
        if (option == S.current.actionDeleteShortcut) {
          if (!mounted) return;
          await showDialog<dynamic>(
            context: context,
            builder: (context) => _deletionConfirmationDialog(
              context: context,
              shortcutName: shortcut.name,
              onDelete: () async {
                Navigator.pop(context); // Pop dialog window

                final success = await classProvider.deleteShortcut(
                    widget.classHeader.id, index);
                if (success) {
                  setState(() {
                    classInfo.shortcuts.removeAt(index);
                  });
                  AppToast.show(S.current.messageShortcutDeleted);
                }
              },
            ),
          );
        }
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(shortcutIcon(shortcut.type)),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).iconTheme.color,
        ),
        title: Text((shortcut.name?.isEmpty ?? true)
            ? shortcut.type.toLocalizedString()
            : shortcut.name),
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget lecturerCard(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);

    return Card(
      key: const Key('LecturerCard'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClassIcon(classHeader: widget.classHeader),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconText(
                    icon: FeatherIcons.bookOpen,
                    text: widget.classHeader.name ?? '-',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final lecturer =
                          await personProvider.fetchPerson(lecturerName);
                      if (lecturer != null && lecturerName != null) {
                        if (!mounted) return;
                        await showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext buildContext) =>
                                PersonView(person: lecturer));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconText(
                          icon: FeatherIcons.user,
                          text: lecturerName ?? '-',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
