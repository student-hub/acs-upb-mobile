import 'package:acs_upb_mobile/pages/chatbot/view/chat_page.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/search/view/seached_classes_view.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/search_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  List<ClassHeader> classesSearched;
  bool searchClosed = true;
  List<Person> peopleSearched;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationSearch),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SearchWidget(
            onSearch: (searchText) => {setState(() => query = searchText)},
            cancelCallback: () => {setState(() => query = '')},
            searchClosed: false,
          ),
          if (query.isNotEmpty)
            FutureBuilder(
                future: Provider.of<PersonProvider>(context, listen: false)
                    .search(query),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    peopleSearched = snapshot.data;
                    if (peopleSearched.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Text(
                              S.current.labelPeople,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          PeopleCircleList(
                            people: peopleSearched,
                            query: query,
                          )
                        ],
                      );
                    }
                    return Container();
                  } else {
                    return Container();
                  }
                }),
          const Divider(
            color: Colors.white,
          ),
          if (query.isNotEmpty)
            FutureBuilder(
                future: Provider.of<ClassProvider>(context, listen: false)
                    .search(query),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    classesSearched = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (classesSearched.isNotEmpty)
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Row(
                                children: [
                                  Text(S.current.labelClasses,
                                      style: const TextStyle(fontSize: 15)),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute<
                                                  SearchedClassesView>(
                                              builder: (_) =>
                                                  SearchedClassesView(
                                                    classesHeader:
                                                        classesSearched,
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
                        ClassesCircleList(
                            classesHeader: classesSearched, query: query)
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          if (query.isNotEmpty)
            Container(
                child: Column(
              children: [
                const Image(
                  image:
                      AssetImage('assets/illustrations/undraw_chat_image.png'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(S.current.messageAnotherQuestion)),
                      GestureDetector(
                        child: Text(
                          S.current.messageTalkToChatbot,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute<ChatPage>(
                          builder: (_) => ChatPage(),
                        )),
                      )
                    ],
                  ),
                )
              ],
            ))
        ],
      ),
    );
  }
}

class PeopleCircleList extends StatelessWidget {
  const PeopleCircleList({this.people, this.query});

  final List<Person> people;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.headline4.fontSize * 1.1 + 80.0,
      ),
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: people.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final List<String> name = people[index].name.split(' ');
          return Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet<dynamic>(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext buildContext) => PersonView(
                            person: people[index],
                          ));
                },
                child: Column(children: <Widget>[
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://identix.state.gov/qotw/images/no-photo.gif'),
                  ),
                  for (String n in name) Text(n),
                ]),
              ));
        },
      ),
    );
  }
}

class ClassesCircleList extends StatelessWidget {
  const ClassesCircleList({this.classesHeader, this.query});

  final List<ClassHeader> classesHeader;
  final String query;

  @override
  Widget build(BuildContext context) {
    if (classesHeader.isNotEmpty) {
      final int nr = classesHeader.length > 3 ? 3 : classesHeader.length;
      return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              for (int i = 0; i < nr; i++)
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: GestureDetector(
                        child: Row(children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Container(
                                  width: 30,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      classesHeader[i].acronym,
                                      minFontSize: 0,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                            child: Text(classesHeader[i].name),
                          )
                        ]),
                        onTap: () => {
                              Navigator.of(context)
                                  .push(MaterialPageRoute<ClassView>(
                                builder: (_) =>
                                    ClassView(classHeader: classesHeader[i]),
                              ))
                            }))
            ],
          )
//      child: ListView.builder(
//        shrinkWrap: true,
//        itemCount: classesHeader.length > 5 ? 5 : classesHeader.length,
//        scrollDirection: Axis.vertical,
//        itemBuilder: (BuildContext context, int index) {
//          return Container(
//            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
//            child: GestureDetector(
//              child: Row(children: <Widget>[
//                 Padding(
//                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
//                  child: CircleAvatar(
//                    backgroundColor: Colors.grey,
//                    child: Container(
//                      width: 30,
//                      child: Align(
//                        alignment: Alignment.center,
//                        child: AutoSizeText(
//                          classesHeader[index].acronym,
//                          minFontSize: 0,
//                          maxLines: 1,
//                        ),
//                      ),
//                    ),
//                  )
//                ),
//                //TODO Solve pixel overflow
//                Expanded(
//                  child: Text(classesHeader[index].name),
//                )
//              ]),
//              onTap: () => {
//                Navigator.of(context).push(
//                    MaterialPageRoute<ClassView>(
//                      builder: (_) => ClassView(
//                        classHeader: classesHeader[index]
//                      ),
//                    )
//                )
//              }
//            )
//          );
//        }
//      ),
          );
    } else {
      return Container();
    }
  }
}
