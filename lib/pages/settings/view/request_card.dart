import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/pages/settings/service/admin_provider.dart';
import 'package:acs_upb_mobile/resources/theme.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RequestCard extends StatefulWidget {
  const RequestCard({this.requestId});

  @required
  final String requestId;

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adminProvider = Provider.of<AdminProvider>(context);

    return FutureBuilder(
        future: adminProvider.fetchRequest(widget.requestId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final Request request = snapshot.data;
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildUserHeader(request.userId, request.processed,
                          request.accepted, adminProvider),
                      const SizedBox(height: 10),
                      Text(
                        request.requestBody ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      _buildButtons(request.processed, adminProvider, request)
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Widget _buildUserHeader(String userId, bool processed, bool accepted,
          AdminProvider adminProvider) =>
      FutureBuilder(
          future: adminProvider.fetchUserById(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final User user = snapshot.data;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${user?.firstName ?? 'Unknown User'} ${user?.lastName ?? ''}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        if (processed == true && accepted != null)
                          _buildAcceptedMarker(accepted),
                      ],
                    ),
                    Text(
                      '${user?.classes != null ? user?.classes[user.classes.length - 1] : '-'}',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                    ),
                  ]);
            } else {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '-',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 18),
                    ),
                    Text(
                      '',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 14),
                    ),
                  ]);
            }
          });

  Widget _buildAcceptedMarker(bool accepted) => Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border:
              Border.all(color: accepted ? Colors.green : Colors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Text(
          accepted ? S.current.infoAccepted : S.current.infoDenied,
          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 10),
        ),
      );

  Widget _buildButtons(
          bool processed, AdminProvider adminProvider, Request request) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${DateFormat("dd-MM-yyyy").format(request.dateSubmitted?.toDate() ?? DateTime.now())}',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontSize: 12, color: Theme.of(context).hintColor),
            overflow: TextOverflow.fade,
            maxLines: 2,
          ),
          if (processed == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: S.current.buttonDeny,
                  color: Theme.of(context).secondaryButtonColor,
                  width: 100,
                  onTap: () async {
                    await adminProvider.denyRequest(request.id);
                    setState(() {
                      request
                        ..accepted = false
                        ..processed = true;
                    });
                  },
                ),
                const SizedBox(width: 10),
                AppButton(
                  text: S.current.buttonAccept,
                  color: Theme.of(context).accentColor,
                  width: 100,
                  onTap: () async {
                    await adminProvider.acceptRequest(request.id);
                    setState(() {
                      request
                        ..accepted = true
                        ..processed = true;
                    });
                  },
                )
              ],
            )
          else if (processed == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: S.current.buttonRevert,
                  color: Theme.of(context).accentColor,
                  width: 100,
                  onTap: () async {
                    await adminProvider.revertRequest(request.id);
                    setState(() {
                      request
                        ..accepted = false
                        ..processed = false;
                    });
                  },
                )
              ],
            )
        ],
      );

  @override
  bool get wantKeepAlive => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}