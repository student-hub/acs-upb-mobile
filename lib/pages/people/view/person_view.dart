import 'package:acs_upb_mobile/navigation/view/scaffold.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/resources/web_layout_sizes.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/person_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import 'classes_card.dart';
import 'contact_info.dart';

class PersonView extends StatelessWidget {
  const PersonView({Key key, this.person}) : super(key: key);

  static const String routeName = '/profile';

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
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final isScreenNarrow =
          MediaQuery.of(context).size.width <= Sizes.narrowScreen;

      return AppScaffold(
        body: Align(
          alignment: FractionalOffset.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                child: _PersonBanner(
                  name: person.name,
                  photoURL: person.photo,
                  position: person.position,
                  office: person.office,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                child: Flex(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: isScreenNarrow ? Axis.vertical : Axis.horizontal,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: ContactInfo(
                        email: person.email,
                        phone: person.phone,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ClassesCard(lecturerName: person.name),
                    ),
                  ],
                ),
              ),
            ],
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
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
                      overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
