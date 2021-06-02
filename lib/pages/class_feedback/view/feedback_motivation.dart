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
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.asset('assets/illustrations/undraw_review.png'),
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
                const Text(
                  '1. Your data and privacy are respected.'
                      ' We do not report individual responses,'
                      ' but these are aggregated, thus an opinion cannot'
                      ' be associated with a particular profile.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '2. Information shared will be kept in our database for'
                      ' at least 4 years (study duration of a Bachelor\'s degree),'
                      ' so the evolution over time can be observed.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '3. Access to statistics is allowed to any student'
                      ' who wants to find out impressions about a class'
                      ' during the semester. However, while the opportunity to'
                      ' share your review is active, only students who have'
                      ' already expressed their opinion can analyze the ideas'
                      ' of others.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '4. The whole process of collecting and displaying reviews'
                      ' is transparent. Being an open-source application,'
                      ' source code is accessible to everyone.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '5. We are constantly looking to improve the connection'
                      ' between different generations of students. As a'
                      ' result, any thought is extremely value. All'
                      ' the details supplied are used pro-actively.',
                  style: TextStyle(
                    fontSize: 15,
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
