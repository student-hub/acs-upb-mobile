import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/pages/settings/service/admin_provider.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    requests = adminProvider.fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
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
          builder:
              (BuildContext context, AsyncSnapshot<List<Request>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              requestsData = snapshot.data;
              return Column(
                children: [
                  Container(),
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
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    return ListView.builder(
      itemCount: widget.requests.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
            future: _fetchUserById(widget.requests[index].userId),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final user = snapshot.data;
                if (widget.requests[index].processed == false) {
                  return InfoCard(
                      title: '${user?.firstName} ${user?.lastName}',
                      future: Future.delayed(
                        const Duration(microseconds: 1),
                        () => '',
                      ),
                      builder: (b) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                                '${DateFormat("dd-MM-yyyy '${S.current.stringAt}' HH:mm").format(widget.requests[index].dateSubmitted?.toDate() ?? DateTime.now())}'),
                            Text('${widget.requests[index].requestBody}'),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppButton(
                                  text: S.current.stringDeny,
                                  color: Theme.of(context).accentColor,
                                  width: 100,
                                  onTap: () async {
                                    await adminProvider.denyRequest(
                                        widget.requests[index].formId,
                                        widget.requests[index].userId);
                                  },
                                ),
                                const SizedBox(width: 10),
                                AppButton(
                                  text: S.current.stringAccept,
                                  color: Theme.of(context).accentColor,
                                  width: 100,
                                  onTap: () async {
                                    await adminProvider.acceptRequest(
                                        widget.requests[index].formId,
                                        widget.requests[index].userId);
                                  },
                                )
                              ],
                            )
                          ],
                        );
                      });
                } else if (widget.requests[index].processed == true) {
                  return InfoCard(
                      title: '${user?.firstName} ${user?.lastName}',
                      future: Future.delayed(
                        const Duration(microseconds: 1),
                        () => '',
                      ),
                      builder: (b) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                                '${DateFormat("dd-MM-yyyy '${S.current.stringAt}' HH:mm").format(widget.requests[index].dateSubmitted?.toDate() ?? DateTime.now())}'),
                            Text('${widget.requests[index].requestBody}'),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppButton(
                                  text: S.current.stringRevert,
                                  color: Theme.of(context).accentColor,
                                  width: 100,
                                )
                              ],
                            )
                          ],
                        );
                      });
                } else {
                  return const SizedBox
                      .shrink(); //if the field 'done' is missing
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
    );
  }

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
