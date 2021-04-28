import 'dart:io' show Platform;
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart';

class GoogleApiHelper {
  GoogleApiHelper();

  static const List<String> _scopes = [CalendarApi.calendarScope];

  static List<String> get scopes =>
      _scopes; // allows us to see, edit, share, and permanently delete all the calendars you can access using Google Calendar.

  static ClientId get credentials {
    String _clientIdString;
    // Our project IDs, used to identify an app to Google's OAuth servers.
    if (Platform.isAndroid) {
      _clientIdString =
          '611150208061-4ftun8ln4v9hm1mocqs1vqcftaanj8sj.apps.googleusercontent.com';
    } else if (Platform.isIOS) {
      _clientIdString =
          '611150208061-4ftun8ln4v9hm1mocqs1vqcftaanj8sj.apps.googleusercontent.com';
    } else if (kIsWeb) {
      _clientIdString =
          '611150208061-ljqdu5mfmjisdi1h3ics3l2sirvtpljk.apps.googleusercontent.com';
    } else {
      _clientIdString =
          '611150208061-ljqdu5mfmjisdi1h3ics3l2sirvtpljk.apps.googleusercontent.com';
    }
    return ClientId(_clientIdString, '');
  }
}

enum GoogleCalendarColorNames {
  undefined,
  lavender,
  sage,
  grape,
  flamingo,
  banana,
  tangerine,
  peacock,
  graphite,
  blueberry,
  basil,
  tomato
}

extension UniEventTypeGCalColor on UniEventType {
  GoogleCalendarColorNames get googleCalendarColor {
    switch (this) {
      case UniEventType.lecture:
        return GoogleCalendarColorNames.flamingo;
      case UniEventType.lab:
        return GoogleCalendarColorNames.peacock;
      case UniEventType.seminar:
        return GoogleCalendarColorNames.banana;
      case UniEventType.sports:
        return GoogleCalendarColorNames.basil;
      case UniEventType.semester:
        return GoogleCalendarColorNames.undefined;
      case UniEventType.holiday:
        return GoogleCalendarColorNames.grape;
      case UniEventType.examSession:
        return GoogleCalendarColorNames.tomato;
      default:
        return GoogleCalendarColorNames.undefined;
    }
  }
}
