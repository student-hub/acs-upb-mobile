import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/filter/view/relevance_picker.dart';
import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/all_day_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/recurring_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_text_patterns.dart';

class WeekType extends Localizable {
  const WeekType(this._value);

  final int _value;

  int get value => _value;

  static const WeekType odd = WeekType(0);
  static const WeekType even = WeekType(1);

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(dynamic other) =>
      other is WeekType && other._value == _value ||
      other is int && other == _value;

  @override
  String toLocalizedString(BuildContext context) {
    switch (_value) {
      case 0:
        return S.of(context).labelOdd;
      case 1:
        return S.of(context).labelEven;
      default:
        return '';
    }
  }
}

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

  TextEditingController locationController;
  RelevanceController relevanceController = RelevanceController();

  UniEventType selectedEventType;
  ClassHeader selectedClass;
  String selectedCalendar;
  LocalTime startTime;
  Period duration;
  Map<WeekType, bool> weekSelected = {
    WeekType.odd: null,
    WeekType.even: null,
  };
  Map<DayOfWeek, bool> weekDaySelected = {
    DayOfWeek.monday: false,
    DayOfWeek.tuesday: false,
    DayOfWeek.wednesday: false,
    DayOfWeek.thursday: false,
    DayOfWeek.friday: false,
    DayOfWeek.saturday: false,
    DayOfWeek.sunday: false,
  };

  // TODO(IoanaAlexandru): Make default semester the one closest to now
  int selectedSemester = 1;

  AllDayUniEvent get semester =>
      calendars[selectedCalendar]?.semesters?.elementAt(selectedSemester - 1);

  List<ClassHeader> classHeaders = [];
  User user;
  Map<String, AcademicCalendar> calendars = {};

  @override
  void initState() {
    super.initState();

    user =
        Provider.of<AuthProvider>(context, listen: false).currentUserFromCache;
    Provider.of<ClassProvider>(context, listen: false)
        .fetchClassHeaders(uid: user.uid)
        .then((headers) => setState(() => classHeaders = headers));
    Provider.of<UniEventProvider>(context, listen: false)
        .fetchCalendars()
        .then((calendars) {
      setState(() {
        this.calendars = calendars;
        // TODO(IoanaAlexandru): Make the default calendar the one closest
        // to now and extract calendar/semester from [widget.initialEvent]
        selectedCalendar = calendars.keys.first;
      });

      if (widget.initialEvent != null &&
          widget.initialEvent is RecurringUniEvent) {
        final RecurringUniEvent event = widget.initialEvent;
        if (event.rrule.interval != 1) {
          final rule = WeekYearRules.iso;
          if (rule.getWeekOfWeekYear(semester.start.calendarDate) ==
              rule.getWeekOfWeekYear(event.start.calendarDate)) {
            // Week is odd
            weekSelected[WeekType.even] = false;
            weekSelected[WeekType.odd] = true;
          } else {
            // Week is even
            weekSelected[WeekType.even] = true;
            weekSelected[WeekType.odd] = false;
          }
        }
      }

      setState(() {
        weekSelected[WeekType.even] ??= true;
        weekSelected[WeekType.odd] ??= true;
      });
    });

    selectedEventType = widget.initialEvent?.type;
    selectedClass = widget.initialEvent?.classHeader;
    locationController =
        TextEditingController(text: widget.initialEvent?.location ?? '');

    final startHour = widget.initialEvent?.start?.hourOfDay ?? 8;
    duration = widget.initialEvent?.duration ?? const Period(hours: 2);
    startTime = LocalTime(startHour, 0, 0);

    var initialWeekDays = [
      widget.initialEvent?.start?.dayOfWeek ?? DayOfWeek.monday
    ];
    if (widget.initialEvent != null &&
        widget.initialEvent is RecurringUniEvent) {
      initialWeekDays = (widget.initialEvent as RecurringUniEvent)
          .rrule
          .byWeekDays
          .map((entry) => entry.day)
          .toList();
    }
    for (final initialWeekDay in initialWeekDays) {
      weekDaySelected[initialWeekDay] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: S.of(context).labelUniversityYear,
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          value: selectedCalendar,
                          items: calendars.keys.map((key) {
                            final year = int.tryParse(key);
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(
                                  year != null ? '$year-${year + 1}' : key),
                            );
                          }).toList(),
                          onChanged: (selection) =>
                              selectedCalendar = selection,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: S.of(context).labelSemester,
                            prefixIcon: const Icon(Icons.calendar_view_day),
                          ),
                          value: selectedSemester,
                          items: [1, 2]
                              .map((semester) => DropdownMenuItem<int>(
                                    value: semester,
                                    child: Text(semester.toString()),
                                  ))
                              .toList(),
                          onChanged: (selection) =>
                              selectedSemester = selection,
                        ),
                      ),
                    ],
                  ),
                  RelevanceFormField(
                    controller: relevanceController,
                    validator: (_) {
                      if (relevanceController.customRelevance?.isEmpty ??
                          true) {
                        return S.of(context).warningYouNeedToSelectAtLeastOne;
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<UniEventType>(
                    decoration: InputDecoration(
                      labelText: S.of(context).labelType,
                      prefixIcon: const Icon(Icons.category),
                    ),
                    value: selectedEventType,
                    items: UniEventTypeExtension.classTypes
                        .map(
                          (type) => DropdownMenuItem<UniEventType>(
                            value: type,
                            child: Text(type.toLocalizedString(context)),
                          ),
                        )
                        .toList(),
                    onChanged: (selection) {
                      formKey.currentState.validate();
                      setState(() => selectedEventType = selection);
                    },
                    validator: (selection) {
                      if (selection == null) {
                        return S.of(context).errorEventTypeCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  if (selectedEventType != null)
                    Column(
                      children: [
                        if (classHeaders.isNotEmpty)
                          DropdownButtonFormField<ClassHeader>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: S.of(context).labelClass,
                              prefixIcon: const Icon(Icons.class_),
                            ),
                            value: selectedClass,
                            items: classHeaders
                                .map(
                                  (header) => DropdownMenuItem(
                                      value: header, child: Text(header.name)),
                                )
                                .toList(),
                            onChanged: (selection) {
                              formKey.currentState.validate();
                              setState(() => selectedClass = selection);
                            },
                            validator: (selection) {
                              if (selection == null) {
                                return S.of(context).errorClassCannotBeEmpty;
                              }
                              return null;
                            },
                          ),
                        timeIntervalPicker(),
                        if (weekSelected[WeekType.odd] != null &&
                            weekSelected[WeekType.even])
                          WeekPickerFormField(
                            initialValues: weekSelected,
                            validator: (selection) {
                              if (selection.values
                                  .where((e) => e != false)
                                  .isEmpty) {
                                return S
                                    .of(context)
                                    .warningYouNeedToSelectAtLeastOne;
                              }
                              return null;
                            },
                          ),
                        dayPicker(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppDialog _deletionConfirmationDialog(BuildContext context) => AppDialog(
        icon: const Icon(Icons.delete),
        title: S.of(context).actionDeleteEvent,
        info: S.of(context).messageThisCouldAffectOtherStudents,
        message: S.of(context).messageDeleteEvent,
        actions: [
          AppButton(
            text: S.of(context).actionDeleteEvent,
            width: 130,
            onTap: () async {
              final res =
                  await Provider.of<UniEventProvider>(context, listen: false)
                      .deleteEvent(widget.initialEvent);
              if (res) {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(Routes.home));
                AppToast.show(S.of(context).messageEventDeleted);
              }
            },
          )
        ],
      );

  AppScaffoldAction _saveButton() => AppScaffoldAction(
        text: S.of(context).buttonSave,
        onPressed: () async {
          if (!formKey.currentState.validate()) return;

          LocalDateTime start = semester.startDate.at(startTime);
          if (weekSelected[WeekType.even] && !weekSelected[WeekType.odd]) {
            // Event is every even week, add a week to start date
            start = start.add(const Period(weeks: 1));
          }

          final rrule = RecurrenceRule(
              frequency: Frequency.weekly,
              byWeekDays: (Map<DayOfWeek, bool>.from(weekDaySelected)
                    ..removeWhere((key, value) => !value))
                  .keys
                  .map((weekDay) => ByWeekDayEntry(weekDay))
                  .toSet(),
              interval:
                  weekSelected[WeekType.odd] != weekSelected[WeekType.even]
                      ? 2
                      : 1,
              until: semester.endDate.add(const Period(days: 1)).atMidnight());

          final event = RecurringUniEvent(
              rrule: rrule,
              start: start,
              duration: duration,
              id: widget.initialEvent?.id,
              relevance: relevanceController.customRelevance,
              degree: relevanceController.degree,
              location: locationController.text,
              type: selectedEventType,
              classHeader: selectedClass,
              calendar: calendars[selectedCalendar],
              addedBy: Provider.of<AuthProvider>(context, listen: false)
                  .currentUserFromCache
                  .uid);

          if (widget.initialEvent?.id == null) {
            final res =
                await Provider.of<UniEventProvider>(context, listen: false)
                    .addEvent(event);
            if (res) {
              Navigator.of(context).pop();
              AppToast.show(S.of(context).messageEventAdded);
            }
          } else {
            final res =
                await Provider.of<UniEventProvider>(context, listen: false)
                    .updateEvent(event);
            if (res) {
              Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
              AppToast.show(S.of(context).messageEventEdited);
            }
          }
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

  Widget timeIntervalPicker() {
    final endTime = startTime.add(duration);
    final textColor = Theme.of(context).textTheme.headline4.color;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            Icons.access_time,
            color: CustomIcons.formIconColor(Theme.of(context)),
          ),
          FlatButton(
            onPressed: () async {
              final TimeOfDay start = await showTimePicker(
                context: context,
                initialTime: startTime.toTimeOfDay(),
              );
              setState(() => startTime = start.toLocalTime());
            },
            child: Text(
              startTime.toString('HH:mm'),
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  duration.toString().replaceAll(RegExp(r'[PT]'), ''),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: textColor),
                ),
                DottedLine(
                  lineThickness: 4,
                  dashRadius: 2,
                  dashColor: textColor,
                ),
                // Text-sized box so that the line is centered
                SizedBox(
                    height: Theme.of(context).textTheme.bodyText1.fontSize),
              ],
            ),
          ),
          FlatButton(
            onPressed: () async {
              final TimeOfDay end = await showTimePicker(
                context: context,
                initialTime: startTime.add(duration).toTimeOfDay(),
              );
              setState(() => duration =
                  Period.differenceBetweenTimes(startTime, end.toLocalTime()));
            },
            child: Text(
              endTime.toString('HH:mm'),
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
      ),
    );
  }

  Widget dayPicker() {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.today,
                color: CustomIcons.formIconColor(Theme.of(context))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).labelDay,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .apply(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: weekDaySelected.keys.map((dayOfWeek) {
                          final helperDate = LocalDate.today().next(dayOfWeek);
                          return Row(
                            children: [
                              Selectable(
                                label:
                                    LocalDatePattern.createWithCurrentCulture(
                                            'ddd')
                                        .format(helperDate)
                                        .substring(0, 3),
                                initiallySelected: weekDaySelected[dayOfWeek],
                                onSelected: (selected) => setState(() =>
                                    weekDaySelected[dayOfWeek] = selected),
                              ),
                              const SizedBox(width: 8),
                            ],
                          );
                        }).toList()),
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

class RelevanceFormField extends FormField<List<String>> {
  RelevanceFormField({
    @required this.controller,
    String Function(List<String>) validator,
    Key key,
  }) : super(
          key: key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          builder: (FormFieldState<List<String>> state) {
            controller.onChanged = () {
              state.didChange(controller.customRelevance);
            };
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RelevancePicker(
                    canBePrivate: false,
                    canBeForEveryone: false,
                    filterProvider: Provider.of<FilterProvider>(state.context),
                    controller: controller,
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        state.errorText,
                        style: Theme.of(state.context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.red),
                      ),
                    ),
                ]);
          },
        );

  final RelevanceController controller;
}

class WeekPickerFormField extends FormField<Map<Localizable, bool>> {
  WeekPickerFormField(
      {@required Map<Localizable, bool> initialValues,
      String Function(Map<Localizable, bool>) validator,
      Key key})
      : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: initialValues,
          key: key,
          validator: validator,
          builder: (state) {
            final context = state.context;
            final labels = state.value.keys.toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, left: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.calendar_today,
                            color:
                                CustomIcons.formIconColor(Theme.of(context))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).labelWeek,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .apply(
                                          color: Theme.of(context).hintColor),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      child: ListView.builder(
                                        itemCount: labels.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Selectable(
                                                label: labels[index]
                                                    .toLocalizedString(context),
                                                initiallySelected:
                                                    state.value[labels[index]],
                                                onSelected: (selected) {
                                                  state.value[labels[index]] =
                                                      selected;
                                                  state.didChange(state.value);
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText,
                      style: Theme.of(state.context)
                          .textTheme
                          .caption
                          .copyWith(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        );
}

extension LocalTimeConversion on LocalTime {
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hourOfDay, minute: minuteOfHour);
}

extension TimeOfDayConversion on TimeOfDay {
  LocalTime toLocalTime() => LocalTime(hour, minute, 0);
}
