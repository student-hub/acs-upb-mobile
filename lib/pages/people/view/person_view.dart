import 'dart:math';

import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

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
    return  SafeArea(
      child:Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30,30,30,5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex:1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex:4,
                    child: Card(
                      child:Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex:2,
                              child:_buildCircleAvatar(),
                            ),
                            Expanded(
                              flex:6,
                              child:Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.person.position,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      widget.person.name,
                                      style: Theme.of(context).textTheme.headline3,
                                    ),
                                    const SizedBox(height: 12),
                                    IconText(
                                        icon: FeatherIcons.mapPin,
                                        text: widget.person.office ?? '-',
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
                  Expanded(
                    flex:1,
                    child: SizedBox(width:100,),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30,5,30,30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(width: 100,),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Contact information',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Divider(
                              color: Theme.of(context).backgroundColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconText(
                                  icon: FeatherIcons.mail,
                                  text: widget.person.email ?? '-',
                                  style: Theme.of(context).textTheme.bodyText1,
                                  onTap: () =>
                                      Utils.launchURL('mailto:${widget.person.email}'),
                                ),
                                SizedBox(height: 10),
                                IconText(
                                  icon: FeatherIcons.phone,
                                  text: widget.person.phone ?? '-',
                                  style: Theme.of(context).textTheme.bodyText1,
                                  onTap: () =>
                                      Utils.launchURL('tel:${widget.person.phone}'),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
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
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('classes').snapshots(),
                              builder: (context, snapshot){
                                if(!snapshot.hasData) return const CircularProgressIndicator();
                                return _buildCourse(context, snapshot.data.documents[0].id);
                            }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(width: 100,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleAvatar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = min(constraints.maxHeight / 3, constraints.maxWidth / 3);
        return Container(
          child: Center(
            child: widget.person.photo != null
                ? CircleAvatar(
              radius: radius,
              backgroundImage: CachedNetworkImageProvider(widget.person.photo),
            )
                : const CircleAvatar(
              child: Icon(
                Icons.person_outlined,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourse(context, lecture) {
    return Container(
      child:Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:Padding(
                padding: EdgeInsets.all(4),
                child: Center(
                  child:Text(
                    lecture.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
