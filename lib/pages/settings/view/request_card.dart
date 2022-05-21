import 'dart:ui' as ui;

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/pages/settings/service/admin_provider.dart';
import 'package:acs_upb_mobile/resources/theme.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
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
            final PermissionRequest request = snapshot.data;
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildUserHeader(request),
                      const SizedBox(height: 10),
                      Text(
                        request.answers['0'].answer ?? '',
                        textDirection: ui.TextDirection.ltr,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      _buildButtons(request.processed, request)
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

  Widget _buildUserHeader(PermissionRequest request) => FutureBuilder(
      future: Provider.of<AdminProvider>(context).fetchUserById(request.userId),
      builder: (context, snapshot) {
        User user;
        if (snapshot.connectionState == ConnectionState.done) {
          user = snapshot.data;
        }
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      snapshot.connectionState != ConnectionState.done
                          ? '-'
                          : '${user?.firstName ?? S.current.errorUnknownUser} ${user?.lastName ?? ''}',
                      textDirection: ui.TextDirection.ltr,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  if (request.processed && request.accepted != null)
                    _buildAcceptedMarker(request.accepted),
                ],
              ),
              Text(
                snapshot.connectionState != ConnectionState.done
                    ? ''
                    : '${user?.classes != null ? user?.classes[user.classes.length - 1] : '-'}',
                textDirection: ui.TextDirection.ltr,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.fade,
                maxLines: 2,
              ),
            ]);
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

  Widget _buildButtons(bool processed, PermissionRequest request) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${DateFormat("dd-MM-yyyy").format(request.dateSubmitted?.toDate() ?? DateTime.now())}',
            textDirection: ui.TextDirection.ltr,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontSize: 12, color: Theme.of(context).hintColor),
            overflow: TextOverflow.fade,
            maxLines: 2,
          ),
          if (!processed)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: S.current.buttonDeny,
                  color: Theme.of(context).secondaryButtonColor,
                  width: 100,
                  onTap: () async {
                    final adminProvider =
                        Provider.of<AdminProvider>(context, listen: false);
                    await adminProvider.denyRequest(request.userId);
                    setState(() {
                      request
                        ..accepted = false
                        ..processed = true;
                    });
                  },
                ),
                const SizedBox(width: 10),
                AppButton(
                  key: const Key('AcceptButton'),
                  text: S.current.buttonAccept,
                  color: Theme.of(context).accentColor,
                  width: 100,
                  onTap: () async {
                    final adminProvider =
                        Provider.of<AdminProvider>(context, listen: false);
                    await adminProvider.acceptRequest(request.userId);
                    setState(() {
                      request
                        ..accepted = true
                        ..processed = true;
                    });
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    await Utils.launchURL(
                        'mailto:${authProvider.email}?subject=Permisiuni%20ACS%20UPB%20Mobile&body=Ai%20primit%20permisiuni%20de%20editare%20în%20ACS%20UPB%20Mobile!');
                  },
                )
              ],
            )
          else if (processed)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: S.current.buttonRevert,
                  color: Theme.of(context).accentColor,
                  width: 100,
                  onTap: () async {
                    final adminProvider =
                        Provider.of<AdminProvider>(context, listen: false);
                    await adminProvider.revertRequest(request.userId);
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
