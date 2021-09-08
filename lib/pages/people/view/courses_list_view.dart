import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesListView extends StatefulWidget {
  const CoursesListView({@required this.lecturerName, Key key})
      : super(key: key);
  final String lecturerName;

  ClassHeader get classHeader => null;

  @override
  _CoursesListViewState createState() => _CoursesListViewState();
}

class _CoursesListViewState extends State<CoursesListView> {
  Future<List<String>> classList;
  String lecturerName;

  @override
  void initState() {
    super.initState();
    final personProvider = Provider.of<PersonProvider>(context, listen: false);
    classList = personProvider.currentClasses(lecturerName);
    print('$classList ${classList.runtimeType}');
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: classList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                Text(snapshot.data[index]);
              },
            );
          }
        },
        );
  }
}
