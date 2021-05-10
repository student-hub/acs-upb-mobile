import 'package:acs_upb_mobile/pages/class_feedback/model/class_feedback_answer.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
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

  List<String> involvementPercentages = [];
  String selectedTeacherName;
  Person selectedAssistant;
  List<Person> classTeachers = [];
  Map<String, dynamic> feedbackQuestions = {};
  Map<String, dynamic> feedbackCategories = {};
  Map<int, String> responses = {};
  List<Map<int, bool>> initialValues = [];

  @override
  void initState() {
    super.initState();

    agreedToResponsibilities = false;
    classController = TextEditingController(text: widget.classHeader?.id ?? '');
    involvementPercentages = [
      '0% ... 20%',
      '20% ... 40%',
      '40% ... 60%',
      '60% ... 80%',
      '80% ... 100%'
    ];
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
        labelText: S.of(context).labelClass,
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
              labelText: S.of(context).labelLecturer,
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
                S.of(context).messageAgreeFeedbackPolicy,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedbackProvider = Provider.of<FeedbackProvider>(context);

    final List<String> generalQuestionsRating =
        feedbackProvider.getQuestionsByCategoryAndType(
            feedbackQuestions.values.toList(), 'general', 'rating');

    final List<String> generalQuestionsRatingIndexes = feedbackQuestions.keys
        .where((element) =>
            feedbackQuestions[element]['type'] == 'rating' &&
            feedbackQuestions[element]['category'] == 'general')
        .toList();

    final List<String> generalQuestionsInput =
        feedbackProvider.getQuestionsByCategoryAndType(
            feedbackQuestions.values.toList(), 'general', 'input');

    final List<String> involvementQuestions =
        feedbackProvider.getQuestionsByCategoryAndType(
            feedbackQuestions.values.toList(), 'involvement', 'input');

    final List<String> lectureQuestions =
        feedbackProvider.getQuestionsByCategoryAndType(
            feedbackQuestions.values.toList(), 'lecture', 'rating');

    final List<String> applicationsQuestions =
        feedbackProvider.getQuestionsByCategoryAndType(
            feedbackQuestions.values.toList(), 'applications', 'rating');

    final List<String> homeworkQuestionsRating =
        feedbackProvider.getQuestionsByCategoryAndType(
            feedbackQuestions.values.toList(), 'homework', 'rating');

    final List<String> homeworkQuestionsInput =
        feedbackProvider.getQuestionsByCategoryAndType(
            feedbackQuestions.values.toList(), 'homework', 'input');

    final List<String> personalQuestions =
        feedbackProvider.getQuestionsByCategoryAndType(
            feedbackQuestions.values.toList(), 'personal', 'input');

    return AppScaffold(
      title: Text(S.of(context).navigationClassFeedback),
      actions: [_submitButton()],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: [
                      IconText(
                        icon: Icons.info_outline,
                        text: S.of(context).infoFormAnonymous,
                      ),
                      classWidget(),
                      lecturerWidget(context),
                      assistantWidget(),
                      acknowledgementWidget(),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                S.of(context).sectionGeneralQuestions,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                generalQuestionsInput.isNotEmpty
                                    ? generalQuestionsInput.single
                                    : '-',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextFormField(
                                onSaved: (value) {
                                  responses[int.parse(
                                      feedbackQuestions.keys.isNotEmpty
                                          ? feedbackQuestions.keys.firstWhere(
                                              (element) =>
                                                  feedbackQuestions[element]
                                                          ['type'] ==
                                                      'input' &&
                                                  feedbackQuestions[element]
                                                          ['category'] ==
                                                      'general')
                                          : '-1')] = value;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: S.of(context).labelGrade,
                                  prefixIcon: const Icon(Icons.grade_outlined),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return S.current
                                        .warningYouNeedToSelectAtLeastOne;
                                  }
                                  return null;
                                },
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 24),
                              ...generalQuestionsRating.asMap().entries.map(
                                (entry) {
                                  return EmojiFormField(
                                    question: entry.value,
                                    onSaved: (value) {
                                      responses[int.parse(
                                          generalQuestionsRatingIndexes[
                                              entry.key])] = value.keys
                                          .firstWhere((element) =>
                                              value[element] == true)
                                          .toString();
                                    },
                                    validator: (selection) {
                                      if (selection.values
                                          .where((e) => e != false)
                                          .isEmpty) {
                                        return S
                                            .of(context)
                                            .warningYouNeedToSelectAtLeastOne;
                                      }
                                      return null;
                                    },
                                    initialValues: initialValues[entry.key],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                S.of(context).sectionInvolvement,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                involvementQuestions.isNotEmpty
                                    ? involvementQuestions.single
                                    : '-',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: S.of(context).sectionInvolvement,
                                  prefixIcon:
                                      const Icon(Icons.local_activity_outlined),
                                ),
                                onSaved: (value) {
                                  responses[generalQuestionsInput.length +
                                      generalQuestionsRating.length] = value;
                                },
                                items: involvementPercentages
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
                                    return S
                                        .of(context)
                                        .errorEventTypeCannotBeEmpty;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                S.of(context).uniEventTypeLecture,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              ...lectureQuestions.asMap().entries.map(
                                (entry) {
                                  return EmojiFormField(
                                    question: entry.value,
                                    onSaved: (value) {
                                      responses[generalQuestionsInput.length +
                                              generalQuestionsRating.length +
                                              involvementQuestions.length +
                                              entry.key] =
                                          value.keys
                                              .firstWhere((element) =>
                                                  value[element] == true)
                                              .toString();
                                    },
                                    validator: (selection) {
                                      if (selection.values
                                          .where((e) => e != false)
                                          .isEmpty) {
                                        return S
                                            .of(context)
                                            .warningYouNeedToSelectAtLeastOne;
                                      }
                                      return null;
                                    },
                                    initialValues: initialValues[
                                        generalQuestionsInput.length +
                                            generalQuestionsRating.length +
                                            involvementQuestions.length +
                                            entry.key],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                S.of(context).sectionApplications,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              ...applicationsQuestions.asMap().entries.map(
                                (entry) {
                                  return EmojiFormField(
                                    question: entry.value,
                                    onSaved: (value) {
                                      responses[generalQuestionsInput.length +
                                              generalQuestionsRating.length +
                                              involvementQuestions.length +
                                              lectureQuestions.length +
                                              entry.key] =
                                          value.keys
                                              .firstWhere((element) =>
                                                  value[element] == true)
                                              .toString();
                                    },
                                    validator: (selection) {
                                      if (selection.values
                                          .where((e) => e != false)
                                          .isEmpty) {
                                        return S
                                            .of(context)
                                            .warningYouNeedToSelectAtLeastOne;
                                      }
                                      return null;
                                    },
                                    initialValues: initialValues[
                                        generalQuestionsInput.length +
                                            generalQuestionsRating.length +
                                            involvementQuestions.length +
                                            lectureQuestions.length +
                                            entry.key],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                S.of(context).uniEventTypeHomework,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                homeworkQuestionsInput.isNotEmpty
                                    ? homeworkQuestionsInput.single
                                    : '-',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextFormField(
                                onSaved: (value) {
                                  responses[generalQuestionsInput.length +
                                      generalQuestionsRating.length +
                                      involvementQuestions.length +
                                      lectureQuestions.length +
                                      applicationsQuestions.length] = value;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: S.current.labelGrade,
                                  prefixIcon: const Icon(Icons.grade_outlined),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return S.current
                                        .warningYouNeedToSelectAtLeastOne;
                                  }
                                  return null;
                                },
                                onChanged: (_) => setState(() {}),
                              ),
                              ...homeworkQuestionsRating.asMap().entries.map(
                                (entry) {
                                  return EmojiFormField(
                                    question: entry.value,
                                    onSaved: (value) {
                                      responses[generalQuestionsInput.length +
                                              generalQuestionsRating.length +
                                              involvementQuestions.length +
                                              lectureQuestions.length +
                                              applicationsQuestions.length +
                                              homeworkQuestionsInput.length +
                                              entry.key] =
                                          value.keys
                                              .firstWhere((element) =>
                                                  value[element] == true)
                                              .toString();
                                    },
                                    validator: (selection) {
                                      if (selection.values
                                          .where((e) => e != false)
                                          .isEmpty) {
                                        return S
                                            .of(context)
                                            .warningYouNeedToSelectAtLeastOne;
                                      }
                                      return null;
                                    },
                                    initialValues: initialValues[
                                        generalQuestionsInput.length +
                                            generalQuestionsRating.length +
                                            involvementQuestions.length +
                                            lectureQuestions.length +
                                            applicationsQuestions.length +
                                            homeworkQuestionsInput.length +
                                            entry.key],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                S.of(context).sectionPersonalComments,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 24),
                              ...personalQuestions.asMap().entries.map(
                                (entry) {
                                  return Column(
                                    children: [
                                      Text(
                                        entry.value,
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
                                                  responses[generalQuestionsInput
                                                          .length +
                                                      generalQuestionsRating
                                                          .length +
                                                      involvementQuestions
                                                          .length +
                                                      lectureQuestions.length +
                                                      applicationsQuestions
                                                          .length +
                                                      homeworkQuestionsInput
                                                          .length +
                                                      homeworkQuestionsRating
                                                          .length +
                                                      entry.key] = value;
                                                },
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
            if (feedbackQuestions[i.toString()]['type'] == 'input') {
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
