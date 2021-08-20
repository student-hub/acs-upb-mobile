import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/widgets/autocomplete.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Autocomplete;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key key}) : super(key: key);

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  String filter = '';
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
      actions: [
        AppScaffoldAction(
          icon: Icons.search_outlined,
          onPressed: () {
            setState(() => searchClosed = !searchClosed);
          },
          tooltip: S.current.actionSearch
        )
      ],
      title: Text(S.current.navigationPeople),
      body: FutureBuilder(
          future: people,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              peopleData = snapshot.data;
              return Column(
                children: [
                  SearchWidget(
                    onSearch: (searchText) {
                      setState(() => filter = searchText);
                    },
                    cancelCallback: () {
                      setState(() {
                        searchClosed = true;
                        filter = '';
                      });
                    },
                    searchClosed: searchClosed,
                  ),
                  Expanded(
                    child: PeopleList(people: filteredPeople, filter: filter),
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  List<Person> get filteredPeople => peopleData
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

class PeopleList extends StatefulWidget {
  const PeopleList({this.people, this.filter});

  final List<Person> people;
  final String filter;

  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  @override
  Widget build(BuildContext context) {
    final List<String> filteredWords = widget.filter
        .toLowerCase()
        .split(' ')
        .where((element) => element != '')
        .toList();

    widget.people.sort((p1, p2) {
      final cmpLast = p1.lastName.compareTo(p2.lastName);
      if (cmpLast != 0) {
        return cmpLast;
      }
      return p1.name.compareTo(p2.name);
    });

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.people.length,
      itemBuilder: (context, index) {
        return ListTile(
          key: ValueKey(widget.people[index].name),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              widget.people[index].photo,
            ),
          ),
          title: filteredWords.isNotEmpty
              ? DynamicTextHighlighting(
                  text: widget.people[index].name,
                  style: Theme.of(context).textTheme.subtitle1,
                  highlights: filteredWords,
                  color: Theme.of(context).accentColor,
                  caseSensitive: false,
                )
              : Text(
                  widget.people[index].name,
                ),
          subtitle: Text(widget.people[index].email),
          onTap: () => kIsWeb
              ? showPersonPage(widget.people[index].name)
              : showPersonInfo(widget.people[index]),
        );
      },
    );
  }

  void showPersonInfo(Person person) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext buildContext) => PersonView(person: person),
    );
  }

  void showPersonPage(String name) {
    Navigator.pushNamed(context, '/people?profile=$name');
  }
}

class AutocompletePerson extends StatefulWidget {
  const AutocompletePerson(
      {@required this.labelText,
      @required this.classTeachers,
      Key key,
      this.warning,
      this.formKey,
      this.onSaved,
      this.personDisplayed})
      : super(key: key);

  final String labelText;
  final String warning;
  final GlobalKey<FormState> formKey;
  final List<Person> classTeachers;
  final Person Function(Person) onSaved;
  final Person personDisplayed;

  @override
  _AutocompletePersonState createState() => _AutocompletePersonState();
}

class _AutocompletePersonState extends State<AutocompletePerson> {
  Person selectedPerson;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Person>(
      key: widget.key,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        textEditingController.text = selectedPerson?.name;
        if (selectedPerson == null) {
          textEditingController.text = widget.personDisplayed?.name;
        }
        return TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: const Icon(FeatherIcons.user),
          ),
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          validator: (_) {
            if (textEditingController.text.isEmpty ?? true) {
              return widget.warning;
            }
            return null;
          },
        );
      },
      displayStringForOption: (Person person) => person.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '' || textEditingValue.text.isEmpty) {
          return const Iterable<Person>.empty();
        }
        if (widget.classTeachers.where((Person person) {
          return person.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        }).isEmpty) {
          final List<Person> inputTeachers = [];
          final Person inputTeacher =
              Person(name: textEditingValue.text.titleCase);
          inputTeachers.add(inputTeacher);
          return inputTeachers;
        }

        return widget.classTeachers.where((Person person) {
          return person.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (Person selection) {
        widget.formKey.currentState.validate();
        setState(() {
          selectedPerson = selection;
          widget.onSaved(selectedPerson);
        });
      },
    );
  }
}
