import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

extension ClassExtension on Class {
  Color get colorFromAcronym {
    int r = 0, g = 0, b = 0;
    if (acronym.length >= 1) {
      b = acronym[0].codeUnitAt(0);
      if (acronym.length >= 2) {
        g = acronym[1].codeUnitAt(0);
        if (acronym.length >= 3) {
          r = acronym[2].codeUnitAt(0);
        }
      }
    }
    int brightnessFactor = 2;
    return Color.fromRGBO(
        r * brightnessFactor, g * brightnessFactor, b * brightnessFactor, 1);
  }
}

class ClassView extends StatelessWidget {
  final Class classInfo;

  const ClassView({Key key, this.classInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: classInfo.completeName,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            headerCard(),
            SizedBox(height: 8),
            shortcuts(context),
            SizedBox(height: 8),
            events(context),
          ],
        ),
      ),
    );
  }

  Widget shortcuts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).sectionShortcuts,
                style: Theme.of(context).textTheme.headline6,
              ),
              Icon(Icons.add),
            ],
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.home),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.grey.shade600,
            ),
            title: Text('Pagina principală'),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.insert_drive_file),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.grey.shade600,
            ),
            title: Text('Catalog'),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
          )
        ],
      ),
    );
  }

  Widget events(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).sectionEvents,
                style: Theme.of(context).textTheme.headline6,
              ),
              Icon(Icons.add),
            ],
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.2),
              child: Icon(Icons.laptop, color: Colors.grey.shade600),
            ),
            title: Text('Tema 1'),
            subtitle: Text('5 Feb 2020 | 23:55'),
            contentPadding: EdgeInsets.zero,
          )
        ],
      ),
    );
  }

  Widget headerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: classInfo.colorFromAcronym,
              child: AutoSizeText(
                classInfo.acronym,
                minFontSize: 5,
                maxLines: 1,
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 4),
                    Text("Vlad Posea"),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 4),
                    Text(classInfo.shortName + ' team'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
