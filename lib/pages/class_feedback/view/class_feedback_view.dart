import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../resources/locale_provider.dart';
import '../../../widgets/icon_text.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../../classes/model/class.dart';
import '../../people/model/person.dart';
import '../../people/service/person_provider.dart';
import '../../people/view/people_page.dart';
import '../model/questions/question.dart';
import '../service/feedback_provider.dart';
import 'feedback_question.dart';

class ClassFeedbackView extends StatefulWidget {
  const ClassFeedbackView({final Key key, this.classHeader}) : super(key: key);

  final ClassHeader classHeader;

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
        .then((final teachers) => setState(() => classTeachers = teachers));

    Provider.of<FeedbackProvider>(context, listen: false)
        .fetchCategories()
        .then((final categories) => setState(() => feedbackCategories = categories));

    Provider.of<PersonProvider>(context, listen: false)
        .mostRecentLecturer(widget.classHeader.id)
        .then((final value) => selectedTeacherName = value);

    fetchFeedbackQuestions();
  }

  Future<Map<String, dynamic>> fetchFeedbackQuestions() async {
    await Provider.of<FeedbackProvider>(context, listen: false)
        .fetchQuestions()
        .then((final questions) => setState(() => feedbackQuestions = questions));

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

  Widget lecturerFormField(final BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);

    return FutureBuilder(
      future: personProvider.fetchPerson(selectedTeacherName),
      builder: (final context, final snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final lecturer = snapshot.data;
          selectedTeacher = lecturer;
          return AutocompletePerson(
            key: const Key('AutocompleteLecturer'),
            labelText: S.current.labelLecturer,
            formKey: formKey,
            onSaved: (final value) => selectedTeacher = value,
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
      onSaved: (final value) => selectedAssistant = value,
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
            onChanged: (final value) =>
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

  Widget categoryHeader(final String category) {
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
  Widget build(final BuildContext context) {
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
          in feedbackQuestions.values.where((final q) => q.category == category)) {
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
            if (!mounted) return;
            Navigator.of(context).pop();
            AppToast.show(S.current.messageFeedbackHasBeenSent);
          }
        },
      );
}
