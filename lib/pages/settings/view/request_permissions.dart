import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/feedback_question.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestPermissionsPage extends StatefulWidget {
  static const String routeName = '/requestPermissions';

  @override
  State<StatefulWidget> createState() => _RequestPermissionsPageState();
}

class _RequestPermissionsPageState extends State<RequestPermissionsPage> {
  final formKey = GlobalKey<FormState>();
  User user;
  bool agreedToResponsibilities = false;

  Map<String, Map<String, String>> questionCategories = {};
  Map<String, FormQuestion> requestQuestions = {};

  Future<void> _fetchUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = await authProvider.currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  AppDialog _requestAlreadyExistsDialog(BuildContext context) {
    return AppDialog(
      title: S.current.warningRequestExists,
      content: [
        Text(S.current.messageRequestAlreadyExists),
      ],
      actions: [
        AppButton(
            key: const ValueKey('agree_overwrite_request'),
            text: S.current.buttonSend,
            color: Theme.of(context).accentColor,
            width: 130,
            onTap: () async {
              await _sendRequest();
            }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    Provider.of<FeedbackProvider>(context, listen: false)
        .fetchCategories('permission_request_questions')
        .then((categories) => setState(() => questionCategories = categories));

    fetchFeedbackQuestions();
    _fetchUser();
  }

  Future<Map<String, dynamic>> fetchFeedbackQuestions() async {
    await Provider.of<FeedbackProvider>(context, listen: false)
        .fetchQuestions('permission_request_questions')
        .then((questions) => setState(() => requestQuestions = questions));
    return requestQuestions;
  }

  Future<void> _sendRequest() async {
    final requestProvider =
        Provider.of<FeedbackProvider>(context, listen: false);
    if (!agreedToResponsibilities) {
      AppToast.show(
          '${S.current.warningAgreeTo}${S.current.labelPermissionsConsent}.');
      return;
    }

    setState(() {
      formKey.currentState.save();
    });

    if (!formKey.currentState.validate()) return;
    for (int i = 0; i < requestQuestions.length; ++i) {
      if (requestQuestions.values.elementAt(i).answer == '') {
        AppToast.show(S.current.warningFieldCannotBeEmpty);
        Navigator.of(context).pop();
        return;
      }
    }

    final queryResult = await requestProvider.submitRequest(
      PermissionRequest(
        userId: user.uid,
        answers: requestQuestions,
      ),
    );
    if (queryResult) {
      AppToast.show(S.current.messageRequestHasBeenSent);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<FeedbackProvider>(context);
    final List<Widget> children = [];

    for (final category in questionCategories.keys.toList()..sort()) {
      final List<Widget> categoryChildren = [];
      for (final question
          in requestQuestions.values.where((q) => q.category == category)) {
        categoryChildren.add(
            FeedbackQuestionFormField(question: question, formKey: formKey));
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
          ],
        ),
      );
    }

    return AppScaffold(
        title: Text(S.current.navigationAskPermissions),
        actions: [
          AppScaffoldAction(
              text: S.current.buttonSave,
              onPressed: () async {
                final bool queryResult =
                    await requestProvider.userAlreadyRequested(user.uid);
                if (!queryResult) {
                  await _sendRequest();
                } else {
                  await showDialog(
                      context: context, builder: _requestAlreadyExistsDialog);
                  Navigator.pop(context);
                }
              })
        ],
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Image.asset('assets/illustrations/undxraw_hiring.png')),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: children),
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
                        S.current.messageAgreePermissions,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
