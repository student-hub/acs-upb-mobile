import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/issue.dart';
import 'package:acs_upb_mobile/pages/settings/service/issue_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
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
          title: Text(S.current.labelFeedback),
          actions: [
            AppScaffoldAction(
              text: S.current.buttonSend,
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, it displays a toast and saves the
                  // information in the cloud
                  AppToast.show(S.current.messageProcessingData);
                  issueProvider.makeIssue(
                    Issue(
                        email: issueEmailController.text,
                        issueBody: issueController.text,
                        type: _feedbackSelected
                            ? S.current.labelFeedback
                            : S.current.labelIssue),
                  );
                }
              },
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Container(
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
                    key: const ValueKey('choice_issue'),
                    label: Text(
                      S.current.labelIssue,
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
                key: const ValueKey('issue'),
                controller: issueController,
                validator: (value) {
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
                      ? S.current.feedbackExample
                      : S.current.issueExample,
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
                validator: (value) {
                  if (value == null) {
                    return S.current.warningFieldCannotBeEmpty;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.current.labelContactInfoOptional,
                  helperText: S.current.helperContactInfo,
                  helperStyle: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w300),
                  hintText: S.current.emailExample,
                  prefixIcon: const Icon(Icons.alternate_email_outlined),
                ),
              ),
            ],
          ),
        ));
  }
}
