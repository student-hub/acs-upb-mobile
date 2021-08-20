import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/pages/settings/model/issue.dart';
import 'package:acs_upb_mobile/pages/settings/service/issue_provider.dart';
import 'package:acs_upb_mobile/pages/settings/service/request_provider.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackFormPage extends StatefulWidget {
  static const String routeName = '/feedbackForm';

  @override
  _FeedbackFormPageState createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController issueEmailController = TextEditingController();
  TextEditingController issueController = TextEditingController();

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
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Processing Data')));
              issueProvider.makeIssue(
                Issue(
                  email: issueEmailController.text,
                  issueBody: issueController.text,
                ),
              );
            }
          },
        ),
        ],
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: Text(''),
            //       ),
            //     Expanded(
            //       flex: 25,
            //       child: Text(
            //         "Email",
            //         style: Theme.of(context).textTheme.headline6,
            //       ),
            //     ),
            //   ],
            // ),
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
            // ListTile(
            //   title: Text('Feedback'),
            // ),
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
                labelText: 'Feedback',
                hintText: 'Feedback',
                prefixIcon: const Icon(Icons.label_outlined),
              ),
              // maxLines: 8,
              // decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
            ),
          ],
        ),
      )
    );
  }
}


// class FeedbackFormPage extends StatefulWidget {
//   static const String routeName = '/feedbackForm';
//
//   @override
//   State<StatefulWidget> createState() => _FeedbackFormPageState();
// }
//
// class _FeedbackFormPageState extends State<FeedbackFormPage>{
//
// }

// class FeedbackFormPage extends StatelessWidget{
//   static const String routeName = '/feedbackForm';
//   const FeedbackFormPage({this.tabController, Key key}) : super(key: key);
//
//   final TabController tabController;
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//
//     return AppScaffold(
//       title: Text(S.current.navigationHome),
//       actions: [
//         AppScaffoldAction(
//           icon: Icons.settings_outlined,
//           tooltip: S.current.navigationSettings,
//           route: Routes.settings,
//         )
//       ],
//       body: ListView(
//         children: [
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
// }
