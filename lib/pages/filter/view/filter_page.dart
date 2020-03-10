import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  static const String routeName = '/filter';

  @override
  State<StatefulWidget> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: S.of(context).navigationFilter,
        enableMenu: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Text('Degree', style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Selectable(label: 'BSc'),
                    SizedBox(width: 10),
                    Selectable(label: 'MSc')
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
