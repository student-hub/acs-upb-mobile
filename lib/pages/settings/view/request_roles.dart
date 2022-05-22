import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/button.dart';
import '../../../widgets/dialog.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../model/role_request.dart';
import '../service/roles_provider.dart';

class RequestRolesPage extends StatefulWidget {
  static const String routeName = '/requestRoles';

  @override
  _RequestRolesPageState createState() => _RequestRolesPageState();
}

class _RequestRolesPageState extends State<RequestRolesPage> {
  User user;
  bool agreedToResponsibilities = false;
  TextEditingController requestController = TextEditingController();

  Future<void> _fetchUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = await authProvider.currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  AppDialog _requestAlreadyExistsDialog(final BuildContext context) {
    return AppDialog(
      title: S.current.warningRequestExists,
      content: [
        Text(S.current.messageRequestAlreadyExists),
      ],
      actions: [
        AppButton(
            key: const ValueKey('agree_overwrite_request'),
            text: S.current.buttonSend,
            color: Theme.of(context).primaryColor,
            width: 130,
            onTap: () async {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(final BuildContext context) {
    final rolesProvider = Provider.of<RolesProvider>(context);

    return AppScaffold(
      title: const Text('Request Roles'),
      actions: [
        AppScaffoldAction(
          text: S.current.buttonSave,
          onPressed: () async {
            print('Save the new roles');

            final queryResult = await rolesProvider.makeRequest(RoleRequest(
                userId: user.uid, requestBody: requestController.text));
            if (queryResult) {
              AppToast.show(S.current.messageRequestHasBeenSent);
              if (!mounted) return;
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.asset('assets/illustrations/undraw_upgrade.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              "Why do you want to apply for this role?",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(S.current.messageAnnouncedOnMail,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Theme.of(context).textTheme.headline5.color)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              controller: requestController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: agreedToResponsibilities,
                  visualDensity: VisualDensity.compact,
                  onChanged: (final value) =>
                      setState(() => agreedToResponsibilities = value),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.25),
                    child: Text(
                      S.current.messageAgreePermissions,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
