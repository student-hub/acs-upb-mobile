import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/all_day_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

// ignore: implementation_imports
import 'package:timetable/src/theme.dart';

// ignore: implementation_imports
import 'package:provider/provider.dart';

class LeadHeader extends StatefulWidget {
  const LeadHeader(this.date, {Key key}) : super(key: key);
  final LocalDate date;
  static var academicWeekNumber = true;

  @override
  _LeadHeaderState createState() => _LeadHeaderState();
}

class _LeadHeaderState extends State<LeadHeader> {
  List<ClassHeader> classHeaders = [];
  List<Person> classTeachers = [];
  User user;
  AcademicCalendar calendar;
  Map<String, AcademicCalendar> calendars = {};
  int academicWeek;
  Set<int> holidayWeeks = {};

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final timetableTheme = context.timetableTheme;
    final defaultBackgroundColor = theme.contrastColor.withOpacity(0.12);
    final textStyle = timetableTheme?.weekIndicatorTextStyle ??
        TextStyle(
            color: defaultBackgroundColor
                .alphaBlendOn(theme.scaffoldBackgroundColor)
                .mediumEmphasisOnColor,
            fontSize: 14);

    return Container(
      child: Center(
        child: Container(
          width: 27,
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: defaultBackgroundColor,
              border: Border.all(color: defaultBackgroundColor, width: 1)),
          child: Text(
            getWeekNumber(),
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String getWeekNumber() {
    if (calendar != null) {
      final List<int> nonHolidayWeeks = calendar.nonHolidayWeeks.toList();

      for (var i = 1; i < 53; i++) {
        if (!nonHolidayWeeks.contains(i)) holidayWeeks.add(i);
      }

      final week =
          ((widget.date.dayOfYear - widget.date.dayOfWeek.value + 10) / 7)
              .floor();
      if (LeadHeader.academicWeekNumber == false) {
        return week.toString();
      } else {
        if (!nonHolidayWeeks.contains(week)) {
          return 'H';
        } else {
          return (nonHolidayWeeks.indexOf(week) + 1).toString();
        }
      }
    } else {
      return ' ';
    }
  }

  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
    user =
        Provider.of<AuthProvider>(context, listen: false).currentUserFromCache;
    Provider.of<ClassProvider>(context, listen: false)
        .fetchClassHeaders(uid: user.uid)
        .then((headers) => setState(() => classHeaders = headers));
    Provider.of<PersonProvider>(context, listen: false)
        .fetchPeople()
        .then((teachers) => setState(() => classTeachers = teachers));
    Provider.of<UniEventProvider>(context, listen: false)
        .fetchCalendars()
        .then((calendars) {
      setState(() {
        this.calendars = calendars;
      });
    });
  }
}
