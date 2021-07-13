import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/class_feedback_checklist.dart';
import 'package:acs_upb_mobile/pages/faq/view/faq_page.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/news_feed/view/news_feed_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/settings/view/request_permissions.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/material.dart';

abstract class RoutePath {
  RoutePath(this.location);

  String location;

  RouteInformation get routeInformation => RouteInformation(location: location);

  Widget get page;
}

class RootPath extends RoutePath {
  RootPath() : super('/');

  @override
  Widget get page => AppLoadingScreen();
}

class HomePath extends RoutePath {
  HomePath() : super(HomePage.routeName);

  @override
  Widget get page => const BottomAppBar();
}

class TimetablePath extends RoutePath {
  TimetablePath() : super(TimetablePage.routeName);

  @override
  Widget get page => const TimetablePage();
}

class PortalPath extends RoutePath {
  PortalPath() : super(PortalPage.routeName);

  @override
  Widget get page => const PortalPage();
}

class SettingsPath extends RoutePath {
  SettingsPath() : super(SettingsPage.routeName);

  @override
  Widget get page => SettingsPage();
}

class FilterPath extends RoutePath {
  FilterPath() : super(FilterPage.routeName);

  @override
  Widget get page => const FilterPage();
}

class LoginPath extends RoutePath {
  LoginPath() : super(LoginView.routeName);

  @override
  Widget get page => LoginView();
}

class SignUpPath extends RoutePath {
  SignUpPath() : super(SignUpView.routeName);

  @override
  Widget get page => SignUpView();
}

class FaqPath extends RoutePath {
  FaqPath() : super(FaqPage.routeName);

  @override
  Widget get page => FaqPage();
}

class EditProfilePath extends RoutePath {
  EditProfilePath() : super(EditProfilePage.routeName);

  @override
  Widget get page => const EditProfilePage();
}

class NewsFeedPath extends RoutePath {
  NewsFeedPath() : super(NewsFeedPage.routeName);

  @override
  Widget get page => NewsFeedPage();
}

class RequestPermissionsPath extends RoutePath {
  RequestPermissionsPath() : super(RequestPermissionsPage.routeName);

  @override
  Widget get page => RequestPermissionsPage();
}

class PeoplePath extends RoutePath {
  PeoplePath() : super(PeoplePage.routeName);

  @override
  Widget get page => const PeoplePage();
}

class ProfilePath extends RoutePath {
  ProfilePath(this.name)
      : super('${PersonView.routeName}?name=${name.replaceAll(' ', '%20')}') {
    print('ProfilePath-Constructor: $name');
  }

  String name;

  @override
  Widget get page => const PersonView();
}

class ClassFeedbackPath extends RoutePath {
  ClassFeedbackPath() : super(ClassFeedbackChecklist.routeName);

  @override
  Widget get page => const ClassFeedbackChecklist();
}

class UnknownPath extends RoutePath {
  UnknownPath() : super('');

  @override
  Widget get page => const Text('404! Unknown location');
}

class PathFactory {
  static RoutePath from(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return RootPath();
    }

    final String path = '/${uri.pathSegments.first}';
    switch (path) {
      case HomePage.routeName:
        return HomePath();
      case TimetablePage.routeName:
        return TimetablePath();
      case PortalPage.routeName:
        return PortalPath();
      case SettingsPage.routeName:
        return SettingsPath();
      case FilterPage.routeName:
        return FilterPath();
      case LoginView.routeName:
        return LoginPath();
      case SignUpView.routeName:
        return SignUpPath();
      case FaqPage.routeName:
        return FaqPath();
      case EditProfilePage.routeName:
        return EditProfilePath();
      case NewsFeedPage.routeName:
        return NewsFeedPath();
      case RequestPermissionsPage.routeName:
        return RequestPermissionsPath();
      case PeoplePage.routeName:
        return PeoplePath();
      case PersonView.routeName:
        final name = uri.queryParameters['name'];
        print('Factory-Person: $name');
        return ProfilePath(name);
      case ClassFeedbackChecklist.routeName:
        return ClassFeedbackPath();
      default:
        return UnknownPath();
    }
  }
}
