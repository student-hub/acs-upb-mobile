import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/scaffold.dart';
import '../model/class.dart';

class ShortcutView extends StatefulWidget {
  const ShortcutView({final Key key, this.onSave}) : super(key: key);

  final void Function(Shortcut) onSave;

  @override
  _ShortcutViewState createState() => _ShortcutViewState();
}

class _ShortcutViewState extends State<ShortcutView> {
  final formKey = GlobalKey<FormState>();
  ShortcutType selectedType = ShortcutType.resource;
  TextEditingController labelController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  Widget build(final BuildContext context) {
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
                Navigator.of(context).pop();
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
                child: SizedBox(
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
                onChanged: (final _) => setState(() {}),
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
                      (final type) => DropdownMenuItem<ShortcutType>(
                        value: type,
                        child: Text(type.toLocalizedString()),
                      ),
                    )
                    .toList(),
                onChanged: (final selection) =>
                    setState(() => selectedType = selection),
              ),
              TextFormField(
                controller: linkController,
                decoration: InputDecoration(
                  labelText: '${S.current.labelLink} *',
                  hintText: S.current.hintWebsiteLink,
                  prefixIcon: const Icon(FeatherIcons.globe),
                ),
                validator: (final value) {
                  if (!isURL(value, requireProtocol: true)) {
                    return S.current.warningInvalidURL;
                  }
                  return null;
                },
                onChanged: (final _) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
