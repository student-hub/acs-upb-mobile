import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NavigationApi {
  static bool isAuthenticated(BuildContext context) {
    return Provider.of<AuthProvider>(context).isAuthenticated;
  }
}
