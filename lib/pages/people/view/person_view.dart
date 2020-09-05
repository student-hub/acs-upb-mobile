import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonView extends StatelessWidget {
  final Person person;

  const PersonView({Key key, this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              color: Theme.of(context).accentColor,
              shape: BoxShape.rectangle,
              border: new Border.all(
                  color: Theme.of(context).accentColor, width: 10),
            ),
            child: Center(
              child: Text(person.name,
                  style: Theme.of(context).textTheme.headline6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                          RichText(
                            maxLines: 2,
                            softWrap: true,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText1,
                                children: [
                                  WidgetSpan(
                                      child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(Icons.email),
                                  )),
                                  TextSpan(text: person.email ?? '-'),
                                ]),
                          ),
                          SizedBox(height: 8),
                          RichText(
                            maxLines: 2,
                            softWrap: true,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText1,
                                children: [
                                  WidgetSpan(
                                      child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(Icons.phone),
                                  )),
                                  TextSpan(text: person.phone ?? '-'),
                                ]),
                          ),
                          SizedBox(height: 8),
                          RichText(
                            maxLines: 2,
                            softWrap: true,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText1,
                                children: [
                                  WidgetSpan(
                                      child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(Icons.location_on),
                                  )),
                                  TextSpan(text: person.office ?? '-'),
                                ]),
                          ),
                          SizedBox(height: 8),
                          RichText(
                            maxLines: 2,
                            softWrap: true,
                            text: TextSpan(
                                //TODO This line generates RenderFlex Overflow
                                //style: Theme.of(context).textTheme.bodyText1,
                                children: [
                                  WidgetSpan(
                                      child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(Icons.work),
                                  )),
                                  TextSpan(text: person.position ?? '-'),
                                ]),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
