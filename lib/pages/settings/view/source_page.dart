import 'dart:ui';

import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SourcePage extends StatefulWidget {
  static const String routeName = '/sources';

  @override
  _SourcePageState createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  AuthProvider authProvider;
  Map<String, bool> sourceSelected = {};

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUserFromCache;
    sourceSelected['official'] = user.sources?.contains('official') ?? true;
    sourceSelected['organizations'] =
        user.sources?.contains('organizations') ?? true;
    sourceSelected['students'] = user.sources?.contains('students') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      actions: [
        AppScaffoldAction(
            text: S.current.buttonSave,
            onPressed: () async {
              final List<String> sources = ['official'];
              if (sourceSelected['organizations']) sources.add('organizations');
              if (sourceSelected['students']) sources.add('students');
              await authProvider.setSourcePreferences(sources);
              Navigator.of(context).pop();
            })
      ],
      title: Text(
        S.current.sectionInformationSources,
        style: const TextStyle(fontSize: 19.5),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text('${S.current.messageSelectSource}*'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Text(
                  S.current.hintSelectSources,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            value: true,
            onChanged: null,
            title: Text(S.current.sourceOfficialWebPages),
            subtitle: Text(S.current.sourceOfficialWebPagesInfo),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: sourceSelected['organizations'],
            onChanged: (value) {
              setState(() => sourceSelected['organizations'] = value);
            },
            title: Text('${S.current.sourceStudentOrganizations}*'),
            subtitle: Text(S.current.sourceStudentOrganizationsInfo),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: sourceSelected['students'],
            onChanged: (value) {
              setState(() => sourceSelected['students'] = value);
            },
            title: Text('${S.current.sourceStudentRepresentatives}*'),
            subtitle: Text(S.current.sourceStudentRepresentativesInfo),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '* ${S.current.infoAdditionInformationSources}',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Image.asset(
                    'assets/illustrations/undraw_selected_options.png')),
          ),
        ],
      ),
    );
  }
}
