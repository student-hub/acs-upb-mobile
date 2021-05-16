import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/search_bar.dart';
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (peopleSearched.isNotEmpty)
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
                  } else {
                    return Container();
                  }
                }
                ),
          const Divider(
            color: Colors.white,
          ),
          if (query.isNotEmpty)
            FutureBuilder(
            future:  Provider.of<ClassProvider>(context, listen: false)
              .search(query),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                classesSearched = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(classesSearched.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Text('Materii',
                          style: TextStyle(fontSize: 15)
                          ),
                        ),
                      ClassesCircleList(
                        classesHeader:classesSearched,
                        query: query)
                  ],
                );
              }
              else {
                return Container();
              }
            }
            ),
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
      height: 130,
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
                      builder: (BuildContext buildContext) =>
                          PersonView(
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
    if (classesHeader.isEmpty) {
      return Container(
        height: 50,
        child: const Text('Nothing found'), //for debugging
      );
    }
    return Container(
      height: 1000,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: classesHeader.length > 5 ? 5 : classesHeader.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: GestureDetector(
              child: Row(children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://identix.state.gov/qotw/images/no-photo.gif'),
                  ),
                ),
                //TODO Solve pixel overflow
                Text(classesHeader[index].name)
              ]),
//              onTap: (classHeader) => Navigator.of(context)
//                  .push(MaterialPageRoute<ChangeNotifierProvider>(
//                builder: (context) => ChangeNotifierProvider.value(
//                  value: classProvider,
//                  child: ClassView(classHeader: classHeader),
//                ),
//              )),
            )
          );
        }
      ),
    );
  }
}
