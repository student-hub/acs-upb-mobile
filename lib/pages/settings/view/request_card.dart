import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/pages/settings/service/admin_provider.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestCard extends StatefulWidget {
  const RequestCard(
      {this.title,
      this.date,
      this.body,
      this.initialState,
      this.requests,
      this.index});

  @required
  final String title;
  @required
  final String date;
  @required
  final String body;
  @required
  final bool initialState;
  final List<Request> requests;
  final int index;

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard>
    with AutomaticKeepAliveClientMixin {
  bool processedState;

  @override
  initState() {
    processedState = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adminProvider = Provider.of<AdminProvider>(context);

    // int _widgetIndex;
    // if (widget.initialState == false) {
    //   _widgetIndex = 0;
    // } else if (widget.initialState == true) {
    //   _widgetIndex = 1;
    // } else {
    //   _widgetIndex = 2;
    // }
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.title != null && widget.title.isNotEmpty)
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 18),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                ),
              if (widget.date != null && widget.date.isNotEmpty)
                Text(
                  widget.date,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 14),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                ),
              const SizedBox(height: 10),
              if (widget.body != null && widget.body.isNotEmpty)
                Text(
                  widget.body,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 14),
                ),
              const SizedBox(height: 10),

              // DefaultTabController(
              //   length: 3,
              //   initialIndex: _widgetIndex,
              //   child: TabBarView(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           AppButton(
              //             key: const ValueKey('deny'),
              //             text: S.current.stringDeny,
              //             color: Theme.of(context).accentColor,
              //             width: 100,
              //             onTap: () async {
              //               await adminProvider.denyRequest(
              //                   widget.requests[widget.index].formId,
              //                   widget.requests[widget.index].userId);
              //               setState(() {
              //                 _widgetIndex = 2;
              //               });
              //             },
              //           ),
              //           const SizedBox(width: 10),
              //           AppButton(
              //             key: const ValueKey('accept'),
              //             text: S.current.stringAccept,
              //             color: Theme.of(context).accentColor,
              //             width: 100,
              //             onTap: () async {
              //               await adminProvider.acceptRequest(
              //                   widget.requests[widget.index].formId,
              //                   widget.requests[widget.index].userId);
              //               setState(() {
              //                 _widgetIndex = 1;
              //               });
              //             },
              //           )
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           AppButton(
              //             text: S.current.stringRevert,
              //             color: Theme.of(context).accentColor,
              //             width: 100,
              //             onTap: () async {
              //               setState(() {
              //                 _widgetIndex = 0;
              //               });
              //             },
              //           )
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           AppButton(
              //             text: S.current.stringRevert,
              //             color: Theme.of(context).accentColor,
              //             width: 100,
              //             onTap: () async {
              //               setState(() {
              //                 _widgetIndex = 0;
              //               });
              //             },
              //           )
              //         ],
              //       )
              //     ],
              //   ),
              // ),

              // IndexedStack(
              //   index: _widgetIndex,
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         AppButton(
              //           key: const ValueKey('deny'),
              //           text: S.current.stringDeny,
              //           color: Theme.of(context).accentColor,
              //           width: 100,
              //           onTap: () async {
              //             await adminProvider.denyRequest(
              //                 widget.requests[widget.index].formId,
              //                 widget.requests[widget.index].userId);
              //             setState(() {
              //               _widgetIndex = 2;
              //             });
              //           },
              //         ),
              //         const SizedBox(width: 10),
              //         AppButton(
              //           key: const ValueKey('accept'),
              //           text: S.current.stringAccept,
              //           color: Theme.of(context).accentColor,
              //           width: 100,
              //           onTap: () async {
              //             await adminProvider.acceptRequest(
              //                 widget.requests[widget.index].formId,
              //                 widget.requests[widget.index].userId);
              //             setState(() {
              //               _widgetIndex = 1;
              //             });
              //           },
              //         )
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         AppButton(
              //           text: S.current.stringRevert,
              //           color: Theme.of(context).accentColor,
              //           width: 100,
              //           onTap: () async {
              //             setState(() {
              //               _widgetIndex = 0;
              //             });
              //           },
              //         )
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         AppButton(
              //           text: S.current.stringRevert,
              //           color: Theme.of(context).accentColor,
              //           width: 100,
              //           onTap: () async {
              //             setState(() {
              //               _widgetIndex = 0;
              //             });
              //           },
              //         ),
              //       ],
              //     )
              //   ],
              // ),

              if (processedState == false)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      key: const ValueKey('deny'),
                      text: S.current.stringDeny,
                      color: Theme.of(context).accentColor,
                      width: 100,
                      onTap: () async {
                        await adminProvider.denyRequest(
                            widget.requests[widget.index].formId,
                            widget.requests[widget.index].userId);
                        setState(() {});
                      },
                    ),
                    const SizedBox(width: 10),
                    AppButton(
                      key: const ValueKey('accept'),
                      text: S.current.stringAccept,
                      color: Theme.of(context).accentColor,
                      width: 100,
                      onTap: () async {
                        await adminProvider.acceptRequest(
                            widget.requests[widget.index].formId,
                            widget.requests[widget.index].userId);
                        setState(() {

                        });
                      },
                    )
                  ],
                )
              else if (processedState == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: S.current.stringRevert,
                      color: Theme.of(context).accentColor,
                      width: 100,
                      onTap: () async {

                      },
                    )
                  ],
                )
              else if (processedState == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        text: S.current.stringRevert,
                        color: Theme.of(context).accentColor,
                        width: 100,
                        onTap: () async {

                        },
                      )
                    ],
                  )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
