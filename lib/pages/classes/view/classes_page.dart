import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/spoiler.dart';
import 'package:flutter/material.dart';

class ClassesPage extends StatelessWidget {
  String sectionName(BuildContext context, String year, String semester) =>
      S.of(context).labelYear +
      ' ' +
      year +
      ', ' +
      S.of(context).labelSemester +
      ' ' +
      semester;

  Map<String, List<Class>> sections(BuildContext context) {
    List<Class> classes = [
      Class(
        name: 'Matematică 1',
        acronym: 'M1',
        year: '1',
        semester: '1',
      ),
      Class(
        name: 'Programarea Calculatoarelor',
        acronym: 'PC',
        year: '1',
        semester: '1',
      ),
      Class(
        name: 'Matematică 3',
        acronym: 'M3',
        year: '1',
        semester: '2',
      ),
    ];
    Map<String, List<Class>> classSections = {};
    for (var year in ['1', '2', '3', '4']) {
      for (var semester in ['1', '2']) {
        classSections[sectionName(context, year, semester)] = [];
      }
    }
    classes.forEach((c) {
      classSections[sectionName(context, c.year, c.semester)].add(c);
    });
    return classSections;
  }

  @override
  Widget build(BuildContext context) {
    var classSections = sections(context);

    return AppScaffold(
      title: S.of(context).navigationClasses,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: classSections
              .map((sectionName, classes) => MapEntry(
                  sectionName,
                  Column(
                    children: [
                      AppSpoiler(
                        title: sectionName,
                        content: Column(
                          children: classes
                              .map<Widget>(
                                (c) => ListTile(
                                  leading: CircleAvatar(
                                    child: Text(c.acronym),
                                  ),
                                  title: Text(c.name),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  )))
              .values
              .toList(),
        ),
      ),
    );
  }
}
