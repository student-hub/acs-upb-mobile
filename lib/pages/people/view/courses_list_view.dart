import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoursesListView extends StatelessWidget {
  const CoursesListView({@required this.lecturerName, Key key})
      : super(key: key);
  final String lecturerName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_questions')
          // TODO(RazvanRotaru): Filter documents by lecturer name/id
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Center(
                    child: Text(
                      // TODO(RazvanRotaru): Get course name
                      snapshot.data['name'],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
