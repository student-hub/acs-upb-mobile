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
import '../model/request.dart';
import '../service/request_provider.dart';

class RequestPermissionsPage extends StatefulWidget {
  static const String routeName = '/requestPermissions';

  @override
  State<StatefulWidget> createState() => _RequestPermissionsPageState();
}

class _RequestPermissionsPageState extends State<RequestPermissionsPage> {
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
    final requestProvider = Provider.of<RequestProvider>(context);

    return AppScaffold(
        title: Text(S.current.navigationAskPermissions),
        actions: [
          AppScaffoldAction(
            text: S.current.buttonSave,
            onPressed: () async {
              if (!agreedToResponsibilities) {
                AppToast.show(
                    '${S.current.warningAgreeTo}${S.current.labelPermissionsConsent}.');
                return;
              }

              if (requestController.text == '') {
                AppToast.show(S.current.warningRequestEmpty);
                return;
              }

              /*
                 * Check if there is already a request registered for the current
                 * user.
                 */
              bool queryResult =
                  await requestProvider.userAlreadyRequested(user.uid);

              if (queryResult) {
                if (!mounted) return;
                await showDialog<dynamic>(
                  context: context,
                  builder: _requestAlreadyExistsDialog,
                );
              }

              print('Sending request...');
              if (mounted) {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                queryResult = await requestProvider.makeRequest(
                  Request(
                    userId: user.uid,
                    userEmail: authProvider.email,
                    requestBody: requestController.text,
                  ),
                );
                if (queryResult) {
                  AppToast.show(S.current.messageRequestHasBeenSent);
                  if (!mounted) return;
                  Navigator.of(context).pop();
                }
              }
            },
          )
        ],
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Image.asset('assets/illustrations/undraw_hiring.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                S.current.messageAskPermissionToEdit(Utils.packageInfo.appName),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                '* ${S.current.messageAnnouncedOnMail}',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
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
        ));
  }
}
