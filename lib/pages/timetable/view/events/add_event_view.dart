import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  final _formKey = GlobalKey<FormState>();

  TextEditingController _typeController;
  TextEditingController _locationController;

  UniEventType _selectedEventType;

  @override
  void initState() {
    super.initState();
    _selectedEventType = widget.initialEvent?.type ?? UniEventType.lab;
    _locationController =
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
          _formKey.currentState.validate();
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
    _typeController ??= TextEditingController(
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
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<UniEventType>(
                      decoration: InputDecoration(
                        labelText: S.of(context).labelType,
                        prefixIcon: const Icon(Icons.category),
                      ),
                      value: _selectedEventType,
                      items: UniEventType.values
                          .map(
                            (type) => DropdownMenuItem<UniEventType>(
                              value: type,
                              child: Text(type.toLocalizedString(context)),
                            ),
                          )
                          .toList(),
                      onChanged: (selection) =>
                          setState(() => _selectedEventType = selection),
                    ),
                    TextFormField(
                      controller: _locationController,
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
