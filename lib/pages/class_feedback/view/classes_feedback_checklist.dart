import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassesFeedbackChecklist extends StatefulWidget {
  const ClassesFeedbackChecklist({Key key, this.classes}) : super(key: key);
  final Set<ClassHeader> classes;

  @override
  _ClassesFeedbackChecklistState createState() =>
      _ClassesFeedbackChecklistState();
}

class _ClassesFeedbackChecklistState extends State<ClassesFeedbackChecklist> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationClassesFeedbackChecklist),
      actions: [],
      body: DataTable(
        columns: [
          const DataColumn(
            label: Text('Class name'),
            numeric: false,
            tooltip: 'Class name',
          ),
          const DataColumn(
            label: Text('Teacher name'),
            numeric: false,
            tooltip: 'Teacher name',
          )
        ],
        rows: widget.classes
            .map(
              (myClass) => DataRow(
                onSelectChanged: (selected) {
                  
                },
                cells: [
                  DataCell(
                    Text(myClass.name),
                  ),
                  DataCell(
                    Text(myClass.id),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
