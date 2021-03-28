import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

import 'form_field.dart';

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

  List<int> _feedbackValue = [];
  List<bool> _isFormFieldComplete = [];
  List<String> involvementPercentages = [];
  String selectedInvolvement;

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
  }

  void _handleRadioButton(int group, int value) {
    setState(() {
      _feedbackValue[group] = value;
      _isFormFieldComplete[group] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);

    final generalQuestions = [
      S.of(context).feedbackGeneralQuestion1,
      S.of(context).feedbackGeneralQuestion3,
      S.of(context).feedbackGeneralQuestion4
    ];

    for (int i = 0; i < generalQuestions.length; ++i) {
      _feedbackValue.add(-1);
      _isFormFieldComplete.add(false);
    }

    return AppScaffold(
      title: Text(S.of(context).navigationClassFeedback),
      actions: [_submitButton()],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                      children: [
                    TextFormField(
                      enabled: false,
                      controller: classController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelClass,
                        prefixIcon: const Icon(Icons.class_),
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
                              prefixIcon: const Icon(Icons.person),
                            ),
                            onChanged: (_) => setState(() {}),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: S.of(context).labelAssistant,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
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
                        prefixIcon: const Icon(Icons.grade),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
                  ]
                        ..addAll(
                          generalQuestions.asMap().entries.map((entry) {
                            return FeedbackFormField(
                              id: entry.key + 1,
                              question: entry.value,
                              groupValue: _feedbackValue[entry.key],
                              radioHandler: (int value) =>
                                  _handleRadioButton(entry.key, value),
                              error: _isFormFieldComplete[entry.key]
                                  ? S
                                      .of(context)
                                      .warningYouNeedToSelectAtLeastOne
                                  : null,
                            );
                          }),
                        )
                        ..addAll([
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
                              prefixIcon: const Icon(Icons.local_activity),
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
                          const SizedBox(height: 24),
                          Text(
                            S.of(context).uniEventTypeLecture,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            S.of(context).sectionApplications,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            S.of(context).uniEventTypeHomework,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            S.of(context).sectionPersonalComments,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            S.of(context).feedbackPersonalQuestion1,
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
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            S.of(context).feedbackPersonalQuestion2,
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
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            S.of(context).feedbackPersonalQuestion3,
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
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            S.of(context).feedbackPersonalQuestion4,
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
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])),
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
