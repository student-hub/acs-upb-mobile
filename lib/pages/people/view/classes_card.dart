import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/widgets/titled_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesCard extends StatefulWidget {
  const ClassesCard({
    @required this.lecturerName,
    Key key,
  }) : super(key: key);

  final String lecturerName;

  @override
  _ClassesCardState createState() => _ClassesCardState();
}

class _ClassesCardState extends State<ClassesCard> {
  List<String> classIds;

  @override
  void initState() {
    super.initState();

    final personProvider = Provider.of<PersonProvider>(context, listen: false);
    personProvider.currentClasses(widget.lecturerName).then((classes) {
      setState(() => classIds = classes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    return TitledCard(
      title: S.current.labelCourses,
      body: FutureBuilder(
        future: classProvider.fetchClassHeadersByIds(classIds),
        builder:
            (BuildContext context, AsyncSnapshot<Set<ClassHeader>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('N/A'));
          }
          final classHeaders = snapshot.data;

          return ClassList(
            classes: classHeaders,
            sectioned: false,
            onTap: (classHeader) => Navigator.of(context).push(
              MaterialPageRoute<ChangeNotifierProvider>(
                builder: (context) => ChangeNotifierProvider.value(
                  value: classProvider,
                  child: ClassView(
                    classHeader: classHeader,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
