import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/pages/faq/view/faq_page.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/pages/news_feed/view/news_feed_page.dart';

class Routes {
  static const String root = '/';
  static const String home = '/home';
  static const String settings = SettingsPage.routeName;
  static const String filter = FilterPage.routeName;
  static const String login = LoginView.routeName;
  static const String signUp = SignUpView.routeName;
  static const String faq = FaqPage.routeName;
  static const String newsFeed = NewsFeedPage.routeName;
}
