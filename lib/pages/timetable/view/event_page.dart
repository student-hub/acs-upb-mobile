import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:timetable/timetable.dart';

extension EventExtension on Event {
  String get dateString {
    if (start.calendarDate == end.calendarDate) {
      return start.calendarDate.toString('dddd, dd MMMM') +
          ' • ' +
          start.clockTime.toString('HH:mm') +
          ' - ' +
          end.clockTime.toString('HH:mm');
    } else {
      return start.calendarDate.toString('dddd, dd MMMM') +
          ' • ' +
          start.clockTime.toString('HH:mm') +
          ' - ' +
          end.calendarDate.toString('dddd, dd MMMM') +
          ' • ' +
          end.clockTime.toString('HH:mm');
    }
  }
}

class EventView extends StatefulWidget {
  final UniEvent event;
  final bool addNew;
  final bool updateExisting;

  // If [updateExisting] is true, this acts like an "Edit event" page starting
  // from the info in [event]. Otherwise, it acts like an "Add event" page.
  EventView(
      {Key key, this.event, this.addNew = true, this.updateExisting = false})
      : super(key: key) {
    if (this.updateExisting == true && this.event == null) {
      throw ArgumentError(
          'EventView: event cannot be null if updateExisting is true');
    }
    if (this.updateExisting == true && this.addNew == true) {
      throw ArgumentError(
          'EventView: updateExisting and addNew cannot both be true');
    }
  }

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController;
  TextEditingController _typeController;
  TextEditingController _locationController;

  User _user;

  _fetchUser() async {
    AuthProvider authProvider = Provider.of(context, listen: false);
    _user = await authProvider.currentUser;
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    _fetchUser();

    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _typeController = TextEditingController(text: widget.event?.type ?? '');
    _locationController =
        TextEditingController(text: widget.event?.location ?? '');
  }

  AppDialog _deletionConfirmationDialog(BuildContext context) => AppDialog(
        icon: Icon(Icons.delete),
        title: S.of(context).actionDeleteEvent,
        message: S.of(context).messageDeleteEvent,
        actions: [
          AppButton(
            text: S.of(context).actionDeleteEvent,
            width: 130,
            onTap: () async {
              Navigator.pop(context); // Pop dialog window
              // TODO: Delete event
            },
          )
        ],
      );

  AppScaffoldAction _saveButton() => AppScaffoldAction(
        text: S.of(context).buttonSave,
        onPressed: () async {
          // TODO: Save data
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
    return AppScaffold(
      title: widget.addNew
          ? S.of(context).actionAddEvent
          : widget.updateExisting
              ? S.of(context).actionEditEvent
              : S.of(context).navigationEventDetails,
      actions: widget.addNew
          ? [_saveButton()]
          : widget.updateExisting
              ? [
                  _saveButton(),
                  _deleteButton(),
                ]
              : [
                  AppScaffoldAction(
                      icon: Icons.edit,
                      onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EventView(
                                event: widget.event,
                                addNew: false,
                                updateExisting: true,
                              ),
                            ),
                          )),
                  _deleteButton(),
                ],
      body: SafeArea(
        child: ListView(
          children: !widget.addNew && !widget.updateExisting
              ? [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              color: widget.event.color,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.event.title,
                                style: Theme.of(context).textTheme.headline6),
                            SizedBox(height: 4),
                            // TODO: Improve date format
                            Text(widget.event.dateString),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.category),
                        SizedBox(width: 16),
                        Text(widget.event.type),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        SizedBox(width: 16),
                        Text(widget.event.location),
                      ],
                    ),
                  ),
                ]
              : <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: S.of(context).labelName,
                              prefixIcon: Icon(Icons.text_format),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          TextFormField(
                            controller: _typeController,
                            decoration: InputDecoration(
                              labelText: S.of(context).labelType,
                              prefixIcon: Icon(Icons.category),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: S.of(context).labelLocation,
                              prefixIcon: Icon(Icons.location_on),
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
