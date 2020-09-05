import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class PeoplePage extends StatefulWidget {
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
    people = personProvider.fetchPeople(context);
    if (people == null) {
      developer.log("mda");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationPeople,
      body: Container(
        child: FutureBuilder(
            future: people,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Text("Loading..."),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              PersonExtension.fromSnap(snapshot.data[index])
                                  .photo),
                        ),
                        title: Text(
                            PersonExtension.fromSnap(snapshot.data[index])
                                .name),
                        subtitle: Text(
                            PersonExtension.fromSnap(snapshot.data[index])
                                .email),
                        onTap: () => showPersonInfo(
                            PersonExtension.fromSnap(snapshot.data[index])),
                      );
                    });
              } else {
                return Center(
                  child: Text("Loading..."),
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
      // TODO: Fix size for long position name
      builder: (BuildContext buildContext) {
        return PersonView(
          person: person,
        );
      },
    );
  }
}
