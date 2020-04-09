import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/add_website_view.dart';
import 'package:acs_upb_mobile/pages/settings/settings_page.dart';

class Routes {
  static const String root = '/';
  static const String home = '/home';
  static const String settings = SettingsPage.routeName;
  static const String filter = FilterPage.routeName;
  static const String addWebsite = AddWebsiteView.routeName;
  static const String login = LoginView.routeName;
  static const String signUp = SignUpView.routeName;
}
