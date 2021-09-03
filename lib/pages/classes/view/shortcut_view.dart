import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/app_navigator.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/navigation/view/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class ShortcutView extends StatefulWidget {
  const ShortcutView({Key key, this.onSave}) : super(key: key);

  final void Function(Shortcut) onSave;

  static const String routeName = '/shortcuts';

  @override
  _ShortcutViewState createState() => _ShortcutViewState();
}

class _ShortcutViewState extends State<ShortcutView> {
  final formKey = GlobalKey<FormState>();
  ShortcutType selectedType = ShortcutType.resource;
  TextEditingController labelController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.actionAddShortcut),
      actions: [
        AppScaffoldAction(
            text: S.current.buttonSave,
            onPressed: () {
              if (formKey.currentState.validate()) {
                widget.onSave(Shortcut(
                  name: labelController.text,
                  link: linkController.text,
                  type: selectedType,
                  ownerUid:
                      Provider.of<AuthProvider>(context, listen: false).uid,
                ));
                AppNavigator.pop(context);
              }
            })
      ],
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.asset(
                        'assets/illustrations/undraw_share_link.png')),
              ),
              TextFormField(
                controller: labelController,
                decoration: InputDecoration(
                  labelText: S.current.labelName,
                  hintText: S.current.hintWebsiteLabel,
                  prefixIcon: const Icon(Icons.label_outlined),
                ),
                onChanged: (_) => setState(() {}),
              ),
              DropdownButtonFormField<ShortcutType>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: S.current.labelType,
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                value: selectedType,
                items: ShortcutType.values
                    .map(
                      (type) => DropdownMenuItem<ShortcutType>(
                        value: type,
                        child: Text(type.toLocalizedString()),
                      ),
                    )
                    .toList(),
                onChanged: (selection) =>
                    setState(() => selectedType = selection),
              ),
              TextFormField(
                controller: linkController,
                decoration: InputDecoration(
                  labelText: '${S.current.labelLink} *',
                  hintText: S.current.hintWebsiteLink,
                  prefixIcon: const Icon(FeatherIcons.globe),
                ),
                validator: (value) {
                  if (!isURL(value, requireProtocol: true)) {
                    return S.current.warningInvalidURL;
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
