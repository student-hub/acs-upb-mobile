import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/classes_feedback_checklist.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackCard extends StatefulWidget {
  @override
  _FeedbackCardState createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  Set<ClassHeader> classes;
  Map<String, dynamic> classesFeedback;
  bool feedback;

  Future<void> getUserClasses() async {
    final ClassProvider classProvider =
        Provider.of<ClassProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    await classProvider
        .fetchClassHeaders(uid: authProvider.uid)
        .then((value) => setState(() => classes = value.toSet()));
    await feedbackProvider
        .getProvidedFeedbackClasses(authProvider.uid)
        .then((value) => setState(() => classesFeedback = value));

    await classProvider
        .getRemoteConfig()
        .then((value) => feedback = value.feedbackEnabled);
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
      visible: feedback != null &&
              feedback &&
              !(classes != null &&
                  classesFeedback != null &&
                  classes.length <= classesFeedback?.length) ??
          false,
      child: InfoCard<Map<String, dynamic>>(
        important: true,
        future: feedbackProvider.getProvidedFeedbackClasses(authProvider.uid),
        builder: (classesFeedback) {
          if (classes != null) {
            final String length = classes
                .where((element) => !classesFeedback.containsKey(element.id))
                .toSet()
                .length
                .toString();
            return GestureDetector(
              onTap: () {
                if (classes != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute<ClassFeedbackChecklist>(
                      builder: (_) =>
                          ClassFeedbackChecklist(classes: classes),
                    ),
                  );
                }
              },
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.current.messageReviewsLeft(length),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: Theme.of(context).textTheme.subtitle2.fontSize,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
