library route_paths;

import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/navigation/service/app_navigator.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/class_feedback_checklist.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/class_feedback_view.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/faq/view/faq_page.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/news_feed/view/news_feed_page.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/website_view.dart';
import 'package:acs_upb_mobile/pages/settings/view/request_permissions.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/add_event_view.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_view.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:acs_upb_mobile/resources/platform.dart';
import 'package:acs_upb_mobile/widgets/error_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'routes/add_classes_path.dart';

part 'routes/add_website_path.dart';

part 'routes/class_feedback_view_path.dart';

part 'routes/class_view_path.dart';

part 'routes/classes_feedback_path.dart';

part 'routes/classes_page_path.dart';

part 'routes/edit_profile_path.dart';

part 'routes/faq_path.dart';

part 'routes/filter_path.dart';

part 'routes/home_path.dart';

part 'routes/login_path.dart';

part 'routes/news_feed_path.dart';

part 'routes/people_path.dart';

part 'routes/portal_path.dart';

part 'routes/profile_path.dart';

part 'routes/request_permissions_path.dart';

part 'routes/root_path.dart';

part 'routes/settings_path.dart';

part 'routes/signup_path.dart';

part 'routes/timetable_path.dart';

part 'routes/unknown_path.dart';

part 'routes/website_path.dart';

abstract class RoutePath {
  RoutePath(this.location);

  String location;

  RouteInformation get routeInformation => RouteInformation(location: location);

  Widget get page;
}

class EventViewPath extends RoutePath {
  EventViewPath(this.id) : super('${EventView.routeName}?id=$id');

  final String id;

  // TODO(RazvanRotaru): retrieve [Event] for [EventView] by id
  @override
  Widget get page => EventView();
}

// TODO(RazvanRotaru): get event for [AddEventView] by id
class AddEventPath extends RoutePath {
  AddEventPath() : super(AddEventView.routeName);

  @override
  Widget get page => const AddEventView();
}

// TODO(RazvanRotaru): auto-generate PathFactory
class PathFactory {
  static RoutePath from(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return RootPath();
    }

    switch (uri.path) {
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
      case NewsFeedPage.routeName:
        return NewsFeedPath();
      case RequestPermissionsPage.routeName:
        return RequestPermissionsPath();
      case PeoplePage.routeName:
        return PeoplePath();
      case PersonView.routeName:
        final name = uri.queryParameters['name'];
        return ProfilePath(name);
      case EditProfilePage.routeName:
        return EditProfilePath();
      case WebsiteView.routeName:
        final id = uri.queryParameters['id'];
        return WebsiteViewPath(id);

      // this case might be the reason why auto-generation won't really work
      case '${WebsiteView.routeName}/add':
        final category = uri.queryParameters['category'];
        return AddWebsitePath(category);
      case ClassFeedbackChecklist.routeName:
        return ClassesFeedbackPath();
      case ClassFeedbackView.routeName:
        print('enters');
        final id = uri.queryParameters['id'];
        return ClassFeedbackViewPath(id);
      case ClassView.routeName:
        final id = uri.queryParameters['id'];
        return ClassViewPath(id);
      case ClassesPage.routeName:
        return ClassesPagePath();
      case AddClassesPage.routeName:
        return AddClassesPath();
      case EventView.routeName:
        final id = uri.queryParameters['id'];
        return EventViewPath(id);
      case AddEventView.routeName:
        return AddEventPath();
      default:
        return UnknownPath();
    }
  }
}
