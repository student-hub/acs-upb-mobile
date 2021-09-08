import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/widgets/titled_card.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
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
  List<String> classes;

  @override
  void initState() {
    super.initState();
    final PersonProvider personProvider =
        Provider.of<PersonProvider>(context, listen: false);

    personProvider
        .currentClasses(widget.lecturerName)
        .then((currentClasses) => setState(() => classes = currentClasses));
  }

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: S.current.labelCourses,
      body: Column(
        children: classes != null
            ? classes.map((className) => Text(className)).toList()
            : const [Text('None')],
      ),
    );
  }
}
