import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/error_page.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../../classes/model/class.dart';
import '../../classes/service/class_provider.dart';
import '../service/feedback_provider.dart';
import 'class_feedback_view.dart';

class ClassFeedbackChecklist extends StatefulWidget {
  const ClassFeedbackChecklist({final Key key, this.classes}) : super(key: key);
  final Set<ClassHeader> classes;

  @override
  _ClassFeedbackChecklistState createState() => _ClassFeedbackChecklistState();
}

class _ClassFeedbackChecklistState extends State<ClassFeedbackChecklist> {
  Map<String, dynamic> classesFeedback = {};

  Future<void> fetchCompletedFeedback() async {
    final feedbackProvider = Provider.of<FeedbackProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    classesFeedback = await feedbackProvider
        .getClassesWithCompletedFeedback(authProvider.uid);
    if (mounted) setState(() {});
  }

  Widget checklistPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          S.current.sectionFeedbackNeeded,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 6),
        FeedbackClassList(
          classes: widget.classes
              .where((final element) =>
                  !(classesFeedback?.containsKey(element.id) ?? false))
              ?.toSet(),
          done: false,
        ),
        const Divider(thickness: 4),
        const SizedBox(height: 12),
        Text(
          S.current.sectionFeedbackCompleted,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 6),
        if (classesFeedback != null)
          FeedbackClassList(
            classes: widget.classes
                .where(
                    (final element) => classesFeedback.containsKey(element.id))
                ?.toSet(),
            done: true,
          ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    fetchCompletedFeedback();
    return AppScaffold(
      title: Text(S.current.navigationClassesFeedbackChecklist),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              if (widget.classes != null)
                checklistPage()
              else
                ErrorPage(
                  errorMessage: S.current.messageNoClassesYet,
                  imgPath: 'assets/illustrations/undraw_empty.png',
                  info: [
                    TextSpan(text: '${S.current.messageGetStartedByPressing} '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.edit_outlined,
                        size:
                            Theme.of(context).textTheme.subtitle1.fontSize + 2,
                      ),
                    ),
                    TextSpan(text: ' ${S.current.messageButtonAbove}.'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackClassList extends StatelessWidget {
  const FeedbackClassList({final Key key, this.classes, this.done})
      : super(key: key);
  final Set<ClassHeader> classes;
  final bool done;

  @override
  Widget build(final BuildContext context) {
    return Column(
        children: classes
            .map(
              (final classHeader) =>
                  FeedbackClassListItem(classHeader: classHeader, done: done),
            )
            .toList());
  }
}

class FeedbackClassListItem extends StatelessWidget {
  const FeedbackClassListItem({final Key key, this.classHeader, this.done})
      : super(key: key);

  final ClassHeader classHeader;
  final bool done;

  void onTap(final BuildContext context) {
    if (!done) {
      Navigator.of(context).push(
        MaterialPageRoute<ChangeNotifierProvider>(
          builder: (final context) => ChangeNotifierProvider.value(
            value: Provider.of<ClassProvider>(context),
            child: ClassFeedbackView(classHeader: classHeader),
          ),
        ),
      );
    } else {
      AppToast.show(S.current.warningFeedbackAlreadySent);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: done,
        onChanged: (final _) => onTap(context),
        activeColor: Colors.grey,
      ),
      title: Text(
        classHeader.name,
        style: done
            ? Theme.of(context).textTheme.subtitle1.copyWith(
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).disabledColor)
            : Theme.of(context).textTheme.subtitle1,
      ),
      onTap: () => onTap(context),
    );
  }
}
