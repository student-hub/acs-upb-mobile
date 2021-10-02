import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/all_day_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_text_patterns.dart';

// ignore: implementation_imports
import 'package:timetable/src/header/date_indicator.dart';

// ignore: implementation_imports
import 'package:timetable/src/theme.dart';

// ignore: implementation_imports
import 'package:timetable/src/utils/utils.dart';
import 'package:provider/provider.dart';

class LeadHeader extends StatefulWidget {
  const LeadHeader(this.date, {Key key}) : super(key: key);

  final LocalDate date;

  static var academicWeekNumber;

  @override
  _leadHeaderState createState() => _leadHeaderState();
}

class _leadHeaderState extends State<LeadHeader> {
  List<ClassHeader> classHeaders = [];
  List<Person> classTeachers = [];
  User user;
  AcademicCalendar calendar;
  Map<String, AcademicCalendar> calendars = {};
  int academicWeek;
  Set<int> HolidayWeeks = new Set();

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
              border: new Border.all(color: defaultBackgroundColor, width: 1)),
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
      // print(widget.date);
      LocalDate first_sem_start = calendar.semesters.first.startDate;
      Period dif;
      var nonHolidayWeeks = calendar.nonHolidayWeeks;
      // print(nonHolidayWeeks);
      for (var i = 1; i < 53; i++) {
        if (!nonHolidayWeeks.contains(i)) HolidayWeeks.add(i);
      }
      // print(nonHolidayWeeks);
      //  print("----");
      //  print(HolidayWeeks);
      var week =
          ((widget.date.dayOfYear - widget.date.dayOfWeek.value + 10) / 7)
              .floor();
      if (LeadHeader.academicWeekNumber == false) {
        return week.toString();
      } else {
        if (HolidayWeeks.contains(week)) return "-";
        dif = widget.date.periodSince(first_sem_start).normalize();
        //print(dif);
        academicWeek = (dif.days / 7).floor() + 1;
        // print(dif.weeks);
        // print(dif.toString()+" "+academicWeek.toString()+" ");
        // print((academicWeek + 5 * dif.months)+1);
        if (dif.months > 0) {
          academicWeek = (academicWeek + 4 * dif.months) + 1;
        }

        getAcademicWeek();
        return academicWeek.toString();
      }
    } else
      return "0";
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
        calendar = calendars.values.last;
      });
    });
  }

  void getAcademicWeek() {
    int d = 0;
    // print(academicWeek);
    if (widget.date.year == 2021) {
      return;
    }
    d += 1;
    for (var h in HolidayWeeks) {
      if (((widget.date.dayOfYear - widget.date.dayOfWeek.value + 10) / 7)
              .floor() >
          h) {
        d += 1;
      }
    }

    academicWeek -= d;
  }
}
