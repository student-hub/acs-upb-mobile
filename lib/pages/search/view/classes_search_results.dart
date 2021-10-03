import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/navigator.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/search/view/seached_classes_view.dart';
import 'package:acs_upb_mobile/widgets/class_icon.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesSearchResults extends StatelessWidget {
  const ClassesSearchResults({this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    List<ClassHeader> classesSearched;
    return FutureBuilder(
        future:
            Provider.of<ClassProvider>(context, listen: false).search(query),
        builder: (_, snapshot) {
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
                                AppNavigator.push(
                                    context,
                                    MaterialPageRoute<SearchedClassesView>(
                                      builder: (_) => SearchedClassesView(
                                        classHeaders: classesSearched,
                                      ),
                                    ),
                                    webPath:
                                        '${SearchedClassesView.routeName}?ids='
                                        '${classesSearched.map((classSearched) => '${classSearched.id}').join('&')}');
                              },
                              child: Text(
                                S.current.actionShowMore,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.blue),
                              ),
                            ),
                          ),
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: classHeaders.take(3).map(
          (classHeader) {
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: GestureDetector(
                child: Row(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: CircleAvatar(
                        backgroundColor: classHeader.colorFromAcronym,
                        child: Container(
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
                onTap: () {
                  final currentUser =
                      Provider.of<AuthProvider>(context, listen: false)
                          .currentUserFromCache;
                  if (currentUser != null) {
                    AppNavigator.push(
                        context,
                        MaterialPageRoute<ClassView>(
                          builder: (_) => ClassView(classHeader: classHeader),
                        ),
                        webPath: '${ClassView.routeName}?id=${classHeader.id}');
                  } else {
                    AppToast.show(S.current.warningAuthenticationNeeded);
                  }
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
