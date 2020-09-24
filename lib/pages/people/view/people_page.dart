import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeoplePage extends StatefulWidget {
  PeoplePage({Key key}) : super(key: key);

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  Future<List<Person>> people;

  @override
  void initState() {
    super.initState();
    PersonProvider personProvider =
        Provider.of<PersonProvider>(context, listen: false);
    people = personProvider.fetchPeople(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.of(context).navigationPeople),
      body: Container(
        child: FutureBuilder(
            future: people,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Person> peopleData = snapshot.data;
                return ListView.builder(
                    itemCount: peopleData.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(peopleData[index].photo),
                        ),
                        title: Text(peopleData[index].name),
                        subtitle: Text(peopleData[index].email),
                        onTap: () => showPersonInfo(peopleData[index]),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  showPersonInfo(Person person) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext buildContext) {
        return PersonView(
          person: person,
        );
      },
    );
  }
}
