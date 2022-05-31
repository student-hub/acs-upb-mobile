import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/button.dart';
import '../../../widgets/dialog.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../../filter/view/filter_dropdown.dart';
import '../../filter/view/roles_filter_dropdown.dart';
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
  final requestController = TextEditingController();
  final rolesDropdownController = RolesFilterDropdownController();

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
            if (rolesDropdownController.path == null ||
                rolesDropdownController.path.length < 2) {
              AppToast.show('You need to select a role.');
              return;
            }

            if (requestController.text == '') {
              AppToast.show(
                  'You need to specify why you want to apply for this role.');
              return;
            }

            if (!agreedToResponsibilities) {
              AppToast.show('You need to agree to the responsibilities.');
              return;
            }

            final queryResult = await rolesProvider.makeRequest(
              RoleRequest(
                userId: user.uid,
                roleName: rolesDropdownController.path.join('-'),
                requestBody: requestController.text,
              ),
            );
            if (queryResult) {
              AppToast.show(S.current.messageRequestHasBeenSent);
              if (!mounted) return;
              Navigator.of(context).pop();
            } else {
              AppToast.show('Request could not be made!');
            }
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.asset('assets/illustrations/undraw_upgrade.png'),
            ),
            const Text(
              'ACS UPB Mobile encourages students to contribute in posting useful content on the platform. Roles help students post content from a specific position: on behalf of an organization, as a student representative or simply as a normal student.',
              textAlign: TextAlign.justify,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                'You will receive a mail confirmation if your request is approved. ',
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'Select the role you want to apply for:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            RolesFilterDropdown(
              controller: rolesDropdownController,
              leftPadding: 10,
              textStyle: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Theme.of(context).hintColor),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'Why do you want to apply for this role?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              controller: requestController,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                        'I will only upload information that is correct and relevant to this role, to the best of my knowledge. I understand that posting inappropriate content or abusing this role will lead to having it permanently revoked.',
                        style: Theme.of(context).textTheme.caption.apply(
                            color: Theme.of(context).textTheme.headline5.color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
