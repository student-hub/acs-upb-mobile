import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/classes_feedback_checklist.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackNudge extends StatefulWidget {
  @override
  _FeedbackNudgeState createState() => _FeedbackNudgeState();
}

class _FeedbackNudgeState extends State<FeedbackNudge> {
  Set<ClassHeader> userClasses;
  Map<String, dynamic> userClassesFeedbackProvided;

  Future<void> getUserClasses() async {
    final ClassProvider classProvider =
        Provider.of<ClassProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    await classProvider
        .fetchClassHeaders(uid: authProvider.uid)
        .then((value) => setState(() => userClasses = value.toSet()));
    await feedbackProvider
        .getProvidedFeedbackClasses(authProvider.uid)
        .then((value) => setState(() => userClassesFeedbackProvided = value));
  }

  @override
  void initState() {
    super.initState();
    getUserClasses();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);

    return Visibility(
      visible: Utils.feedbackEnabled &&
              !(userClasses != null &&
                  userClassesFeedbackProvided != null &&
                  userClasses.length <= userClassesFeedbackProvided?.length) ??
          false,
      child: InfoCard<Map<String, dynamic>>(
        future: feedbackProvider.getProvidedFeedbackClasses(authProvider.uid),
        builder: (classesFeedback) {
          if (userClasses != null) {
            final String length = userClasses
                .where((element) => !classesFeedback.containsKey(element.id))
                .toSet()
                .length
                .toString();
            return GestureDetector(
              onTap: () {
                if (userClasses != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute<ClassFeedbackChecklist>(
                      builder: (_) =>
                          ClassFeedbackChecklist(classes: userClasses),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.messageReviewsLeft(length),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: Theme.of(context).textTheme.subtitle2.fontSize,
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
