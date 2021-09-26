import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/app_navigator.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/feedback_question.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/navigation/view/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class ClassFeedbackView extends StatefulWidget {
  const ClassFeedbackView({Key key, this.classHeader}) : super(key: key);

  final ClassHeader classHeader;

  static const String routeName = '/class/feedback';

  @override
  _ClassFeedbackViewState createState() => _ClassFeedbackViewState();
}

class _ClassFeedbackViewState extends State<ClassFeedbackView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController classController;
  bool agreedToResponsibilities;

  Person selectedTeacher;
  String selectedTeacherName;
  Person selectedAssistant;
  List<Person> classTeachers = [];
  Map<String, Map<String, String>> feedbackCategories = {};
  List<Map<int, bool>> answerValues = [];
  Map<String, FeedbackQuestion> feedbackQuestions = {};

  @override
  void initState() {
    super.initState();

    agreedToResponsibilities = false;
    classController = TextEditingController(text: widget.classHeader?.id ?? '');

    Provider.of<PersonProvider>(context, listen: false)
        .fetchPeople()
        .then((teachers) => setState(() => classTeachers = teachers));

    Provider.of<FeedbackProvider>(context, listen: false)
        .fetchCategories()
        .then((categories) => setState(() => feedbackCategories = categories));

    Provider.of<PersonProvider>(context, listen: false)
        .mostRecentLecturer(widget.classHeader.id)
        .then((value) => selectedTeacherName = value);

    fetchFeedbackQuestions();
  }

  Future<Map<String, dynamic>> fetchFeedbackQuestions() async {
    await Provider.of<FeedbackProvider>(context, listen: false)
        .fetchQuestions()
        .then((questions) => setState(() => feedbackQuestions = questions));

    for (int i = 0; i <= feedbackQuestions.length; i++) {
      answerValues.insert(i, {
        0: false,
        1: false,
        2: false,
        3: false,
        4: false,
      });
    }

    return feedbackQuestions;
  }

  Widget classFormField() {
    return TextFormField(
      enabled: false,
      controller: classController,
      decoration: InputDecoration(
        labelText: S.current.labelClass,
        prefixIcon: const Icon(FeatherIcons.bookOpen),
      ),
    );
  }

  Widget lecturerFormField(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);

    return FutureBuilder(
      future: personProvider.fetchPerson(selectedTeacherName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final lecturer = snapshot.data;
          selectedTeacher = lecturer;
          return AutocompletePerson(
            key: const Key('AutocompleteLecturer'),
            labelText: S.current.labelLecturer,
            formKey: formKey,
            onSaved: (value) => selectedTeacher = value,
            classTeachers: classTeachers,
            personDisplayed: selectedTeacherName == null
                ? Person(name: '-')
                : selectedTeacher,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget assistantFormField() {
    return AutocompletePerson(
      key: const Key('AutocompleteAssistant'),
      labelText: S.current.labelAssistant,
      warning: S.current.warningYouNeedToSelectAssistant,
      formKey: formKey,
      onSaved: (value) => selectedAssistant = value,
      classTeachers: classTeachers,
    );
  }

  Widget acknowledgementFormField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            key: const Key('AcknowledgementCheckbox'),
            value: agreedToResponsibilities,
            visualDensity: VisualDensity.compact,
            onChanged: (value) =>
                setState(() => agreedToResponsibilities = value),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                S.current.messageAgreeFeedbackPolicy,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryHeader(String category) {
    return Column(
      children: [
        Text(
          category,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      classFormField(),
      lecturerFormField(context),
      assistantFormField(),
      acknowledgementFormField(),
      const SizedBox(height: 24),
    ];

    for (final category in feedbackCategories.keys.toList()..sort()) {
      final List<Widget> categoryChildren = [
        categoryHeader(
            feedbackCategories[category][LocaleProvider.localeString])
      ];
      for (final question
          in feedbackQuestions.values.where((q) => q.category == category)) {
        categoryChildren.add(FeedbackQuestionFormField(
            question: question, answerValues: answerValues, formKey: formKey));
      }
      children.add(
        Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: categoryChildren,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return AppScaffold(
      title: Text(S.current.navigationClassFeedback),
      actions: [_submitButton()],
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, top: 10),
              child: IconText(
                icon: Icons.info_outline,
                text: S.current.infoFormAnonymous,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: children),
            ),
          ),
        ],
      ),
    );
  }

  AppScaffoldAction _submitButton() => AppScaffoldAction(
        text: S.current.buttonSend,
        onPressed: () async {
          if (!formKey.currentState.validate()) return;

          if (!agreedToResponsibilities) {
            AppToast.show(
                '${S.current.warningAgreeTo}${S.current.labelFeedbackPolicy}.');
            return;
          }

          setState(() {
            formKey.currentState.save();
          });

          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final String uid = authProvider.uid;
          final bool feedbackSentSuccessfully =
              await Provider.of<FeedbackProvider>(context, listen: false)
                  .submitFeedback(uid, feedbackQuestions, selectedAssistant,
                      selectedTeacher, classController.text);

          if (feedbackSentSuccessfully) {
            AppNavigator.pop(context);
            AppToast.show(S.current.messageFeedbackHasBeenSent);
          }
        },
      );
}
