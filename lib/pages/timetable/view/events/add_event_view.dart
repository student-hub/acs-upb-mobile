import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class AddEventView extends StatefulWidget {
  /// If the `id` of [initialEvent] is not null, this acts like an "Edit event"
  /// page starting from the info in [initialEvent]. Otherwise, it acts like an
  /// "Add event" page with optional default values based on [initialEvent].
  const AddEventView({Key key, this.initialEvent}) : super(key: key);

  final UniEvent initialEvent;

  @override
  _AddEventViewState createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final formKey = GlobalKey<FormState>();

  TextEditingController typeController;
  TextEditingController locationController;

  UniEventType selectedEventType;
  ClassHeader selectedClass;

  List<ClassHeader> classHeaders = [];
  User user;

  @override
  void initState() {
    super.initState();

    user =
        Provider.of<AuthProvider>(context, listen: false).currentUserFromCache;
    Provider.of<ClassProvider>(context, listen: false)
        .fetchClassHeaders(uid: user.uid)
        .then((headers) => setState(() => classHeaders = headers));

    selectedEventType = widget.initialEvent?.type;
    selectedClass = widget.initialEvent?.classHeader;
    locationController =
        TextEditingController(text: widget.initialEvent?.location ?? '');
  }

  AppDialog _deletionConfirmationDialog(BuildContext context) => AppDialog(
        icon: const Icon(Icons.delete),
        title: S.of(context).actionDeleteEvent,
        message: S.of(context).messageDeleteEvent,
        actions: [
          AppButton(
            text: S.of(context).actionDeleteEvent,
            width: 130,
            onTap: () async {
              Navigator.pop(context); // Pop dialog window
              // TODO(IoanaAlexandru): Delete event
            },
          )
        ],
      );

  AppScaffoldAction _saveButton() => AppScaffoldAction(
        text: S.of(context).buttonSave,
        onPressed: () async {
          // TODO(IoanaAlexandru): Save data
          formKey.currentState.validate();
        },
      );

  AppScaffoldAction _deleteButton() => AppScaffoldAction(
        icon: Icons.more_vert,
        items: {
          S.of(context).actionDeleteEvent: () => showDialog(
              context: context, child: _deletionConfirmationDialog(context))
        },
        onPressed: () => showDialog(
            context: context, child: _deletionConfirmationDialog(context)),
      );

  @override
  Widget build(BuildContext context) {
    typeController ??= TextEditingController(
        text: widget.initialEvent?.type?.toLocalizedString(context) ?? '');

    return AppScaffold(
      title: Text(widget.initialEvent?.id == null
          ? S.of(context).actionAddEvent
          : S.of(context).actionEditEvent),
      actions: widget.initialEvent?.id == null
          ? [_saveButton()]
          : [
              _saveButton(),
              _deleteButton(),
            ],
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<UniEventType>(
                      decoration: InputDecoration(
                        labelText: S.of(context).labelType,
                        prefixIcon: const Icon(Icons.category),
                      ),
                      value: selectedEventType,
                      items: UniEventType.values
                          .map(
                            (type) => DropdownMenuItem<UniEventType>(
                              value: type,
                              child: Text(type.toLocalizedString(context)),
                            ),
                          )
                          .toList(),
                      onChanged: (selection) =>
                          setState(() => selectedEventType = selection),
                    ),
                    DropdownButtonFormField<ClassHeader>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelClass,
                        prefixIcon: const Icon(Icons.class_),
                      ),
                      value: selectedClass,
                      items: classHeaders.map(
                        (header) => DropdownMenuItem(
                            value: header, child: Text(header.name)),
                      ).toList(),
                      onChanged: (selection) => selectedClass = selection,
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelLocation,
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
