import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/courses_list_view.dart';
import 'package:acs_upb_mobile/pages/people/view/person_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'contact_info.dart';

class PersonView extends StatefulWidget {
  const PersonView({Key key, this.person}) : super(key: key);
  final Person person;

  @override
  _PersonViewState createState() => _PersonViewState();

  static Widget fromName(BuildContext context, String name) {
    final PersonProvider provider =
        Provider.of<PersonProvider>(context, listen: false);
    final Future<Person> person = provider.fetchPerson(name);

    return FutureBuilder(
      future: person,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final Person personData = snapshot.data;
          return PersonView(
            person: personData,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class _PersonViewState extends State<PersonView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 4,
                    child: PersonBanner(
                      name: widget.person.name,
                      photoURL: widget.person.photo,
                      position: widget.person.position,
                      office: widget.person.office,
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 100,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ContactInfo(
                      email: widget.person.email,
                      phone: widget.person.phone,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Courses',
                                style: Theme.of(context).textTheme.bodyText1),
                            Divider(
                              color: Theme.of(context).backgroundColor,
                            ),
                            CoursesListView(lecturerName: widget.person.name),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
