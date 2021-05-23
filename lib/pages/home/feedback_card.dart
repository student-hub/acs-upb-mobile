import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:provider/provider.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({Key key, this.onShowMore, this.classes}) : super(key: key);
  final void Function() onShowMore;
  final Set<ClassHeader> classes;

  @override
  Widget build(BuildContext context) {
    final feedbackProvider =
    Provider.of<FeedbackProvider>(context, listen: true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return InfoCard<Map<String, dynamic>>(
      title: S.current.navigationClassFeedback,
      onShowMore: onShowMore,
      future: feedbackProvider
          .getProvidedFeedbackClasses(authProvider.uid),
      builder: (classesFeedback) {
        final String length = classes
            .where((element) => !classesFeedback.containsKey(element.id))
            .toSet().length.toString();
        return Text('You need to complete $length more feedback forms!');
      },
    );
  }
}
