import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/issue.dart';
import 'package:acs_upb_mobile/pages/settings/service/issue_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/resources/theme.dart';

class FeedbackFormPage extends StatefulWidget {
  static const String routeName = '/feedbackForm';

  @override
  _FeedbackFormPageState createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController issueEmailController = TextEditingController();
  TextEditingController issueController = TextEditingController();
  bool _issueSelected = false;
  bool _feedbackSelected = true;

  @override
  Widget build(BuildContext context) {
    final issueProvider = Provider.of<IssueProvider>(context);

    return Form(
        key: _formKey,
        child: AppScaffold(
          title: Text('Feedback'),
          actions: [
            AppScaffoldAction(
              text: 'Submit',
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, it displays a snackbar and saves the
                  // information in the cloud
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  issueProvider.makeIssue(
                    Issue(
                        email: issueEmailController.text,
                        issueBody: issueController.text,
                        type: _feedbackSelected ? 'feedback' : 'issue'),
                  );
                }
              },
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image.asset(
                        'assets/illustrations/undraw_feedbackform.png')),
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: Text(
                      'Feedback',
                      style: Theme.of(context).chipTextStyle(selected: true),
                    ),
                    selected: _feedbackSelected,
                    onSelected: (selected) => setState(() {
                      _feedbackSelected = true;
                      if (selected) {
                        _issueSelected = false;
                      }
                    }),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Text(
                      'Issue',
                      style: Theme.of(context).chipTextStyle(selected: true),
                    ),
                    selected: _issueSelected,
                    onSelected: (selected) => setState(() {
                      _issueSelected = true;
                      if (selected) {
                        _feedbackSelected = false;
                      }
                    }),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              TextFormField(
                controller: issueEmailController,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'example: john.doe123@gmail.com',
                  prefixIcon: const Icon(Icons.label_outlined),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
              ),
              TextFormField(
                controller: issueController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: _feedbackSelected ? 'Feedback' : 'Issue',
                  hintText: _feedbackSelected ? 'Feedback' : 'Issue',
                  prefixIcon: const Icon(Icons.label_outlined),
                ),
              ),
            ],
          ),
        ));
  }
}
