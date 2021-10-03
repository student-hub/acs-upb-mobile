import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart' show Interval;
import 'package:flutter/material.dart' hide Interval;
import 'package:googleapis/calendar/v3.dart' as g_cal;
import 'package:recase/recase.dart';
import 'package:rrule/rrule.dart';
import 'package:timetable/timetable.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/toast.dart';
import '../../classes/model/class.dart';
import '../../classes/service/class_provider.dart';
import '../../filter/model/filter.dart';
import '../../filter/service/filter_provider.dart';
import '../../people/model/person.dart';
import '../../people/service/person_provider.dart';
import '../model/academic_calendar.dart';
import '../model/events/all_day_event.dart';
import '../model/events/class_event.dart';
import '../model/events/recurring_event.dart';
import '../model/events/uni_event.dart';
import '../timetable_utils.dart';
import 'google_calendar_services.dart';

extension DurationExtension on Duration {
  static Duration fromJSON(Map<String, dynamic> json) {
    return Duration(
      days: json['days'] ?? 0,
      hours: json['hours'] ?? 0,
      minutes: json['minutes'] ?? 0,
      seconds: json['seconds'] ?? 0,
      milliseconds: json['milliseconds'] ?? 0,
      microseconds: json['microseconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJSON() {
    final json = {
      'microseconds': inMicroseconds,
    };

    return json..removeWhere((key, value) => value == 0);
  }
}

extension DateTimeExtension on DateTime {
  Timestamp toTimestamp() => Timestamp.fromDate(this);
}

extension UniEventExtension on UniEvent {
  static UniEvent fromJSON(String id, Map<String, dynamic> json,
      {ClassHeader classHeader,
      Person teacher,
      Map<String, AcademicCalendar> calendars = const {}}) {
    if (json['start'] == null ||
        (json['duration'] == null && json['end'] == null)) return null;

    final type = UniEventTypeExtension.fromString(json['type']);

    if (json['end'] != null) {
      return AllDayUniEvent(
        id: id,
        type: type,
        name: json['name'],
        start: (json['start'] as Timestamp).toDate().copyWith(isUtc: true),
        end: (json['end'] as Timestamp).toDate().copyWith(isUtc: true),
        location: json['location'],
        // TODO(IoanaAlexandru): Allow users to set event colours in settings, #168

        color: type.color,
        classHeader: classHeader,
        calendar: calendars[json['calendar']],
        degree: json['degree'],
        relevance: json['relevance'] == null
            ? null
            : List<String>.from(json['relevance']),
        addedBy: json['addedBy'],
        editable:
            json['editable'] ?? false, // Holidays are read-only by default
      );
    } else if (json['rrule'] != null && json['teacher'] == null) {
      return RecurringUniEvent(
        rrule: RecurrenceRule.fromString(json['rrule']),
        id: id,
        type: type,
        name: json['name'],
        start: (json['start'] as Timestamp).toDate(),
        duration: DurationExtension.fromJSON(json['duration']),
        location: json['location'],
        // TODO(IoanaAlexandru): Allow users to set event colours in settings, #168
        color: type.color,
        classHeader: classHeader,
        calendar: calendars[json['calendar']],
        degree: json['degree'],
        relevance: json['relevance'] == null
            ? null
            : List<String>.from(json['relevance']),
        addedBy: json['addedBy'],
        editable: json['editable'] ?? true,
      );
    } else if (json['rrule'] != null && json['teacher'] != null) {
      return ClassEvent(
        teacher: teacher,
        rrule: RecurrenceRule.fromString(json['rrule']),
        id: id,
        type: type,
        name: json['name'],
        start: (json['start'] as Timestamp).toDate(),
        duration: DurationExtension.fromJSON(json['duration']),
        location: json['location'],
        color: type.color,
        classHeader: classHeader,
        calendar: calendars[json['calendar']],
        degree: json['degree'],
        relevance: json['relevance'] == null
            ? null
            : List<String>.from(json['relevance']),
        addedBy: json['addedBy'],
        editable: json['editable'] ?? true,
      );
    } else {
      return UniEvent(
        id: id,
        type: type,
        name: json['name'],
        start: (json['start'] as Timestamp).toDate(),
        duration: DurationExtension.fromJSON(json['duration']),
        location: json['location'],
        // TODO(IoanaAlexandru): Allow users to set event colours in settings, #168
        color: type.color,
        classHeader: classHeader,
        calendar: calendars[json['calendar']],
        degree: json['degree'],
        relevance: json['relevance'] == null
            ? null
            : List<String>.from(json['relevance']),
        addedBy: json['addedBy'],
        editable: json['editable'] ?? true,
      );
    }
  }

  Map<String, dynamic> toJSON() {
    final type = this.type.toShortString();

    final json = {
      'type': type,
      'name': name,
      'start': start.copyWith(isUtc: false).toTimestamp(),
      'duration': duration.toJSON(),
      'location': location,
      'class': classHeader.id,
      'degree': degree,
      'relevance': relevance,
      'calendar': calendar.id,
      'addedBy': addedBy,
    };

    if (this is RecurringUniEvent) {
      json['rrule'] = (this as RecurringUniEvent).rrule.toString();
    }

    if (this is AllDayUniEvent) {
      json['end'] = (this as AllDayUniEvent).endDate.atMidnight().toTimestamp();
    }

    if (this is ClassEvent) {
      json['teacher'] = (this as ClassEvent).teacher?.name;
    }

    return json;
  }
}

extension AcademicCalendarExtension on AcademicCalendar {
  static List<AllDayUniEvent> _eventsFromMapList(
          List<dynamic> list, String type) =>
      List<AllDayUniEvent>.from((list ?? []).asMap().map((index, e) {
        e['type'] = type;
        return MapEntry(
            index, UniEventExtension.fromJSON(type + index.toString(), e));
      }).values);

  static AcademicCalendar fromSnap(
      DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data();
    return AcademicCalendar(
      id: snap.id,
      semesters: _eventsFromMapList(data['semesters'], 'semester'),
      holidays: _eventsFromMapList(data['holidays'], 'holiday'),
      exams: _eventsFromMapList(data['exams'], 'examSession'),
    );
  }
}

class UniEventProvider with ChangeNotifier {
  UniEventProvider({AuthProvider authProvider, PersonProvider personProvider})
      : _authProvider = authProvider ?? AuthProvider(),
        _personProvider = personProvider ?? PersonProvider() {
    fetchCalendars();
  }

  final Map<String, AcademicCalendar> _calendars = {};
  ClassProvider _classProvider;
  FilterProvider _filterProvider;
  final AuthProvider _authProvider;
  final PersonProvider _personProvider;
  List<String> _classIds = [];
  Filter _filter;
  bool empty;

  Future<Map<String, AcademicCalendar>> fetchCalendars() async {
    final QuerySnapshot<Map<String, dynamic>> query =
        await FirebaseFirestore.instance.collection('calendars').get();
    for (final doc in query.docs) {
      _calendars[doc.id] = AcademicCalendarExtension.fromSnap(doc);
    }

    notifyListeners();
    return _calendars;
  }

  Future<void> checkIfEmpty(List<Stream<List<UniEvent>>> streams) async {
    for (final stream in streams) {
      if ((await stream.first)?.isNotEmpty ?? false) {
        empty = false;
        return;
      }
    }
    empty = true;
  }

  Stream<List<UniEvent>> get _events {
    if (!_authProvider.isAuthenticated ||
        _filter == null ||
        _calendars == null) {
      return Stream.value([]);
    }

    final streams = <Stream<List<UniEvent>>>[];

    if (_filter.relevantNodes.length > 1) {
      for (final classId in _classIds ?? []) {
        final Stream<List<UniEvent>> stream = FirebaseFirestore.instance
            .collection('events')
            .where('class', isEqualTo: classId)
            .where('degree', isEqualTo: _filter.baseNode)
            .where('relevance',
                arrayContainsAny: _filter.relevantNodes..remove('All'))
            .snapshots()
            .asyncMap((snapshot) async {
          final events = <UniEvent>[];
          try {
            for (final doc in snapshot.docs) {
              ClassHeader classHeader;
              Person teacher;
              final data = doc.data();
              if (data['class'] != null) {
                classHeader =
                    await _classProvider.fetchClassHeader(data['class']);
              }
              if (data['teacher'] != null) {
                teacher = await _personProvider.fetchPerson(data['teacher']);
              }

              events.add(UniEventExtension.fromJSON(doc.id, data,
                  classHeader: classHeader,
                  teacher: teacher,
                  calendars: _calendars));
            }
            return events.where((element) => element != null).toList();
          } catch (e) {
            print(e);
            return events;
          }
        });
        streams.add(stream);
      }
    }

    checkIfEmpty(streams);

    final stream = StreamZip(streams);

    // Flatten zipped streams
    return stream.map((events) => events.expand((i) => i).toList());
  }

  Future<void> exportToGoogleCalendar() async {
    final Stream<List<UniEvent>> eventsStream = _events;
    final List<UniEvent> uniEvents = await eventsStream.first;

    final List<g_cal.Event> googleCalendarEvents = [];
    for (final UniEvent uniEvent in uniEvents) {
      final g_cal.Event googleCalendarEvent = convertEvent(uniEvent);
      googleCalendarEvents.add(googleCalendarEvent);
    }
    await insertGoogleEvents(googleCalendarEvents);
  }

  Stream<List<UniEventInstance>> getEventsIntersecting(Interval interval) {
    final streams = <Stream<Iterable<UniEventInstance>>>[];
    final Stream<Iterable<UniEventInstance>> allDay =
        getAllDayEventsIntersecting(interval);
    final Stream<Iterable<UniEventInstance>> partDay =
        getPartDayEventsIntersecting(interval);
    streams
      ..add(allDay)
      ..add(partDay);
    final StreamZip<Iterable<UniEventInstance>> stream = StreamZip(streams);

    // Flatten zipped streams
    return stream.map(
      (events) => events
          .expand((i) => i)
          .map(
            (UniEventInstance event) =>
                event.copyWith(start: event.start, end: event.end),
          )
          .toList(),
    );
  }

  Iterable<AllDayUniEvent> getAllDayUniEventsForCalendar(AcademicCalendar cal) {
    final List<AllDayUniEvent> events = cal.holidays + cal.exams;
    return events.where((event) =>
        event.relevance == null ||
        (_filter != null &&
            event.degree == _filter.baseNode &&
            event.relevance.any(_filter.relevantNodes.contains)));
  }

  Stream<Iterable<UniEventInstance>> getAllDayEventsIntersecting(
      Interval interval) {
    return _events.map(
      (events) => events
          .map((event) =>
              event.generateInstances(intersectingInterval: interval))
          .expand((i) => i)
          .where((event) => event.isAllDay)
          .followedBy(
            _calendars.values.map(
              (AcademicCalendar cal) {
                final Iterable<AllDayUniEvent> allDayUniEvents =
                    getAllDayUniEventsForCalendar(cal);
                final Iterable<UniEventInstance> allDayUniEventInstances =
                    allDayUniEvents
                        .map((e) =>
                            e.generateInstances(intersectingInterval: interval))
                        .expand((e) => e);
                return allDayUniEventInstances;
              },
            ).expand((e) => e),
          ),
    );
  }

  Stream<Iterable<UniEventInstance>> getPartDayEventsIntersecting(
      Interval interval) {
    return _events.map((events) => events
        .map((event) => event.generateInstances(
            intersectingInterval: Interval(interval.start, interval.end)))
        .expand((i) => i)
        .where((event) => event.isPartDay));
  }

  Future<Iterable<UniEventInstance>> getUpcomingEvents(DateTime date,
      {int limit = 3}) async {
    return _events
        .map((events) => events
            .where((event) => !(event is AllDayUniEvent))
            .map((event) => event.generateInstances(
                intersectingInterval: Interval(date, date.addDays(6))))
            .expand((i) => i)
            .sortedByStartLength()
            .where((element) => element.end.isAfter(DateTime.now()))
            .take(limit))
        .first;
  }

  Future<Iterable<UniEvent>> getAllEventsOfClass(String classId) async {
    return _events
        .map((events) =>
            events.where((event) => event.classHeader.id == classId))
        .first;
  }

  void updateClasses(ClassProvider classProvider) {
    _classProvider = classProvider;
    _classProvider.fetchUserClassIds(_authProvider.uid).then((classIds) {
      _classIds = classIds;
      notifyListeners();
    });
  }

  void updateFilter(FilterProvider filterProvider) {
    _filterProvider = filterProvider;
    _filterProvider.fetchFilter().then((filter) {
      _filter = filter;
      notifyListeners();
    });
  }

  Future<bool> addEvent(UniEvent event) async {
    try {
      await FirebaseFirestore.instance.collection('events').add(event.toJSON());
      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> updateEvent(UniEvent event) async {
    try {
      final ref = FirebaseFirestore.instance.collection('events').doc(event.id);

      if ((await ref.get()).data == null) {
        print('Event not found.');
        return false;
      }

      await ref.update(event.toJSON());
      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  Future<bool> deleteEvent(UniEvent event) async {
    try {
      DocumentReference ref;
      ref = FirebaseFirestore.instance.collection('events').doc(event.id);
      await ref.delete();
      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e);
      return false;
    }
  }

  void _errorHandler(dynamic e, {bool showToast = true}) {
    print(e.message);
    if (showToast) {
      if (e.message.contains('PERMISSION_DENIED')) {
        AppToast.show(S.current.errorPermissionDenied);
      } else {
        AppToast.show(S.current.errorSomethingWentWrong);
      }
    }
  }

  String updateTimetablePageTitle(DateController _dateController) {
    return _authProvider.isAuthenticated && !_authProvider.isAnonymous
        ? _dateController?.currentMonth?.titleCase
        : S.current.navigationTimetable;
  }
}
