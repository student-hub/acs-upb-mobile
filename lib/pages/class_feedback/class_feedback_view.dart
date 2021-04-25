import 'package:acs_upb_mobile/pages/class_feedback/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/widgets/autocomplete.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/radio_emoji.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:recase/recase.dart';

class ClassFeedbackView extends StatefulWidget {
  const ClassFeedbackView({Key key, this.classHeader}) : super(key: key);

  final ClassHeader classHeader;

  @override
  _ClassFeedbackViewState createState() => _ClassFeedbackViewState();
}

class _ClassFeedbackViewState extends State<ClassFeedbackView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController classController;
  bool agreedToResponsibilities = false;

  List<String> involvementPercentages = [];
  String selectedInvolvement;
  Person selectedAssistant;
  List<Person> classTeachers = [];
  List<dynamic> feedbackQuestions = [];

  Map<int, bool> emojiSelected = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
  };

  @override
  void initState() {
    super.initState();

    classController = TextEditingController(text: widget.classHeader?.id ?? '');
    involvementPercentages = [
      '0% ... 20%',
      '20% ... 40%',
      '40% ... 60%',
      '60% ... 80%',
      '80% ... 100%'
    ];
    Provider.of<PersonProvider>(context, listen: false)
        .fetchPeople(context: context)
        .then((teachers) => setState(() => classTeachers = teachers));
    Provider.of<FeedbackProvider>(context, listen: false)
        .fetchQuestions(context: context)
        .then((questions) => setState(() => feedbackQuestions = questions));
  }

  Widget autocompleteAssistant(BuildContext context) {
    return Autocomplete<Person>(
      key: const Key('AutocompleteAssistant'),
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        textEditingController.text = selectedAssistant?.name;
        return TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: S.of(context).labelAssistant,
            prefixIcon: const Icon(FeatherIcons.user),
          ),
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      displayStringForOption: (Person person) => person.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '' || textEditingValue.text.isEmpty) {
          return const Iterable<Person>.empty();
        }
        if (classTeachers.where((Person person) {
          return person.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        }).isEmpty) {
          final List<Person> inputTeachers = [];
          final Person inputTeacher =
              Person(name: textEditingValue.text.titleCase);
          inputTeachers.add(inputTeacher);
          return inputTeachers;
        }

        return classTeachers.where((Person person) {
          return person.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (Person selection) {
        formKey.currentState.validate();
        setState(() {
          selectedAssistant = selection;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);
    final feedbackProvider = Provider.of<FeedbackProvider>(context);
    print(feedbackQuestions.length);
    final List<String> generalQuestions =
        feedbackProvider.getQuestionsByCategory(feedbackQuestions, 'general');
    //final List<String> involvementQuestions = feedbackProvider
    //    .getQuestionsByCategory(feedbackQuestions, 'involvement');
    //final String involvementQuestion = involvementQuestions?.single;
    //print(involvementQuestion);

    final List<String> lectureQuestions =
        feedbackProvider.getQuestionsByCategory(feedbackQuestions, 'lecture');

    final List<String> applicationsQuestions = feedbackProvider
        .getQuestionsByCategory(feedbackQuestions, 'applications');

    final List<String> homeworkQuestions =
        feedbackProvider.getQuestionsByCategory(feedbackQuestions, 'homework');

    final List<String> personalQuestions =
        feedbackProvider.getQuestionsByCategory(feedbackQuestions, 'personal');

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
                  Column(children: [
                    IconText(
                      icon: Icons.info_outline,
                      text: S.of(context).infoFormAnonymous,
                    ),
                    TextFormField(
                      enabled: false,
                      controller: classController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelClass,
                        prefixIcon: const Icon(FeatherIcons.bookOpen),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    FutureBuilder(
                      future: personProvider
                          .mostRecentLecturer(widget.classHeader.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final lecturerName = snapshot.data;
                          return TextFormField(
                            enabled: false,
                            controller: TextEditingController(
                                text: lecturerName ?? '-'),
                            decoration: InputDecoration(
                              labelText: S.of(context).labelLecturer,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            onChanged: (_) => setState(() {}),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    autocompleteAssistant(context),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: agreedToResponsibilities,
                            visualDensity: VisualDensity.compact,
                            onChanged: (value) => setState(
                                () => agreedToResponsibilities = value),
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
                    ),
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
                              S.of(context).feedbackGeneralQuestion2,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: S.of(context).labelGrade,
                                prefixIcon: const Icon(Icons.grade_outlined),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 24),
                            ...generalQuestions.asMap().entries.map(
                              (entry) {
                                return EmojiFormField(
                                  question: entry.value,
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
                                  initialValues: emojiSelected,
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
                              S.of(context).feedbackActivitiesQuestion,
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
                              value: selectedInvolvement,
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
                                setState(() => selectedInvolvement = selection);
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
                            ...lectureQuestions.asMap().entries.map((entry) {
                              return EmojiFormField(
                                question: entry.value,
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
                                initialValues: emojiSelected,
                              );
                            }),
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
                            ...applicationsQuestions
                                .asMap()
                                .entries
                                .map((entry) {
                              return EmojiFormField(
                                question: entry.value,
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
                                initialValues: emojiSelected,
                              );
                            }),
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
                              S.of(context).feedbackHomeworkQuestion1,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: S.of(context).labelGrade,
                                prefixIcon: const Icon(Icons.grade_outlined),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                            ...homeworkQuestions.asMap().entries.map((entry) {
                              return EmojiFormField(
                                question: entry.value,
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
                                initialValues: emojiSelected,
                              );
                            }),
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
                            ...personalQuestions.asMap().entries.map((entry) {
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
                            }),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppScaffoldAction _submitButton() => AppScaffoldAction(
        text: 'Submit',
        onPressed: () async {
          if (!formKey.currentState.validate()) return;
        },
      );
}
