import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/pages/settings/service/admin_provider.dart';
import 'package:acs_upb_mobile/pages/settings/view/request_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key key}) : super(key: key);
  static const String routeName = '/admin';

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  //String filter = '';
  Future<List<Request>> requests;
  List<Request> requestsData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    requests = adminProvider.fetchRequests();
    return AppScaffold(
      actions: [
        AppScaffoldAction(
          icon: FeatherIcons.filter,
          onPressed: () {
            setState(() => {});
          },
        )
      ],
      title: Text(S.current.navigationAdmin),
      body: FutureBuilder(
          future: requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              requestsData = snapshot.data;
              return Column(
                children: [
                  Expanded(
                    child: RequestsList(requests: requestsData),
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class RequestsList extends StatefulWidget {
  const RequestsList({this.requests});

  final List<Request> requests;

  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.requests.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
            future: _fetchUserById(widget.requests[index].userId),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final user = snapshot.data;
                return RequestCard(
                  title:
                      '${user?.firstName ?? 'unknown user'} ${user?.lastName ?? ''} ${user?.classes != null ? user?.classes[user.classes.length - 1] : ''}',
                  date:
                      '${DateFormat("dd-MM-yyyy '${S.current.stringAt}' HH:mm").format(widget.requests[index].dateSubmitted?.toDate() ?? DateTime.now())}',
                  body: widget.requests[index].requestBody,
                  initialState: widget.requests[index].processed,
                  requests: widget.requests,
                  index: index,
                );
              } else {
                return const SizedBox.shrink();
              }
              //const Center(child: CircularProgressIndicator());
            });
      },
    );
  }

  // class test extends StatefulWidget StatefulWidgetwith AutomaticKeepAliveClientMixin {
  //
  // }

  Future<User> _fetchUserById(final String userId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.data() == null) {
      return null;
    }

    final currentUser = DatabaseUser.fromSnap(snapshot);
    return currentUser;
  }
}
