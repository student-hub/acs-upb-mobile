import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/class_feedback_checklist.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/class_feedback_view.dart';
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
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/website_view.dart';
import 'package:acs_upb_mobile/pages/settings/view/request_permissions.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/add_event_view.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_view.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:acs_upb_mobile/resources/platform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Widget get page => const HomePage();
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
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        return FutureBuilder(
          future: Provider.of<PersonProvider>(context, listen: false)
              .fetchPerson(name),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final Person personData = snapshot.data;
              return PersonView(
                person: personData,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}

class EditProfilePath extends RoutePath {
  EditProfilePath() : super(EditProfilePage.routeName);

  @override
  Widget get page => const EditProfilePage();
}

class WebsiteViewPath extends RoutePath {
  WebsiteViewPath(this.id) : super('${WebsiteView.routeName}?id=$id');

  final String id;

  // TODO(RazvanRotaru): Retrieve [Website] for [WebsiteView] by id
  @override
  Widget get page => throw UnimplementedError();
}

class AddWebsitePath extends RoutePath {
  AddWebsitePath(this.category)
      : super('${WebsiteView.routeName}/add?category=$category');

  final String category;

  WebsiteCategory get _websiteCategory {
    return WebsiteCategory.values.firstWhere(
        (element) => category == element.toString().split('.').last);
  }

  // TODO(RazvanRotaru): Update path whenever the category is changed
  /// This requires [WebsiteView] to trigger the navigator whenever the dropdown
  /// from here [lib/pages/portal/view/website_view.dart:254] is changed
  /// OR remove [category] attribute which means that the usage from
  /// [lib/pages/portal/view/portal_page.dart:358] will always redirect to
  /// `category = [WebsiteCategory.learning]', which means a button on it's parent page
  /// will have no feedback.
  /// OR rename [category] to 'defaultCategory' :bigbrain:
  @override
  Widget get page {
    return ChangeNotifierProxyProvider<AuthProvider, FilterProvider>(
      create: (BuildContext context) {
        return Platform.environment.containsKey('FLUTTER_TEST')
            ? Provider.of<FilterProvider>(context)
            : FilterProvider();
      },
      update: (context, authProvider, filterProvider) {
        return filterProvider..updateAuth(authProvider);
      },
      child: WebsiteView(
        website: Website(
            relevance: null,
            id: null,
            isPrivate: true,
            link: '',
            category: _websiteCategory),
      ),
    );
  }
}

class ClassesFeedbackPath extends RoutePath {
  ClassesFeedbackPath() : super(ClassFeedbackChecklist.routeName);

  @override
  Widget get page => const ClassFeedbackChecklist();
}

class ClassFeedbackViewPath extends RoutePath {
  ClassFeedbackViewPath(this.id) : super(ClassFeedbackView.routeName);

  final String id;

  // TODO(RazvanRotaru): Retrieve [ClassHeader] for [ClassFeedbackView] by id
  @override
  Widget get page => const ClassFeedbackView();
}

class ClassViewPath extends RoutePath {
  ClassViewPath(this.id) : super(ClassView.routeName);

  final String id;

  // TODO(RazvanRotaru): retrieve [ClassHeader] for [ClassView] by id
  @override
  Widget get page => const ClassView();
}

class ClassesPagePath extends RoutePath {
  ClassesPagePath() : super(ClassesPage.routeName);

  @override
  Widget get page => const ClassesPage();
}

class AddClassesPath extends RoutePath {
  AddClassesPath() : super(AddClassesPage.routeName);

  @override
  Widget get page => const AddClassesPage();
}

class EventViewPath extends RoutePath {
  EventViewPath(this.id) : super('${EventView.routeName}?id=$id');

  final String id;

  // TODO(RazvanRotaru): retrieve [Event] for [EventView] by id
  @override
  Widget get page => EventView();
}

class AddEventPath extends RoutePath {
  AddEventPath() : super(AddEventView.routeName);

  @override
  Widget get page => const AddEventView();
}

class UnknownPath extends RoutePath {
  UnknownPath() : super('');

  // TODO(RazvanRotaru): Use [ErrorPage] instead of plain [Text]
  @override
  Widget get page => const Text('404! Unknown location');
}

// TODO(RazvanRotaru): auto-generate PathFactory
class PathFactory {
  static RoutePath from(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return RootPath();
    }

    // final String path = uri.path;
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
        print('Factory-Person: $name');
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
