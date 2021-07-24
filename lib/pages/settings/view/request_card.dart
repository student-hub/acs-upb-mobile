import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/pages/settings/service/admin_provider.dart';
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
        future: adminProvider.fetchRequestData(widget.requestId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final Request request = snapshot.data;
            return FutureBuilder(
                future: adminProvider.fetchUserById(request.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final User user = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${user?.firstName ?? 'Unknown User'} ${user?.lastName ?? ''}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontSize: 18),
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                  ),
                                  //const SizedBox(width: 6),
                                  if (request.processed == true)
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: boxDecorationGreen(),
                                      child: Text(
                                        'Accepted',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(fontSize: 10),
                                      ),
                                    )
                                  else if (request.processed == null)
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: boxDecorationRed(),
                                      child: Text(
                                        'Denied',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(fontSize: 10),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                '${user?.classes != null ? user?.classes[user.classes.length - 1] : ''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 14),
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${DateFormat("dd-MM-yyyy '${S.current.stringAt}' HH:mm").format(request.dateSubmitted?.toDate() ?? DateTime.now())}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 14),
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                request.requestBody ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              if (request.processed == false)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AppButton(
                                      text: S.current.stringDeny,
                                      color: Theme.of(context).disabledColor,
                                      width: 100,
                                      onTap: () async {
                                        await adminProvider.denyRequest(
                                            request.formId, request.userId);
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    AppButton(
                                      text: S.current.stringAccept,
                                      color: Theme.of(context).accentColor,
                                      width: 100,
                                      onTap: () async {
                                        await adminProvider.acceptRequest(
                                            request.formId, request.userId);
                                      },
                                    )
                                  ],
                                )
                              else if (request.processed == true)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AppButton(
                                      text: S.current.stringRevert,
                                      color: Theme.of(context).accentColor,
                                      width: 100,
                                      onTap: () async {
                                        await adminProvider
                                            .revertAcceptedRequest(
                                                request.formId, request.userId);
                                      },
                                    )
                                  ],
                                )
                              else if (request.processed == null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AppButton(
                                      text: S.current.stringRevert,
                                      color: Theme.of(context).accentColor,
                                      width: 100,
                                      onTap: () async {
                                        await adminProvider.revertDeniedRequest(
                                            request.formId, request.userId);
                                      },
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                });
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  BoxDecoration boxDecorationGreen() {
    return BoxDecoration(
      border: Border.all(color: Colors.green, width: 2),
      borderRadius: const BorderRadius.all(
          Radius.circular(6) //                 <--- border radius here
          ),
    );
  }

  BoxDecoration boxDecorationRed() {
    return BoxDecoration(
      border: Border.all(color: Colors.red, width: 2),
      borderRadius: const BorderRadius.all(
          Radius.circular(6) //                 <--- border radius here
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
