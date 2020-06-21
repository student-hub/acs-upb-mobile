import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
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
  final UniEventInstance event;
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

  DateFormat _format = DateFormat("EEEE, dd MMMM HH:mm");

  TextEditingController _titleController;
  TextEditingController _typeController;
  TextEditingController _locationController;

  UniEventType _selectedEventType;
  Color _selectedColor;
  DateTime _startTime;
  DateTime _endTime;

  TextEditingController _endTimeController;

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

    _selectedEventType = widget.event?.mainEvent?.type ?? UniEventType.lab;

    _startTime = widget.event?.start?.toDateTimeLocal() ?? DateTime.now();
    _endTime = widget.event?.end?.toDateTimeLocal() ??
        _startTime.add(Duration(hours: 1));

    _endTimeController = TextEditingController(text: _format.format(_endTime));

    _titleController = TextEditingController(text: widget.event?.title ?? '');
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

  Padding _colorIcon() => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: _selectedColor,
          ),
        ),
      );

  InkWell _colorPicker(BuildContext context) => InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: BlockPicker(
                  pickerColor: _selectedColor,
                  // TODO: Manage color change
                  onColorChanged: (newColor) {
                    setState(() => _selectedColor = newColor);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12.0),
          child: Row(
            children: <Widget>[
              _colorIcon(),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                S.of(context).labelColor,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .apply(color: Theme.of(context).hintColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.0),
                        // TODO: Show color name instead of hex
                        Text('#' +
                            _selectedColor.value
                                .toRadixString(16)
                                .toUpperCase()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_selectedColor == null) {
      _selectedColor = widget.event?.color ?? Theme.of(context).primaryColor;
    }
    if (_typeController == null) {
      _typeController = TextEditingController(
          text:
              widget.event?.mainEvent?.type?.toLocalizedString(context) ?? '');
    }

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
                        _colorIcon(),
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
                        Text(widget.event.mainEvent.type
                            .toLocalizedString(context)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.class_),
                        SizedBox(width: 16),
                        Text(widget.event.mainEvent.type
                            .toLocalizedString(context)),
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
                          DropdownButtonFormField<UniEventType>(
                            decoration: InputDecoration(
                              labelText: S.of(context).labelType,
                              prefixIcon: Icon(Icons.category),
                            ),
                            value: _selectedEventType,
                            items: UniEventType.values
                                .map(
                                  (type) => DropdownMenuItem<UniEventType>(
                                    value: type,
                                    child:
                                        Text(type.toLocalizedString(context)),
                                  ),
                                )
                                .toList(),
                            onChanged: (selection) =>
                                setState(() => _selectedEventType = selection),
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: S.of(context).labelClass,
                              prefixIcon: Icon(Icons.class_),
                            ),
                            value: 'Programarea Calculatoarelor (CB)',
                            items: [
                              DropdownMenuItem(
                                  value: 'Programarea Calculatoarelor (CB)',
                                  child:
                                      Text('Programarea Calculatoarelor (CB)')),
                            ],
                            onChanged: (_) {},
                          ),
                          // TODO: Check that startTime < endTime
                          DateTimeField(
                            label: S.of(context).labelStart,
                            initialValue: _startTime,
                            format: _format,
                            onUpdate: (newValue) => setState(() {
                              print(newValue);
                              Duration duration =
                                  _endTime.difference(_startTime);
                              print(duration);
                              _startTime = newValue;
                              _endTime = _startTime.add(duration);
                              _endTimeController.text =
                                  _format.format(_endTime);
                            }),
                          ),
                          DateTimeField(
                            label: S.of(context).labelEnd,
                            controller: _endTimeController,
                            onUpdate: (newValue) => setState(() {
                              _endTime = newValue;
                            }),
                          ),
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: S.of(context).labelLocation,
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          _colorPicker(context),
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

class DateTimeField extends StatefulWidget {
  final String label;
  final DateTime initialValue;
  final TextEditingController controller;
  final Function(DateTime) onUpdate;
  final DateFormat format;

  DateTimeField(
      {Key key,
      this.label = '',
      DateTime initialValue,
      TextEditingController controller,
      this.onUpdate,
      DateFormat format})
      : this.controller = controller ??
            TextEditingController(text: format.format(initialValue)),
        this.format = format ?? DateFormat("EEEE, dd MMMM HH:mm"),
        this.initialValue = initialValue ?? DateTime.now(),
        super(key: key);

  @override
  _DateTimeFieldState createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  DateTime currentValue;
  FocusNode focusNode;

  bool hadFocus = false;

  _showPicker() async {
    DateTime selectedValue = currentValue;

    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: currentValue ?? DateTime.now(),
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
      );
      setState(() {
        selectedValue = DateTime(date.year, date.month, date.day,
            time?.hour ?? 0, time?.minute ?? 0);
      });
    }

    if (widget.onUpdate != null) {
      widget.onUpdate(selectedValue);
    }
    widget.controller.text = widget.format.format(selectedValue);
  }

  void _handleFocusChanged() async {
    bool hasFocus = focusNode.hasFocus;
    if (focusNode.hasFocus && !hadFocus) {
      hadFocus = hasFocus;
      _hideKeyboard();
      await _showPicker();
    } else {
      hadFocus = hasFocus;
    }
  }

  void _hideKeyboard() {
    Future.microtask(() => FocusScope.of(context).requestFocus(FocusNode()));
  }

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;

    focusNode = FocusNode();
    focusNode.addListener(_handleFocusChanged);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime selectedValue = currentValue;

        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          setState(() {
            selectedValue = DateTime(date.year, date.month, date.day,
                time?.hour ?? 0, time?.minute ?? 0);
          });
        }

        if (widget.onUpdate != null) {
          widget.onUpdate(selectedValue);
        }
        widget.controller.text = widget.format.format(selectedValue);
      },
      child: TextField(
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: Icon(Icons.access_time),
        ),
        controller: widget.controller,
        focusNode: focusNode,
        readOnly: true,
      ),
    );
  }
}
