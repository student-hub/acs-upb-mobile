import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/search_bar.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  String filter = '';
  List<Class> classesSearched;
  bool searchClosed = true;
  Future<List<Person>> people;
  List<Person> peopleData;

  @override
  void initState() {
    super.initState();
    final personProvider = Provider.of<PersonProvider>(context, listen: false);
    people = personProvider.fetchPeople();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationSearch),
      body: ListView(
          children: [
            SearchWidget(
            onSearch: (searchText) => {
              setState(() => filter = searchText)
            },
            cancelCallback: () =>{
              setState(() => filter = '')
            },
            searchClosed: false,
          ),
            FutureBuilder(
              future: people,
              builder: (_, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  peopleData = snapshot.data;
                }
                return PeopleCircleList(
                  people: searchedPeople,
                  filter: filter,
                );
              },
            )
          ],
        ),
    );
  }
  List<Person> get searchedPeople => peopleData
      .where((person) => filter
      .split(' ')
      .where((element) => element != '')
      .fold(
      true,
          (previousValue, filter) =>
      previousValue &&
          person.name.toLowerCase().contains(filter.toLowerCase())))
      .toList();
}
class PeopleCircleList extends StatefulWidget{

  const PeopleCircleList({this.people, this.filter});

  final List<Person> people;
  final String filter;

  @override
  _PeopleCircleListState createState() => _PeopleCircleListState();
}

class _PeopleCircleListState extends State<PeopleCircleList> {
  @override
  Widget build(BuildContext context) {
    final List<String> filteredWords = widget.filter
        .toLowerCase()
        .split(' ')
        .where((element) => element != '')
        .toList();
    return ListView.builder(
      itemCount: widget.people.length,
      itemBuilder: (BuildContext context, int index){
        return const ListTile(
          title: Text('abc '),
        );
      }
    );
  }
}