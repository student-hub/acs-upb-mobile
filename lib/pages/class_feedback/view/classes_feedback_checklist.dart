import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/class_feedback_view.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/widgets/class_icon.dart';
import 'package:acs_upb_mobile/widgets/error_page.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesFeedbackChecklist extends StatefulWidget {
  const ClassesFeedbackChecklist({Key key, this.classes}) : super(key: key);
  final Set<ClassHeader> classes;

  @override
  _ClassesFeedbackChecklistState createState() =>
      _ClassesFeedbackChecklistState();
}

class _ClassesFeedbackChecklistState extends State<ClassesFeedbackChecklist> {
  Map<String, dynamic> classesFeedback = {};

  @override
  void initState() {
    super.initState();
    fetchFeedbackProvided();
  }

  Future<Map<String, dynamic>> fetchFeedbackProvided() async {
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await feedbackProvider
        .getProvidedFeedbackClasses(authProvider.uid)
        .then((value) => setState(() => classesFeedback = value));
    return classesFeedback;
  }

  Widget checklistPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          S.current.sectionTODO,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 6),
        FeedbackClassList(
          classes: widget.classes
              .where((element) => !classesFeedback.containsKey(element.id))
              .toSet(),
          done: false,
        ),
        const Divider(thickness: 4),
        const SizedBox(height: 12),
        Text(
          S.current.sectionCompleted,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 6),
        FeedbackClassList(
          classes: widget.classes
              .where((element) => classesFeedback.containsKey(element.id))
              .toSet(),
          done: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      TextSpan(
                          text: '${S.current.messageGetStartedByPressing} '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.edit_outlined,
                          size: Theme.of(context).textTheme.subtitle1.fontSize +
                              2,
                        ),
                      ),
                      TextSpan(text: ' ${S.current.messageButtonAbove}.'),
                    ])
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackClassList extends StatelessWidget {
  const FeedbackClassList({Key key, this.classes, this.done}) : super(key: key);
  final Set<ClassHeader> classes;
  final bool done;

  Widget buildFeedbackClassList(ClassHeader header) => Column(
        children: [
          FeedbackClassListItem(
            classHeader: header,
            done: done,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Column(children: classes.map(buildFeedbackClassList).toList());
  }
}

class FeedbackClassListItem extends StatelessWidget {
  const FeedbackClassListItem({Key key, this.classHeader, this.done})
      : super(key: key);

  final ClassHeader classHeader;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);

    return ListTile(
      leading: Checkbox(
        value: done,
        onChanged: (bool value) {},
      ),
      title: Text(
        classHeader.name,
        style: done
            ? Theme.of(context).textTheme.subtitle1.copyWith(
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).disabledColor)
            : Theme.of(context).textTheme.subtitle1,
      ),
      onTap: () {
        if (done == false) {
          Navigator.of(context).push(
            MaterialPageRoute<ChangeNotifierProvider>(
              builder: (context) => ChangeNotifierProvider.value(
                value: classProvider,
                child: ClassFeedbackView(classHeader: classHeader),
              ),
            ),
          );
        } else {
          AppToast.show(S.current.warningFeedbackAlreadySent);
        }
      },
    );
  }
}
