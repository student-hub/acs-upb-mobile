import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../authentication/service/auth_provider.dart';

class RequestRolesPage extends StatefulWidget {
  static const String routeName = '/requestRoles';

  @override
  _RequestRolesPageState createState() => _RequestRolesPageState();
}

class _RequestRolesPageState extends State<RequestRolesPage> {
  User user;

  Future<void> _fetchUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = await authProvider.currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Roles'),
      ),
      body: const Center(
        child: Text('Request Roles'),
      ),
    );
  }
}
