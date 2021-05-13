import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
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
  String filter = '';
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
            onSearch: (searchText) => {setState(() => filter = searchText)},
            cancelCallback: () => {setState(() => filter = '')},
            searchClosed: false,
          ),
          if(filter.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text(
                S.current.labelPeople,
                style: const TextStyle(fontSize: 15),
              ),
          ),
          FutureBuilder(
            future: Provider.of<PersonProvider>(context, listen: false)
                .search(filter),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                peopleSearched = snapshot.data;
              }
              return PeopleCircleList(
                people: peopleSearched,
                filter: filter,
              );
            },
          ),
          const Divider(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class PeopleCircleList extends StatelessWidget {
  const PeopleCircleList({this.people, this.filter});

  final List<Person> people;
  final String filter;

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) {
      return Container(
        height: 200,
        child: const Text('Nothing found'),//for debugging
      );
    }
    return Container(
      height: 120,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: people.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final List<String> name = people[index].name.split(' ');
          return Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Column(
                  children: <Widget>[
                    const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://identix.state.gov/qotw/images/no-photo.gif'),
                    ),
                    for(String n in name)
                      Text(n),
                ]
              )
          );
        },
      ),
    );
  }
}
