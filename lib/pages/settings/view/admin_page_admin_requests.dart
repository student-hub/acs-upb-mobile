import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/error_page.dart';
import '../service/admin_provider.dart';
import 'admin_request_card.dart';

class AdminPageAdminRequests extends StatefulWidget {
  const AdminPageAdminRequests({this.allRequests = false, final Key key})
      : super(key: key);

  final bool allRequests;

  @override
  _AdminPageAdminRequestsState createState() => _AdminPageAdminRequestsState();
}

class _AdminPageAdminRequestsState extends State<AdminPageAdminRequests> {
  @override
  Widget build(final BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return FutureBuilder(
      future: widget.allRequests
          ? adminProvider.fetchAllAdminRequestIds()
          : adminProvider.fetchAdminUnprocessedRequestIds(),
      builder: (final context, final snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return const ErrorPage(
              imgPath: 'assets/illustrations/undraw_empty.png',
              errorMessage: 'No available editing requests',
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (final context, final index) {
                return AdminRequestCard(
                  requestId: snapshot.data[index],
                );
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
