import 'package:acs_upb_mobile/pages/class_feedback/model/class_feedback_answer.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_dropdown.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/radio_emoji.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class ClassFeedbackView extends StatefulWidget {
  const ClassFeedbackView({Key key, this.classHeader}) : super(key: key);

  final ClassHeader classHeader;

  @override
  _ClassFeedbackViewState createState() => _ClassFeedbackViewState();
}

class _ClassFeedbackViewState extends State<ClassFeedbackView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController classController;
  bool agreedToResponsibilities;

  String selectedTeacherName;
  Person selectedAssistant;
  List<Person> classTeachers = [];
  Map<String, dynamic> feedbackCategories = {};
  Map<int, String> responses = {};
  List<Map<int, bool>> initialValues = [];
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

    fetchFeedbackQuestions();
  }

  Future<Map<String, dynamic>> fetchFeedbackQuestions() async {
    await Provider.of<FeedbackProvider>(context, listen: false)
        .fetchQuestions()
        .then((questions) => setState(() => feedbackQuestions = questions));

    for (int i = 0; i <= feedbackQuestions.length; i++) {
      initialValues.insert(i, {
        0: false,
        1: false,
        2: false,
        3: false,
        4: false,
      });
    }

    return feedbackQuestions;
  }

  Widget classWidget() {
    return TextFormField(
      enabled: false,
      controller: classController,
      decoration: InputDecoration(
        labelText: S.current.labelClass,
        prefixIcon: const Icon(FeatherIcons.bookOpen),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget lecturerWidget(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);

    return FutureBuilder(
      future: personProvider.mostRecentLecturer(widget.classHeader.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final lecturerName = snapshot.data;
          selectedTeacherName = lecturerName;
          return TextFormField(
            enabled: false,
            controller: TextEditingController(text: lecturerName ?? '-'),
            decoration: InputDecoration(
              labelText: S.current.labelLecturer,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            onChanged: (_) => setState(() {}),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget assistantWidget() {
    return AutocompletePerson(
      key: const Key('AutocompleteAssistant'),
      labelText: S.current.labelAssistant,
      warning: S.current.warningYouNeedToSelectAssistant,
      formKey: formKey,
      onSaved: (value) => selectedAssistant = value,
      classTeachers: classTeachers,
    );
  }

  Widget acknowledgementWidget() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: agreedToResponsibilities,
            visualDensity: VisualDensity.compact,
            onChanged: (value) =>
                setState(() => agreedToResponsibilities = value),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.25),
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

  Widget questionWidget(FeedbackQuestion question) {
    if (question.type == 'input') {
      return Column(
        children: [
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          TextFormField(
            onSaved: (value) {
              responses[int.parse(question.id)] = value;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return S.current.errorAnswerCannotBeEmpty;
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (question.type == 'rating') {
      return Column(
        children: [
          EmojiFormField(
            question: question.question,
            onSaved: (value) {
              responses[int.parse(question.id)] = value.keys
                  .firstWhere((element) => value[element] == true)
                  .toString();
            },
            validator: (selection) {
              if (selection.values.where((e) => e != false).isEmpty) {
                return S.current.warningYouNeedToSelectAtLeastOne;
              }
              return null;
            },
            initialValues: initialValues[int.parse(question.id)],
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (question.type == 'dropdown') {
      return Column(
        children: [
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          DropdownButtonFormField<String>(
            onSaved: (value) {
              responses[int.parse(question.id)] = value;
            },
            items: (question as FeedbackQuestionDropdown)
                .options
                .map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type.toString()),
                  ),
                )
                .toList(),
            onChanged: (selection) {
              formKey.currentState.validate();
              setState(() => {});
            },
            validator: (selection) {
              if (selection == null) {
                return S.current.errorAnswerCannotBeEmpty;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (question.type == 'text') {
      return Column(
        children: [
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (value) {
                      responses[int.parse(question.id)] = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      IconText(
        icon: Icons.info_outline,
        text: S.current.infoFormAnonymous,
      ),
      classWidget(),
      lecturerWidget(context),
      assistantWidget(),
      acknowledgementWidget(),
      const SizedBox(height: 24),
    ];

    for (final category in feedbackCategories.keys) {
      final List<Widget> categoryChildren = [
        categoryHeader(
            feedbackCategories[category][LocaleProvider.localeString])
      ];
      for (final question
          in feedbackQuestions.values.where((q) => q.category == category)) {
        categoryChildren.add(questionWidget(question));
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

          bool res;

          for (var i = 0; i < feedbackQuestions.length; i++) {
            res = false;
            if (feedbackQuestions[i.toString()].type == 'input' ||
                feedbackQuestions[i.toString()].type == 'text' ||
                feedbackQuestions[i.toString()].type == 'dropdown') {
              final response = ClassFeedbackAnswer(
                assistant: selectedAssistant,
                teacherName: selectedTeacherName,
                className: classController.text,
                questionNumber: i.toString(),
                questionTextAnswer: responses[i],
              );

              res = await Provider.of<FeedbackProvider>(context, listen: false)
                  .addResponse(response);
              if (!res) break;
            } else {
              final response = ClassFeedbackAnswer(
                assistant: selectedAssistant,
                teacherName: selectedTeacherName,
                className: classController.text,
                questionNumber: i.toString(),
                questionNumericAnswer: responses[i],
              );

              res = await Provider.of<FeedbackProvider>(context, listen: false)
                  .addResponse(response);
              if (!res) break;
            }
          }
          if (res) {
            Navigator.of(context).pop();
            AppToast.show(S.current.messageFeedbackHasBeenSent);
          }
        },
      );
}
