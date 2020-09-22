import 'dart:async';

import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:time_machine/src/date_interval.dart';
import 'package:time_machine/src/localdate.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

extension UniEventTypeExtension on UniEventType {
  static UniEventType fromString(String string) {
    switch (string) {
      case 'lab':
        return UniEventType.lab;
      case 'lecture':
        return UniEventType.lecture;
      case 'seminar':
        return UniEventType.seminar;
      case 'sports':
        return UniEventType.sports;
      default:
        return UniEventType.other;
    }
  }

  get color {
    switch (this) {
      case UniEventType.lecture:
        return Colors.pinkAccent;
      case UniEventType.lab:
        return Colors.blueAccent;
      case UniEventType.seminar:
        return Colors.orangeAccent;
      case UniEventType.sports:
        return Colors.greenAccent;
      case UniEventType.other:
        return Colors.white;
    }
  }
}

extension PeriodExtension on Period {
  static Period fromJSON(Map<String, dynamic> json) {
    return Period(
      years: json['years'] ?? 0,
      months: json['months'] ?? 0,
      weeks: json['weeks'] ?? 0,
      days: json['days'] ?? 0,
      hours: json['hours'] ?? 0,
      minutes: json['minutes'] ?? 0,
      seconds: json['seconds'] ?? 0,
      milliseconds: json['milliseconds'] ?? 0,
      microseconds: json['microseconds'] ?? 0,
      nanoseconds: json['nanoseconds'] ?? 0,
    );
  }
}

extension TimestampExtension on Timestamp {
  LocalDateTime toLocalDateTime() => LocalDateTime.dateTime(this.toDate())
      .inZoneStrictly(DateTimeZone.utc)
      .withZone(DateTimeZone.local)
      .localDateTime;
}

extension UniEventExtension on UniEvent {
  static UniEvent fromSnap(DocumentSnapshot snap,
      {ClassHeader classHeader, Map<String, AcademicCalendar> calendars}) {
    if (snap.data['start'] == null || snap.data['duration'] == null)
      return null;

    UniEventType type = UniEventTypeExtension.fromString(snap.data['type']);
    return UniEvent(
      rrule: RecurrenceRule.fromString(snap.data['rrule']),
      id: snap.documentID,
      type: type,
      name: snap.data['name'],
      // Convert time to UTC and then to local time
      start: (snap.data['start'] as Timestamp).toLocalDateTime(),
      duration: PeriodExtension.fromJSON(snap.data['duration']),
      location: snap.data['location'],
      // TODO: Allow users to set event colours in settings
      color: type.color,
      classHeader: classHeader,
      calendar: calendars[snap.data['calendar']],
    );
  }
}

extension AcademicCalendarExtension on AcademicCalendar {
  static AcademicCalendar fromSnap(DocumentSnapshot snap) {
    return AcademicCalendar(
      semesters: snap.data['semesters']
          .map<NamedInterval>((s) => NamedInterval(
                localizedName: Map<String, String>.from(s['name'] ?? {}),
                start: (s['start'] as Timestamp).toLocalDateTime().calendarDate,
                end: (s['end'] as Timestamp).toLocalDateTime().calendarDate,
              ))
          .toList(),
      holidays: snap.data['holidays']
          .map<NamedInterval>((h) => NamedInterval(
                localizedName: Map<String, String>.from(h['name'] ?? {}),
                start: (h['start'] as Timestamp).toLocalDateTime().calendarDate,
                end: (h['end'] as Timestamp).toLocalDateTime().calendarDate,
              ))
          .toList(),
    );
  }
}

class UniEventProvider extends EventProvider<UniEventInstance>
    with ChangeNotifier {
  Map<String, AcademicCalendar> calendars = {'2020': AcademicCalendar()};
  ClassProvider classProvider;
  FilterProvider filterProvider;
  final AuthProvider authProvider;
  List<String> classIds = [];
  Filter filter;

  UniEventProvider({AuthProvider authProvider})
      : authProvider = authProvider ?? AuthProvider() {
    fetchCalendars();
  }

  void fetchCalendars() async {
    QuerySnapshot query =
        await Firestore.instance.collection('calendars').getDocuments();
    query.documents.forEach((doc) {
      calendars[doc.documentID] = AcademicCalendarExtension.fromSnap(doc);
    });
    notifyListeners();
  }

  Stream<List<UniEvent>> get _events {
    if (!authProvider.isAuthenticatedFromCache || filter == null)
      return Stream.value([]);

    List<Stream<List<UniEvent>>> streams = [];

    classIds?.forEach((classId) {
      Stream<List<UniEvent>> stream = Firestore.instance
          .collection('events')
          .where('class', isEqualTo: classId)
          .where('relevance', arrayContainsAny: filter.relevantNodes)
          .snapshots()
          .asyncMap((snapshot) async {
        List<UniEvent> events = [];

        try {
          for (var doc in snapshot.documents) {
            ClassHeader classHeader;
            if (doc.data['class'] != null) {
              classHeader =
                  await classProvider.fetchClassHeader(doc.data['class']);
            }

            events.add(UniEventExtension.fromSnap(doc,
                classHeader: classHeader, calendars: calendars));
          }
          return events.where((element) => element != null).toList();
        } catch (e) {
          print(e);
          return events;
        }
      });
      streams.add(stream);
    });

    var stream = StreamZip(streams);

    // Flatten zipped streams
    return stream.map((events) => events.expand((i) => i).toList());
  }

  @override
  Stream<Iterable<UniEventInstance>> getAllDayEventsIntersecting(
      DateInterval interval) {
    return _events.map((events) => events
        .map((event) => event.generateInstances(intersectingInterval: interval))
        .expand((i) => i)
        .followedBy(calendars.values
            .map((cal) => cal.generateHolidayInstances())
            .expand((e) => e))
        .allDayEvents);
  }

  @override
  Stream<Iterable<UniEventInstance>> getPartDayEventsIntersecting(
      LocalDate date) {
    return _events.map((events) => events
        .map((event) => event.generateInstances(
            intersectingInterval: DateInterval(date, date)))
        .expand((i) => i)
        .partDayEvents);
  }

  void updateClasses(ClassProvider classProvider) {
    this.classProvider = classProvider;
    fetchClassIds();
  }

  void fetchClassIds() async {
    classIds = await classProvider.fetchUserClassIds(uid: authProvider.uid);
    notifyListeners();
  }

  void updateFilter(FilterProvider filterProvider) {
    this.filterProvider = filterProvider;
    fetchFilter();
  }

  void fetchFilter() async {
    filter = await filterProvider.fetchFilter();
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: Find a better way to prevent Timetable from calling dispose on this provider
  }
}
