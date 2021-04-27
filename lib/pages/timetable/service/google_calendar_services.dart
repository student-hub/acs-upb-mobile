import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/recurring_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/resources/google_apis.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:googleapis/calendar/v3.dart' as g_cal;
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:time_machine/time_machine.dart';

extension GoogleCalendarServices on UniEventProvider {
  g_cal.Event convertEvent(UniEvent uniEvent) {
    final g_cal.Event _gCalEvent = g_cal.Event();

    final g_cal.EventDateTime start = g_cal.EventDateTime();
    final DateTime startDateTime = uniEvent.start.toDateTimeLocal();

    start
      ..timeZone =
          'Europe/Bucharest' // google calendar has different timezone formats
      ..dateTime = startDateTime;
    final Period eventPeriod = uniEvent.duration;
    final Duration duration =
        Duration(hours: eventPeriod.hours, minutes: eventPeriod.minutes);

    final g_cal.EventDateTime end = g_cal.EventDateTime();
    final DateTime endDateTime = startDateTime.add(duration);
    end
      ..timeZone = 'Europe/Bucharest'
      ..dateTime = endDateTime;

    // TODO(bogpie): Require user to input how many minutes before a notification from GCal (including the "no notification" option)

    final ClassHeader classHeader = uniEvent.classHeader;
    final EventReminders eventReminders = EventReminders();
    final EventReminder eventReminder = EventReminder()
      ..minutes = 30
      ..method = 'popup';
    eventReminders
      ..overrides = <EventReminder>[eventReminder]
      ..useDefault = false;

    _gCalEvent
      ..start = start
      ..end = end
      ..summary = classHeader.acronym
      ..colorId = (uniEvent.type.googleCalendarColor.index).toString()
/*    ..description =  eventInstance.title ?? eventInstance.mainEvent.type
              .toLocalizedString(context)*/
      // TODO(bogpie): Use a relevant description, like type of class + lecturer
      // TODO(bogpie): "Closest" color (from a list) - GCal works with limited no. of colors
      ..location = uniEvent.location
      ..reminders = eventReminders;

    if (uniEvent is RecurringUniEvent) {
      _gCalEvent.recurrence = <String>[];

      String rruleBasedOncalendarString =
          uniEvent.rruleBasedOncalendar.toString();
      rruleBasedOncalendarString =
          rruleBasedOncalendarString.replaceAll(RegExp(r'T000000'), 'T000000Z');
      rruleBasedOncalendarString =
          rruleBasedOncalendarString.replaceAll(RegExp(r'DAILY'), 'YEARLY');
      print(rruleBasedOncalendarString);
      _gCalEvent.recurrence.add(rruleBasedOncalendarString);
    }

    return _gCalEvent;
  }

  void prompt(String url) async {
    print('Please go to the following URL and grant access:');
    print('  => $url');
    print('');

    await FlutterWebBrowser.openWebPage(url: url);
  }

  Future<void> insertGoogleEvents(List<g_cal.Event> _gCalEvents) async {
    await clientViaUserConsent(
            GoogleApiHelper.credentials, GoogleApiHelper.scopes, prompt)
        .then(
      //(AuthClient client) async {
      (AutoRefreshingAuthClient client) async {
        // TODO(bogpie): Remember if a user already gave access to his Google Calendar
        // TODO(bogpie): Automatically close browser

        final g_cal.CalendarApi calendarApi = g_cal.CalendarApi(client);
        final g_cal.Calendar calendar = g_cal.Calendar()
          ..timeZone = 'Europe/Bucharest'
          ..summary = 'ACS UPB Mobile'
          ..description = 'Timetable imported from ACS UPB Mobile';

        g_cal.CalendarList calendarListNonIterable;
        try {
          calendarListNonIterable = await calendarApi.calendarList.list();
        } catch (e) {
          print('Error $e in getting calendars as a list');
          return;
        }
        final List<g_cal.CalendarListEntry> calendarList =
            calendarListNonIterable.items;
        for (final g_cal.CalendarListEntry calendar in calendarList) {
          if (calendar.summary == 'ACS UPB Mobile') {
            try {
              await calendarApi.calendars.delete(calendar.id);
            } catch (e) {
              print('Error $e in deleting calendar');
            }
            break;
          }
        }

        final g_cal.Calendar returnedCalendar =
            await calendarApi.calendars.insert(calendar);

        if (returnedCalendar is g_cal.Calendar) {
          final String calendarId = returnedCalendar.id;
          for (final g_cal.Event event in _gCalEvents) {
            try {
              await calendarApi.events.insert(event, calendarId).then(
                (value) {
                  print('Added event status: ${value.status}');
                  if (value.status == 'confirmed') {
                    print(
                        'Event named ${event.myToString()} added in Google Calendar');
                  } else {
                    print(
                        'Unable to add event named ${event.myToString()} in Google Calendar');
                  }
                },
              );
            } catch (e) {
              print('Error creating event $e');
            }
          }
        }
      },
      onError: (dynamic e) {
        print('Error <$e> when asking for user\'s consent');
      },
    );
  }
}
