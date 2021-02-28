import 'dart:ui';

import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SourcePage extends StatefulWidget {
  @override
  _SourcePageState createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  bool wantsOfficialInfo;
  bool wantsOrganizationInfo;
  bool wantsStudentsInfo;
  AuthProvider authProvider;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context,listen: false);
    final user = authProvider.currentUserFromCache;
    wantsOrganizationInfo = user.canReadOrganizationInfo ?? false;
    wantsStudentsInfo = user.canReadStudentInfo ?? false;
  }

  @override
  Widget build(BuildContext context) {

    return AppScaffold(
      actions: [
        AppScaffoldAction(
            text: 'Salvare',
            onPressed: () async {
              final List<String> sources = ['official'];
              if (wantsOrganizationInfo) sources.add('organizations');
              if (wantsStudentsInfo) sources.add('students');
              await authProvider.setSourcePreferences(sources);
              Navigator.of(context).pop();
            })
      ],
      title: const Text(
        'Surse de informații',
        style: TextStyle(fontSize: 19.5),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
                'Aplicația ACS UPB Mobile își propune să fie un hub de informații '
                'despre facultate, așadar culege date din diverse surse (oficiale '
                'sau neoficiale).'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Selectează sursele de informații pe care dorești să le folosești:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
         const CheckboxListTile(
            value: true,
            onChanged: null,
            title: Text('Site-uri oficiale'),
            subtitle:
                Text('acs.pub.ro, upb.ro, curs.upb.ro, studenti.pub.ro'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: wantsOrganizationInfo,
            onChanged: (value) {
              setState(() {
                wantsOrganizationInfo = value;
              });
            },
            title: const Text('Organizații studențești*'),
            subtitle: const Text('LSAC, BEST, MLSA'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: wantsStudentsInfo,
            onChanged: (value) {
              setState(() {
                wantsStudentsInfo = value;
              });
            },
            title: const Text('Studenți reprezentanți*'),
            subtitle:
                const Text('șefi de grupă, serie și studenții consilieri'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '* Facultatea de Automatică și Calculatoare nu își asumă răspunderea '
              'pentru informațiile provenite din surse neoficiale.',
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
