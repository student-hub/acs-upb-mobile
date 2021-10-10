import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class FeedbackMotivation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationFeedbackMotivation),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3.3,
                    child:
                        Image.asset('assets/illustrations/undraw_review.png'),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  S.current.messageFeedbackMotivationOverview,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  S.current.messageFeedbackAspects,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Icon(
                    Icons.data_usage_outlined,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(text: S.current.messageFeedbackMotivation1),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Icon(
                    Icons.timeline_outlined,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(
                        text: S.current.messageFeedbackMotivation2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Icon(
                    Icons.bar_chart_outlined,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(
                        text: S.current.messageFeedbackMotivation3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Icon(
                    Icons.accessibility_new_outlined,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(
                        text: S.current.messageFeedbackMotivation4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Icon(
                    Icons.emoji_objects_outlined,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(
                        text: S.current.messageFeedbackMotivation5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
