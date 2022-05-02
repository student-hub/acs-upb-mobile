import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/class_icon.dart';
import '../../classes/model/class.dart';
import '../../classes/service/class_provider.dart';
import '../../classes/view/class_view.dart';
import 'seached_classes_view.dart';

class ClassesSearchResults extends StatelessWidget {
  const ClassesSearchResults({this.query});

  final String query;

  @override
  Widget build(final BuildContext context) {
    List<ClassHeader> classesSearched;
    return FutureBuilder(
        future:
            Provider.of<ClassProvider>(context, listen: false).search(query),
        builder: (final _, final snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              query.isNotEmpty) {
            classesSearched = snapshot.data;
            if (classesSearched.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Row(
                        children: [
                          Text(S.current.labelClasses,
                              style: const TextStyle(fontSize: 15)),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute<SearchedClassesView>(
                                      builder: (final _) => SearchedClassesView(
                                            classHeaders: classesSearched,
                                            query: query,
                                          )));
                            },
                            child: Text(
                              S.current.actionShowMore,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.blue),
                            ),
                          ))
                        ],
                      )),
                  ClassesCircleList(classHeaders: classesSearched)
                ],
              );
            }
          }
          return Container();
        });
  }
}

class ClassesCircleList extends StatelessWidget {
  const ClassesCircleList({this.classHeaders});

  final List<ClassHeader> classHeaders;

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
            children: classHeaders
                .take(3)
                .map((final classHeader) => Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: GestureDetector(
                        child: Row(children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: CircleAvatar(
                                backgroundColor: classHeader.colorFromAcronym,
                                child: SizedBox(
                                  width: 30,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      classHeader.acronym,
                                      minFontSize: 0,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                            child: Text(classHeader.name),
                          )
                        ]),
                        onTap: () => {
                              Navigator.of(context)
                                  .push(MaterialPageRoute<ClassView>(
                                builder: (final _) =>
                                    ClassView(classHeader: classHeader),
                              ))
                            })))
                .toList()));
  }
}
