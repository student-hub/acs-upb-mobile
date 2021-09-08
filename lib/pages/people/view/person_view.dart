import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/classes_card.dart';
import 'package:acs_upb_mobile/pages/people/view/contact_info.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/person_avatar.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class PersonView extends StatelessWidget {
  const PersonView({Key key, this.person}) : super(key: key);
  final Person person;

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
          return const SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = ScrollController();
    if (kIsWeb) {
      return AppScaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          // TODO(RavanRotaru): extract scrollbar in another widget
          child: Align(
            alignment: FractionalOffset.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width / 1.50,
              ),
              child: Scrollbar(
                thickness: 10,
                isAlwaysShown: true,
                controller: _controller,
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 5),
                        child: _PersonBanner(
                          name: person.name,
                          photoURL: person.photo,
                          position: person.position,
                          office: person.office,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 5, 28, 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ContactInfo(
                                email: person.email,
                                phone: person.phone,
                              ),
                            ),
                            Expanded(
                              child: ClassesCard(lecturerName: person.name),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.rectangle,
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 10),
              ),
              child: Center(
                child: Text(person.name,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                          child: PersonAvatar(
                        photoURL: person.photo,
                        size: 50,
                      )),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconText(
                                icon: FeatherIcons.mail,
                                text: person.email ?? '-',
                                style: Theme.of(context).textTheme.bodyText1,
                                onTap: () =>
                                    Utils.launchURL('mailto:${person.email}'),
                              ),
                              const SizedBox(height: 16),
                              IconText(
                                icon: FeatherIcons.phone,
                                text: person.phone ?? '-',
                                style: Theme.of(context).textTheme.bodyText1,
                                onTap: () =>
                                    Utils.launchURL('tel:${person.phone}'),
                              ),
                              const SizedBox(height: 16),
                              IconText(
                                  icon: FeatherIcons.mapPin,
                                  text: person.office ?? '-',
                                  style: Theme.of(context).textTheme.bodyText1),
                              const SizedBox(height: 16),
                              IconText(
                                  icon: Icons.work_outline,
                                  text: person.position ?? '-',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _PersonBanner extends StatelessWidget {
  const _PersonBanner({
    @required this.name,
    @required this.photoURL,
    @required this.position,
    @required this.office,
    Key key,
  }) : super(key: key);
  final String name;
  final String photoURL;
  final String position;
  final String office;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            PersonAvatar(
              photoURL: photoURL,
              size: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    position,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(height: 12),
                  IconText(
                      icon: FeatherIcons.mapPin,
                      text: office ?? '-',
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
