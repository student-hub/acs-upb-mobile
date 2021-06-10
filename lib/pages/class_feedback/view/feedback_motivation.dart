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
                  'Share your experience so future generations of students will receive statistics about this class!',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Key aspects we take into account:',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      const TextSpan(
                        text: '1. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: S.current.messageFeedbackMotivation1),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      const TextSpan(
                        text: '2. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: S.current.messageFeedbackMotivation2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      const TextSpan(
                        text: '3. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: S.current.messageFeedbackMotivation3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      const TextSpan(
                        text: '4. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: S.current.messageFeedbackMotivation4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      const TextSpan(
                        text: '5. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
