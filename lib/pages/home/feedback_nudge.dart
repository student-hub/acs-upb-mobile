import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/model/app_state.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackNudge extends StatefulWidget {
  @override
  _FeedbackNudgeState createState() => _FeedbackNudgeState();
}

class _FeedbackNudgeState extends State<FeedbackNudge> {
  Set<ClassHeader> userClasses;
  Map<String, dynamic> userClassesFeedbackProvided;
  String feedbackFormsLeft;

  // TODO(AndreiMirciu): Find a better approach on how to calculate the number of feedback forms that need to be completed
  Future<void> fetchInfo() async {
    final ClassProvider classProvider =
        Provider.of<ClassProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    userClasses =
        (await classProvider.fetchClassHeaders(uid: authProvider.uid)).toSet();
    userClassesFeedbackProvided = await feedbackProvider
        .getClassesWithCompletedFeedback(authProvider.uid);
    feedbackFormsLeft = await feedbackProvider.countClassesWithoutFeedback(
        authProvider.uid, userClasses);

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: feedbackFormsLeft != null && feedbackFormsLeft != '0',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: ActionChip(
          padding: const EdgeInsets.all(12),
          tooltip: S.current.navigationClassesFeedbackChecklist,
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () {
            Provider.of<AppStateProvider>(context, listen: false) //
                .userClasses = userClasses;
          },
          label: Row(
            children: [
              Expanded(
                // TODO(AndreiMirciu): Fix text wrapping property for both languages
                child: Text(
                  S.current.messageFeedbackLeft(feedbackFormsLeft),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: Theme.of(context).textTheme.subtitle2.fontSize,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
