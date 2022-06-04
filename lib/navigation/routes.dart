import '../authentication/view/login_view.dart';
import '../authentication/view/sign_up_view.dart';
import '../pages/faq/view/faq_page.dart';
import '../pages/filter/view/filter_page.dart';
import '../pages/news_feed/view/news_create_page.dart';
import '../pages/news_feed/view/news_item_details_page.dart';
import '../pages/news_feed/view/news_navigation_bar.dart';
import '../pages/settings/view/admin_page.dart';
import '../pages/settings/view/feedback_form.dart';
import '../pages/settings/view/request_permissions.dart';
import '../pages/settings/view/request_roles.dart';
import '../pages/settings/view/settings_page.dart';
import '../pages/settings/view/source_page.dart';

class Routes {
  Routes._();

  static const String root = '/';
  static const String home = '/home';
  static const String settings = SettingsPage.routeName;
  static const String sources = SourcePage.routeName;
  static const String filter = FilterPage.routeName;
  static const String login = LoginView.routeName;
  static const String signUp = SignUpView.routeName;
  static const String faq = FaqPage.routeName;
  static const String newsFeed = NewsNavigationBar.routeName;
  static const String newsCreate = NewsCreatePage.routeName;
  static const String requestPermissions = RequestPermissionsPage.routeName;
  static const String requestRoles = RequestRolesPage.routeName;
  static const String adminPanel = AdminPanelPage.routeName;
  static const String feedbackForm = FeedbackFormPage.routeName;
  static const String newsDetails = NewsItemDetailsPage.routeName;
}
