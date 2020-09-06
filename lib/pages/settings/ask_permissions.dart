import 'dart:io';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';

class AskPermissions extends StatefulWidget {
  static const String routeName = '/askPermissions';

  @override
  State<StatefulWidget> createState() => AskPermissionsState();
}

class AskPermissionsState extends State<AskPermissions> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationAskPermissions,
    );
  }
}
