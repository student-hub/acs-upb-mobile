import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/form/form.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  List<FormItem> formItems;
  Filter filter;
  List<FilterNode> nodes;
  FilterProvider filterProvider;

  User _user;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  void _fetchInitialData() async {
    filterProvider = Provider.of<FilterProvider>(context, listen: false);
    filter = await filterProvider.fetchFilter(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    _user = await authProvider.currentUser;

    List<String> path = List();
    if (_user.degree != null) {
      path.add(_user.degree);
      if (_user.domain != null) {
        path.add(_user.domain);
        if (_user.year != null) {
          path.add(_user.year);
          if (_user.series != null) {
            path.add(_user.series);
            if (_user.group != null) {
              path.add(_user.group);
            }
          }
        }
      }
    }
    nodes = filter.findNodeByPath(path);
    firstNameController.text = _user.firstName;
    lastNameController.text = _user.lastName;
    setState(() {});
  }

  void _addControllerListener(TextEditingController controller) {
    controller.addListener(() {
      final text = controller.text;
      controller.value = controller.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty);
    });
  }

  initState() {
    super.initState();
    _fetchInitialData();
    _addControllerListener(firstNameController);
    _addControllerListener(lastNameController);
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  List<Widget> _dropdownTree(BuildContext context) {
    List<Widget> items = [SizedBox(height: 8)];

    if (filter == null || nodes == null) {
      items.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(child: CircularProgressIndicator()),
      ));
    } else {
      for (var i = 0; i < nodes.length; i++) {
        if (nodes[i] != null && nodes[i].children.isNotEmpty) {
          items.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  filter.localizedLevelNames[i][LocaleProvider.localeString],
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .apply(color: Theme.of(context).hintColor),
                ),
              ),
              DropdownButtonFormField<FilterNode>(
                value: nodes.length > i + 1 ? nodes[i + 1] : null,
                items: nodes[i]
                    .children
                    .map((node) => DropdownMenuItem(
                          value: node,
                          child: Text(node.name),
                        ))
                    .toList(),
                onChanged: (selected) => setState(
                  () {
                    nodes.removeRange(i + 1, nodes.length);
                    nodes.add(selected);
                  },
                ),
              ),
            ],
          ));
        }
      }
    }
    return items;
  }

  Future<void> _signOut(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut(context);
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  AppDialog _deletionConfirmationDialog(BuildContext context) => AppDialog(
        icon: Icon(Icons.warning, color: Colors.red),
        title: S.of(context).actionDeleteAccount,
        message: S.of(context).messageDeleteAccount +
            ' ' +
            S.of(context).messageCannotBeUndone,
        actions: [
          AppButton(
            key: ValueKey('delete_account_button'),
            text: S.of(context).actionDeleteAccount.toUpperCase(),
            color: Colors.red,
            width: 130,
            onTap: () async {
              AuthProvider authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              bool res = await authProvider.delete(context: context);
              if (res) {
                _signOut(context);
              }
            },
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return AppScaffold(
      title: 'Edit Profile',
      actions: [
        AppScaffoldAction(
            text: S.of(context).buttonSave,
            onPressed: () async {
              bool result = await authProvider.updateProfile(
                info: {
                  S.of(context).labelFirstName: firstNameController.text,
                  S.of(context).labelLastName: lastNameController.text,
                  filter.localizedLevelNames[0][LocaleProvider.localeString]:
                      nodes[1].name != null ? nodes[1].name: null,
                  filter.localizedLevelNames[1][LocaleProvider.localeString]:
                      nodes[2].name != null ? nodes[2].name: null,
                  filter.localizedLevelNames[2][LocaleProvider.localeString]:
                      nodes[3].name != null ? nodes[3].name: null,
                  filter.localizedLevelNames[3][LocaleProvider.localeString]:
                      nodes[4].name != null ? nodes[4].name: null,
                  filter.localizedLevelNames[4][LocaleProvider.localeString]:
                      nodes[5].name != null ? nodes[5].name: null,
                  filter.localizedLevelNames[5][LocaleProvider.localeString]:
                      nodes[6].name != null ? nodes[6].name: null,
                },
                context: context,
              );

              if (result) {
                AppToast.show('Success');
                Navigator.pop(context);
              } else {
                AppToast.show('Fail');
              }
            }),
        AppScaffoldAction(
          icon: Icons.more_vert,
          items: {
            S.of(context).actionDeleteAccount: () => showDialog(
                context: context, child: _deletionConfirmationDialog(context))
          },
          onPressed: () => showDialog(
              context: context, child: _deletionConfirmationDialog(context)),
        )
      ],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: authProvider.currentUser,
          builder: (BuildContext context, AsyncSnapshot<User> snap) {
            return Container(
              child: ListView(children: [
                Column(children: [
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: S.of(context).labelFirstName,
                        hintText: S.of(context).hintFirstName,
                      ),
                      controller: firstNameController),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: S.of(context).labelLastName,
                      hintText: S.of(context).hintLastName,
                    ),
                    controller: lastNameController,
                  ),
                ]),
                Column(
                  children: _dropdownTree(context),
                )
              ]),
            );
          },
        ),
      ),
    );
  }
}
