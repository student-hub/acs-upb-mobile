import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/navigation/model/app_state.dart';
import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

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
      case EventView.routeName:
        final id = uri.queryParameters['id'];
        print('Factory-Event: $id');
        return EventPath(id);
      case ClassesPage.routeName:
        return ClassesPath();
      case AddEventView.routeName:
        if (uri.queryParameters.containsKey('id')) {
          final id = uri.queryParameters['id'];
          return AddEventIdPath(id);
        }
        final year = int.parse(uri.queryParameters['year']);
        final month = int.parse(uri.queryParameters['month']);
        final day = int.parse(uri.queryParameters['day']);
        final hour = int.parse(uri.queryParameters['hour']);
        final minute = int.parse(uri.queryParameters['minute']);
        final second = int.parse(uri.queryParameters['second']);
        return AddEventPath(
          LocalDateTime(year, month, day, hour, minute, second),
        );

      default:
        return UnknownPath();
    }
  }
}

class PathConditions {
  static bool shouldNavigate(BuildContext context, RoutePath path) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    switch (path.runtimeType) {
      case RootPath:
        return appState.isInitialized;
      case HomePath:
        return appState.isInitialized && appState.selectedTab == 0;
      case TimetablePath:
        return Provider.of<AppStateProvider>(context, listen: false)
                .selectedTab ==
            1;
      default:
        return false;
    }
  }
}
