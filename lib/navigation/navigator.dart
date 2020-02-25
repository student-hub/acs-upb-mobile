import 'package:acs_upb_mobile/authentication/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/login/login_view.dart';
import 'package:acs_upb_mobile/navigation/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
