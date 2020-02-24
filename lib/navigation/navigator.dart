import 'package:acs_upb_mobile/module/authentication/auth_provider.dart';
import 'package:acs_upb_mobile/module/authentication/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation_bar.dart';

class AppNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppNavigatorState();
}

class AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);

    return authProvider.isAuthenticated
        ? ChangeNotifierProvider<BottomNavigationBarProvider>(
            child: AppBottomNavigationBar(),
            create: (BuildContext context) => BottomNavigationBarProvider())
        : LoginView();
  }
}
