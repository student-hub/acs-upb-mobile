import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/admin_provider.dart';
import 'admin_request_card.dart';
import 'role_request_card.dart';

class AdminPageRolesRequests extends StatefulWidget {
  const AdminPageRolesRequests({this.allRequests, final Key key})
      : super(key: key);

  final bool allRequests;

  @override
  _AdminPageRolesRequestsState createState() => _AdminPageRolesRequestsState();
}

class _AdminPageRolesRequestsState extends State<AdminPageRolesRequests> {
  @override
  Widget build(final BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return FutureBuilder(
      future: widget.allRequests
          ? adminProvider.fetchAllRoleRequests()
          : adminProvider.fetchRoleUnprocessedRequests(),
      builder: (final context, final snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount:
                  snapshot.data?.length != null ? snapshot.data.length : 0,
              itemBuilder: (final context, final index) {
                return RoleRequestCard(
                  roleRequest: snapshot.data[index],
                );
              },
            );
          }
          return _requestsNotLoadedWidget();
        }
        return _requestsCircularProgressIndicator();
      },
    );
  }

  Widget _requestsCircularProgressIndicator() => const Padding(
        padding: EdgeInsets.only(top: 12, bottom: 12),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget _requestsNotLoadedWidget() => const Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Center(
            child: Text(
              'Role requests could not be loaded',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
