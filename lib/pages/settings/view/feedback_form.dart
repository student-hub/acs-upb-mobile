import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/pages/settings/service/request_provider.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackFormPage extends StatefulWidget {
  static const String routeName = '/feedbackForm';

  @override
  State<StatefulWidget> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage>{

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// class FeedbackFormPage extends StatelessWidget{
//   static const String routeName = '/feedbackForm';
//   const FeedbackFormPage({this.tabController, Key key}) : super(key: key);
//
//   final TabController tabController;
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//
//     return AppScaffold(
//       title: Text(S.current.navigationHome),
//       actions: [
//         AppScaffoldAction(
//           icon: Icons.settings_outlined,
//           tooltip: S.current.navigationSettings,
//           route: Routes.settings,
//         )
//       ],
//       body: ListView(
//         children: [
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
// }
