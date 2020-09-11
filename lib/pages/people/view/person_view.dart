import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonView extends StatelessWidget {
  final Person person;

  const PersonView({Key key, this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            shape: BoxShape.rectangle,
            border: Border.all(color: Theme.of(context).accentColor, width: 10),
          ),
          child: Center(
            child:
                Text(person.name, style: Theme.of(context).textTheme.headline6),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                      child: person.photo != null
                          ? CircleAvatar(
                              maxRadius: 50,
                              backgroundImage:
                                  CachedNetworkImageProvider(person.photo),
                            )
                          : CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconText(
                            icon: Icons.email,
                            text: person.email ?? '-',
                            style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(height: 8),
                        IconText(
                            icon: Icons.phone,
                            text: person.phone ?? '-',
                            style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(height: 8),
                        IconText(
                            icon: Icons.location_on,
                            text: person.office ?? '-',
                            style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(height: 8),
                        IconText(
                            icon: Icons.work,
                            text: person.position ?? '-',
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
