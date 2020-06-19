import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/spoiler.dart';
import 'package:flutter/material.dart';

class ClassesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationClasses,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            AppSpoiler(
              title: "Anul I, semestrul 1",
              content: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text("M1"),
                    ),
                    title: Text("Matematică 1"),
                  ),
                  Divider(
                    height: 1.0,
                    indent: 1.0,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      child: Text("PC"),
                    ),
                    title: Text("Programarea Calculatoarelor"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            AppSpoiler(
              title: "Anul I, semestrul 2",
            )
          ],
        ),
      ),
    );
  }
}
