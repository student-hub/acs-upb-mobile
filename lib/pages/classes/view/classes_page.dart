import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/spoiler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesPage extends StatelessWidget {
  String sectionName(BuildContext context, String year, String semester) =>
      S.of(context).labelYear +
      ' ' +
      year +
      ', ' +
      S.of(context).labelSemester +
      ' ' +
      semester;

  Map<String, List<Class>> sections(List<Class> classes, BuildContext context) {
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
    ClassProvider classProvider = Provider.of<ClassProvider>(context);

    return AppScaffold(
      title: S.of(context).navigationClasses,
      body: FutureBuilder(
          future: classProvider.fetchClasses(),
          builder: (context, snap) {
            if (snap.hasData) {
              List<Class> classes = snap.data;
              var classSections = sections(classes, context);

              return Padding(
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
                                  children: <Widget>[Divider()] +
                                      classes
                                          .map<Widget>(
                                            (c) => Column(
                                              children: [
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    child: AutoSizeText(
                                                      c.acronym,
                                                      minFontSize: 5,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  title: Text(c.name +
                                                      (c.series == null
                                                          ? ''
                                                          : ' (' +
                                                              c.series +
                                                              ')')),
                                                ),
                                                Divider(),
                                              ],
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
              );
            } else if (snap.hasError) {
              print(snap.error);
              // TODO: Show error toast
              return Container();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
