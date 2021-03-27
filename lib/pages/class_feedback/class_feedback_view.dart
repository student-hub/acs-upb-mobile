import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool agreedToResponsibilities = false;

  @override
  void initState() {
    super.initState();

    classController =
        TextEditingController(text: widget.classHeader?.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);

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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                      TextFormField(
                        enabled: false,
                        controller:
                            TextEditingController(text: 'First question'),
                      ),
                      TextFormField(
                        enabled: false,
                        controller:
                            TextEditingController(text: 'First question'),
                      ),
                      TextFormField(
                        enabled: false,
                        controller:
                            TextEditingController(text: 'First question'),
                      ),
                      TextFormField(
                        enabled: false,
                        controller:
                            TextEditingController(text: 'First question'),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        S.of(context).sectionPersonalComments,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
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
        text: 'Submit',
        onPressed: () async {
          if (!formKey.currentState.validate()) return;
        },
      );
}
