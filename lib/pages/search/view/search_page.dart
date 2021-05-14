import 'package:acs_upb_mobile/pages/classes/model/class.dart';
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
  List<Class> classesSearched;
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
                }),
          const Divider(
            color: Colors.white,
          ),
          Container(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text('Materii',
                      style: const TextStyle(fontSize: 15)
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://image.shutterstock.com/shutterstock/photos/488719804/display_1500/stock-photo-the-training-icon-teacher-and-learner-classroom-presentation-conference-lesson-seminar-488719804.jpg'),
                            ),
                            const Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Text(
                                    'Managementul Proiectelor Software')),
                          ]
                      ),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://image.shutterstock.com/shutterstock/photos/488719804/display_1500/stock-photo-the-training-icon-teacher-and-learner-classroom-presentation-conference-lesson-seminar-488719804.jpg'),
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Text(
                                  'Programare Orientata pe Obiecte')),
                        ]
                    )
                  ],
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
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
    if (people.isEmpty) {
      return Container(
        height: 50,
        child: const Text('Nothing found'), //for debugging
      );
    }
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
