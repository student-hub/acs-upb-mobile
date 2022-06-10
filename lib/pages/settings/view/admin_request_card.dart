import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../generated/l10n.dart';
import '../../../resources/theme.dart';
import '../../../resources/utils.dart';
import '../../../widgets/button.dart';
import '../model/request.dart';
import '../service/admin_provider.dart';

class AdminRequestCard extends StatefulWidget {
  const AdminRequestCard({this.requestId});

  @required
  final String requestId;

  @override
  _AdminRequestCardState createState() => _AdminRequestCardState();
}

class _AdminRequestCardState extends State<AdminRequestCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(final BuildContext context) {
    super.build(context);
    final adminProvider = Provider.of<AdminProvider>(context);

    return FutureBuilder(
      future: adminProvider.fetchRequest(widget.requestId),
      builder: (final context, final snapshot) {
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
                    _buildUserHeader(request),
                    const SizedBox(height: 10),
                    Text(
                      request.requestBody ?? '',
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
      },
    );
  }

  Widget _buildUserHeader(final Request request) => FutureBuilder(
        future:
            Provider.of<AdminProvider>(context).fetchUserById(request.userId),
        builder: (final context, final snapshot) {
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
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
            ],
          );
        },
      );

  Widget _buildAcceptedMarker(final bool accepted) => Container(
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

  Widget _buildButtons(final bool processed, final Request request) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    return Row(
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
                key: const Key('AcceptButton'),
                text: S.current.buttonAccept,
                color: Theme.of(context).primaryColor,
                width: 100,
                onTap: () async {
                  await adminProvider.acceptRequest(request.id);
                  setState(() {
                    request
                      ..accepted = true
                      ..processed = true;
                  });
                  //   final authProvider =
                  //       Provider.of<AuthProvider>(context, listen: false);
                  //   await Utils.launchURL(
                  //       'mailto:${authProvider.email}?subject=Permisiuni%20ACS%20UPB%20Mobile&body=Ai%20primit%20permisiuni%20de%20editare%20în%20ACS%20UPB%20Mobile!');
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
                color: Theme.of(context).primaryColor,
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
  }

  @override
  bool get wantKeepAlive => true;

  @override
  dynamic noSuchMethod(final Invocation invocation) =>
      super.noSuchMethod(invocation);
}
