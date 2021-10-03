import 'package:dart_date/dart_date.dart' show Interval;
import 'package:flutter/material.dart' hide Interval;
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart' hide Interval;

import '../../../../resources/locale_provider.dart';
import '../../../../resources/utils.dart';
import '../../../classes/model/class.dart';
import '../../timetable_utils.dart';
import '../academic_calendar.dart';
import 'uni_event.dart';

class RecurringUniEvent extends UniEvent {
  const RecurringUniEvent({
    @required this.rrule,
    @required DateTime start,
    @required Duration duration,
    @required String id,
    List<String> relevance,
    String degree,
    String name,
    String location,
    Color color,
    UniEventType type,
    ClassHeader classHeader,
    AcademicCalendar calendar,
    String addedBy,
    bool editable,
  })  : assert(rrule != null, 'rrule is null'),
        super(
            name: name,
            location: location,
            start: start,
            duration: duration,
            degree: degree,
            relevance: relevance,
            id: id,
            color: color,
            type: type,
            classHeader: classHeader,
            calendar: calendar,
            addedBy: addedBy,
            editable: editable);

  final RecurrenceRule rrule;

  @override
  String get info {
    if (LocaleProvider.rruleL10n != null) {
      return rrule.toText(l10n: LocaleProvider.rruleL10n);
    }
    return '';
  }

  RecurrenceRule get rruleBasedOnCalendar {
    final RecurrenceRule rrule = this.rrule;
    if (calendar != null && rrule.frequency == Frequency.weekly) {
      var weeks = calendar.nonHolidayWeeks;

      // Get the correct sequence of weeks for this event.
      //
      // For example, if the first academic calendar week is 40 and the event
      // starts on week 41 and repeats every two weeks - get every odd-index
      // week in the non holiday weeks.
      // This is necessary because if an "even" week is followed by a one-week
      // holiday, the week that comes after the holiday should be considered
      // an "odd" week, even though its number in the calendar would have the
      // same parity as the week before the holiday.
      if (rrule.interval != 1) {
        // Check whether the first calendar week is odd
        final bool startOdd = weeks.first.isOdd;
        weeks = weeks
            .whereIndex((index) =>
                (startOdd ? index : index + 1) % rrule.interval !=
                weeks.lookup(WeekYearRules.iso
                        .getWeekOfWeekYear(LocalDate.dateTime(start))) %
                    rrule.interval)
            .toSet();
      }
      return rrule.copyWith(
          frequency: Frequency.yearly,
          interval: 1,
          byWeekDays: rrule.byWeekDays.isNotEmpty
              ? rrule.byWeekDays
              : {ByWeekDayEntry(start.weekday)},
          byWeeks: weeks);
    }
    return rrule;
  }

  @override
  Iterable<UniEventInstance> generateInstances(
      {Interval intersectingInterval}) sync* {
    final RecurrenceRule rrule = rruleBasedOnCalendar;

    for (final start
        in rrule.getInstances(start: start.copyWith(isUtc: true))) {
      final DateTime end = start.add(duration);
      if (intersectingInterval != null) {
        if (end < intersectingInterval.start) continue;
        if (start > intersectingInterval.end) break;
      }

      bool skip = false;
      for (final holiday in calendar?.holidays ?? []) {
        final holidayInterval = Interval(holiday.startDate, holiday.endDate);
        if (holidayInterval.includes(start)) {
          // Skip holidays
          skip = true;
        }
      }

      if (!skip) {
        yield UniEventInstance(
          title: name,
          mainEvent: this,
          color: color,
          start: start.copyWith(isUtc: true),
          end: end.copyWith(isUtc: true),
          location: location,
        );
      }
    }
  }
}
