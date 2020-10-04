import 'dart:async';

import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/all_day_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/recurring_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

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

  Map<String, dynamic> toJSON() {
    final json = {
      'years': years,
      'months': months,
      'weeks': weeks,
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'milliseconds': milliseconds,
      'microseconds': microseconds,
      'nanoseconds': nanoseconds
    };

    return json..removeWhere((key, value) => value == 0);
  }
}

extension LocalDateTimeExtension on LocalDateTime {
  Timestamp toTimestamp() => Timestamp.fromDate(toDateTimeLocal());
}

extension UniEventExtension on UniEvent {
  static UniEvent fromJSON(String id, Map<String, dynamic> json,
      {ClassHeader classHeader,
      Map<String, AcademicCalendar> calendars = const {}}) {
    if (json['start'] == null ||
        (json['duration'] == null && json['end'] == null)) return null;

    final type = UniEventTypeExtension.fromString(json['type']);
    if (json['end'] != null) {
      return AllDayUniEvent(
        id: id,
        type: type,
        name: json['name'],
        // Convert time to UTC and then to local time
        start: (json['start'] as Timestamp).toLocalDateTime().calendarDate,
        end: (json['end'] as Timestamp).toLocalDateTime().calendarDate,
        location: json['location'],
        // TODO(IoanaAlexandru): Allow users to set event colours in settings
        color: type.color,
        classHeader: classHeader,
        calendar: calendars[json['calendar']],
        degree: json['degree'],
        relevance: json['relevance'] == null
            ? null
            : List<String>.from(json['relevance']),
        addedBy: json['addedBy'],
      );
    } else if (json['rrule'] != null) {
      return RecurringUniEvent(
        rrule: RecurrenceRule.fromString(json['rrule']),
        id: id,
        type: type,
        name: json['name'],
        // Convert time to UTC and then to local time
        start: (json['start'] as Timestamp).toLocalDateTime(),
        duration: PeriodExtension.fromJSON(json['duration']),
        location: json['location'],
        // TODO(IoanaAlexandru): Allow users to set event colours in settings
        color: type.color,
        classHeader: classHeader,
        calendar: calendars[json['calendar']],
        degree: json['degree'],
        relevance: json['relevance'] == null
            ? null
            : List<String>.from(json['relevance']),
        addedBy: json['addedBy'],
      );
    } else {
      return UniEvent(
        id: id,
        type: type,
        name: json['name'],
        // Convert time to UTC and then to local time
        start: (json['start'] as Timestamp).toLocalDateTime(),
        duration: PeriodExtension.fromJSON(json['duration']),
        location: json['location'],
        // TODO(IoanaAlexandru): Allow users to set event colours in settings
        color: type.color,
        classHeader: classHeader,
        calendar: calendars[json['calendar']],
        degree: json['degree'],
        relevance: json['relevance'] == null
            ? null
            : List<String>.from(json['relevance']),
        addedBy: json['addedBy'],
      );
    }
  }

  Map<String, dynamic> toData() {
    final type = this.type.toString().split('.').last;

    final json = {
      'type': type,
      'name': name,
      'start': start.toTimestamp(),
      'duration': duration.toJSON(),
      'location': location,
      'class': classHeader.id,
      'degree': degree,
      'relevance': relevance,
      'addedBy': addedBy,
    };

    if (this is RecurringUniEvent) {
      json['rrule'] = (this as RecurringUniEvent).rrule.toString();
    }

    if (this is AllDayUniEvent) {
      json['end'] = (this as AllDayUniEvent).endDate.atMidnight().toTimestamp();
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

  static AcademicCalendar fromSnap(DocumentSnapshot snap) {
    return AcademicCalendar(
      semesters: _eventsFromMapList(snap.data['semesters'], 'semester'),
      holidays: _eventsFromMapList(snap.data['holidays'], 'holiday'),
      exams: _eventsFromMapList(snap.data['exams'], 'examSession'),
    );
  }
}

class UniEventProvider extends EventProvider<UniEventInstance>
    with ChangeNotifier {
  UniEventProvider({AuthProvider authProvider})
      : _authProvider = authProvider ?? AuthProvider() {
    fetchCalendars();
  }

  final Map<String, AcademicCalendar> _calendars = {};
  ClassProvider _classProvider;
  FilterProvider _filterProvider;
  final AuthProvider _authProvider;
  List<String> _classIds = [];
  Filter _filter;
  List<UniEvent> eventsCache;
  bool empty;

  Future<Map<String, AcademicCalendar>> fetchCalendars() async {
    final QuerySnapshot query =
        await Firestore.instance.collection('calendars').getDocuments();
    for (final doc in query.documents) {
      _calendars[doc.documentID] = AcademicCalendarExtension.fromSnap(doc);
    }

    notifyListeners();
    return _calendars;
  }

  Future<List<UniEvent>> get _events async {
    if (eventsCache != null) return eventsCache;

    if (!_authProvider.isAuthenticatedFromCache ||
        _filter == null ||
        _calendars == null) return [];

    var events = <UniEvent>[];

    if (_filter.relevantNodes.length > 1) {
      for (final classId in _classIds ?? []) {
        final query = await Firestore.instance
            .collection('events')
            .where('class', isEqualTo: classId)
            .where('degree', isEqualTo: _filter.baseNode)
            .where('relevance',
                arrayContainsAny: _filter.relevantNodes..remove('All'))
            .getDocuments();

        for (final doc in query.documents) {
          ClassHeader classHeader;
          if (doc.data['class'] != null) {
            classHeader =
                await _classProvider.fetchClassHeader(doc.data['class']);
          }

          events.add(UniEventExtension.fromJSON(doc.documentID, doc.data,
              classHeader: classHeader, calendars: _calendars));
        }
      }
    }

    events = events.where((event) => event != null).toList();
    empty = events.isEmpty;
    eventsCache = events;
    notifyListeners();
    return eventsCache;
  }

  @override
  Stream<Iterable<UniEventInstance>> getAllDayEventsIntersecting(
      DateInterval interval) {
    return Stream<List<UniEvent>>.fromFuture(_events).map((events) => events
        .map((event) => event.generateInstances(intersectingInterval: interval))
        .expand((i) => i)
        .allDayEvents
        .followedBy(_calendars.values.map((cal) {
          final List<AllDayUniEvent> events = cal.holidays + cal.exams;
          return events
              .where((event) =>
                  event.relevance == null ||
                  (event.degree == _filter.baseNode &&
                      event.relevance.any(_filter.relevantNodes.contains)))
              .map((e) => e.generateInstances(intersectingInterval: interval))
              .expand((e) => e);
        }).expand((e) => e)));
  }

  @override
  Stream<Iterable<UniEventInstance>> getPartDayEventsIntersecting(
      LocalDate date) {
    return Stream<List<UniEvent>>.fromFuture(_events).map((events) => events
        .map((event) => event.generateInstances(
            intersectingInterval: DateInterval(date, date)))
        .expand((i) => i)
        .partDayEvents);
  }

  void updateClasses(ClassProvider classProvider) {
    _classProvider = classProvider;
    _classProvider.fetchUserClassIds(uid: _authProvider.uid).then((classIds) {
      _classIds = classIds;
      eventsCache = null;
      notifyListeners();
    });
  }

  void updateFilter(FilterProvider filterProvider) {
    _filterProvider = filterProvider;
    _filterProvider.fetchFilter().then((filter) {
      _filter = filter;
      eventsCache = null;
      notifyListeners();
    });
  }

  Future<bool> addEvent(UniEvent event, {BuildContext context}) async {
    try {
      await Firestore.instance.collection('events').add(event.toData());
      _eventsCache = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }

  Future<bool> deleteEvent(UniEvent event, {BuildContext context}) async {
    try {
      DocumentReference ref;
      ref = Firestore.instance.collection('events').document(event.id);
      await ref.delete();
      _eventsCache = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }

  @override
  // ignore: must_call_super
  void dispose() {
    // TODO(IoanaAlexandru): Find a better way to prevent Timetable from calling dispose on this provider
  }

  void _errorHandler(dynamic e, BuildContext context) {
    print(e.message);
    if (context != null) {
      if (e.message.contains('PERMISSION_DENIED')) {
        AppToast.show(S.of(context).errorPermissionDenied);
      } else {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
    }
  }
}
