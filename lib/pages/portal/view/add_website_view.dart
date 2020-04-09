import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';

class AddWebsiteView extends StatelessWidget {
  static const String routeName = '/add_website';

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: S.of(context).actionAddWebsite,
    enableMenu: true,
    menuText: S.of(context).buttonSave,
  );
}