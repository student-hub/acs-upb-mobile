import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/class_feedback_checklist.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/faq/view/faq_page.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/news_feed/view/news_feed_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/settings/view/request_permissions.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/add_event_view.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_view.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

abstract class RoutePath {
  RoutePath(this.location);

  String location;

  RouteInformation get routeInformation => RouteInformation(location: location);
}

class RootPath extends RoutePath {
  RootPath() : super('/');
}

class HomePath extends RoutePath {
  HomePath() : super(HomePage.routeName);
}

class TimetablePath extends RoutePath {
  TimetablePath() : super(TimetablePage.routeName);
}

class PortalPath extends RoutePath {
  PortalPath() : super(PortalPage.routeName);
}

class SettingsPath extends RoutePath {
  SettingsPath() : super(SettingsPage.routeName);
}

class FilterPath extends RoutePath {
  FilterPath() : super(FilterPage.routeName);
}

class LoginPath extends RoutePath {
  LoginPath() : super(LoginView.routeName);
}

class SignUpPath extends RoutePath {
  SignUpPath() : super(SignUpView.routeName);
}

class FaqPath extends RoutePath {
  FaqPath() : super(FaqPage.routeName);
}

class EditProfilePath extends RoutePath {
  EditProfilePath() : super(EditProfilePage.routeName);
}

class NewsFeedPath extends RoutePath {
  NewsFeedPath() : super(NewsFeedPage.routeName);
}

class RequestPermissionsPath extends RoutePath {
  RequestPermissionsPath() : super(RequestPermissionsPage.routeName);
}

class PeoplePath extends RoutePath {
  PeoplePath() : super(PeoplePage.routeName);
}

class ProfilePath extends RoutePath {
  ProfilePath(this.name)
      : super('${PersonView.routeName}?name=${name.replaceAll(' ', '%20')}') {
    print('ProfilePath-Constructor: $name');
  }

  String name;
}

class ClassFeedbackPath extends RoutePath {
  ClassFeedbackPath() : super(ClassFeedbackChecklist.routeName);
}

class EventPath extends RoutePath {
  EventPath(this.id) : super('${EventView.routeName}?id=$id') {
    print('EventPath-Constructor: $id');
  }

  String id;
}

class ClassesPath extends RoutePath {
  ClassesPath() : super(ClassesPage.routeName);
}

class AddEventPath extends RoutePath {
  AddEventPath(this.date)
      : super(
            '${AddEventView.routeName}?year=${date.year}'
                '&month=${date.monthOfYear}&day=${date.dayOfMonth}'
                '&hour=${date.hourOfDay}&minute=${date.minuteOfHour}'
                '&second=${date.secondOfMinute}');

  LocalDateTime date;
}

class AddEventIdPath extends RoutePath {
  AddEventIdPath(this.id) : super('${AddEventView.routeName}?id=$id');

  String id;
}

class UnknownPath extends RoutePath {
  UnknownPath() : super('');
}
