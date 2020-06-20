import 'package:acs_upb_mobile/pages/classes/model/person.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonView extends StatelessWidget {
  final Person person;

  const PersonView({Key key, this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: person.name,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Padding(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email),
                            SizedBox(width: 4),
                            Text(person.email ?? '-'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: 4),
                            Text(person.phone ?? '-'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 4),
                            Text(person.office ?? '-'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.work),
                            SizedBox(width: 4),
                            Text(person.position ?? '-'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
