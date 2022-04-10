import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../resources/theme.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../model/issue.dart';
import '../service/issue_provider.dart';

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
  Widget build(final BuildContext context) {
    final issueProvider = Provider.of<IssueProvider>(context);

    return Form(
        key: _formKey,
        child: AppScaffold(
          title: Text(S.current.labelFeedback),
          actions: [
            AppScaffoldAction(
              text: S.current.buttonSend,
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, submit the report
                  final result = await issueProvider.makeIssue(
                    Issue(
                        email: issueEmailController.text,
                        issueBody: issueController.text,
                        type: _feedbackSelected
                            ? S.current.labelFeedback
                            : S.current.labelIssue),
                  );
                  if (result) {
                    AppToast.show(S.current.messageReportSent);
                  } else {
                    AppToast.show(S.current.messageReportNotSent);
                  }
                  // Return to settings page
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image.asset(
                        'assets/illustrations/undraw_feedbackform.png')),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(FeatherIcons.filter,
                            color: Theme.of(context).formIconColor),
                        const SizedBox(width: 12),
                        Text(
                          S.current.labelReportType,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  ChoiceChip(
                    key: const ValueKey('choice_feedback'),
                    label: Text(
                      S.current.labelFeedback,
                      style: Theme.of(context)
                          .chipTextStyle(selected: _feedbackSelected),
                    ),
                    selected: _feedbackSelected,
                    onSelected: (final selected) => setState(() {
                      _feedbackSelected = true;
                      if (selected) {
                        _issueSelected = false;
                      }
                    }),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    key: const ValueKey('choice_issue'),
                    label: Text(
                      S.current.labelIssue,
                      style: Theme.of(context)
                          .chipTextStyle(selected: _issueSelected),
                    ),
                    selected: _issueSelected,
                    onSelected: (final selected) => setState(() {
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
                key: const ValueKey('issue'),
                controller: issueController,
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return S.current.warningFieldCannotBeEmpty;
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: _feedbackSelected
                      ? S.current.labelFeedback
                      : S.current.labelIssue,
                  hintText: _feedbackSelected
                      ? S.current.hintFeedback
                      : S.current.hintIssue,
                  prefixIcon: const Icon(Icons.message_outlined),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
              ),
              TextFormField(
                key: const ValueKey('contact'),
                controller: issueEmailController,
                // The validator receives the text that the user has entered.
                validator: (final value) {
                  if (value == null || value == '') {
                    return S.current.warningFieldCannotBeEmpty;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.current.labelContactInfoOptional,
                  helperText: S.current.infoContactInfo,
                  helperStyle: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w300),
                  hintText: S.current.hintFullEmail,
                  prefixIcon: const Icon(Icons.alternate_email_outlined),
                ),
              ),
            ],
          ),
        ));
  }
}
