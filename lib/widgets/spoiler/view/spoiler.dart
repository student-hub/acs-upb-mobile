import 'dart:async';

import 'package:acs_upb_mobile/widgets/spoiler/model/spoiler_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

typedef OnReady = Function(SpoilerDetails);
typedef OnUpdate = Function(SpoilerDetails);

class Spoiler extends StatefulWidget {
  final Widget header;
  final Widget child;

  final bool isOpened;

  final bool leadingArrow;
  final bool trailingArrow;

  final Curve openCurve;
  final Curve closeCurve;

  final Duration duration;

  final bool waitFirstCloseAnimationBeforeOpen;

  final OnReady onReadyCallback;
  final OnUpdate onUpdateCallback;

  final Key key;

  const Spoiler(
      {this.key,
      this.header,
      this.child,
      this.isOpened = false,
      this.leadingArrow = false,
      this.trailingArrow = false,
      this.waitFirstCloseAnimationBeforeOpen = false,
      this.duration,
      this.onReadyCallback,
      this.onUpdateCallback,
      this.openCurve = Curves.easeOutExpo,
      this.closeCurve = Curves.easeInExpo})
      : super(key: key);

  @override
  SpoilerState createState() => SpoilerState();
}

class SpoilerState extends State<Spoiler> with SingleTickerProviderStateMixin {
  double headerWidth;
  double headerHeight;

  double childWidth;
  double childHeight;

  AnimationController childHeightAnimationController;
  Animation<double> childHeightAnimation;

  StreamController<bool> isReadyController = StreamController();
  Stream<bool> isReady;

  StreamController<bool> isOpenController = StreamController();
  Stream<bool> isOpen;

  bool isOpened;

  @override
  void initState() {
    super.initState();

    isOpened = widget.isOpened;

    isReady = isReadyController.stream.asBroadcastStream();

    isOpen = isOpenController.stream.asBroadcastStream();

    childHeightAnimationController = AnimationController(
        duration: widget.duration != null
            ? widget.duration
            : Duration(milliseconds: 400),
        vsync: this);

    childHeightAnimation = CurvedAnimation(
        parent: childHeightAnimationController,
        curve: widget.openCurve,
        reverseCurve: widget.closeCurve);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      headerWidth = _headerKey.currentContext.size.width;
      headerHeight = _headerKey.currentContext.size.height;

      childWidth = _childKey.currentContext.size.width;
      childHeight = _childKey.currentContext.size.height;

      childHeightAnimation = Tween(begin: 0.toDouble(), end: childHeight)
          .animate(childHeightAnimation);

      if (widget.onUpdateCallback != null) {
        childHeightAnimation.addListener(() => widget.onUpdateCallback(
            SpoilerDetails(
                isOpened: isOpened,
                headerWidth: headerWidth,
                headerHeight: headerHeight,
                childWidth: childWidth,
                childHeight: childHeightAnimation.value)));
      }

      if (widget.onReadyCallback != null) {
        widget.onReadyCallback(SpoilerDetails(
            isOpened: isOpened,
            headerWidth: headerWidth,
            headerHeight: headerHeight,
            childWidth: childWidth,
            childHeight: childHeight));
      }

      isReadyController.add(true);

      try {
        if (widget.waitFirstCloseAnimationBeforeOpen) {
          isOpened
              ? await childHeightAnimationController.forward().orCancel
              : await childHeightAnimationController
                  .forward()
                  .orCancel
                  .whenComplete(
                      () => childHeightAnimationController.reverse().orCancel);
        } else {
          isOpened
              ? await childHeightAnimationController.forward().orCancel
              : await childHeightAnimationController.reverse().orCancel;
        }
      } on TickerCanceled {
        // the animation got canceled, probably because we were disposed
      }
    });
  }

  @override
  void dispose() {
    childHeightAnimationController.dispose();
    isOpenController.close();
    isReadyController.close();
    super.dispose();
  }

  Future<void> toggle() async {
    try {
      isOpened = isOpened ? false : true;

      isOpenController.add(isOpened);

      isOpened
          ? await childHeightAnimationController.forward().orCancel
          : await childHeightAnimationController.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  final GlobalKey _headerKey = GlobalKey(debugLabel: 'spoiler_header');
  final GlobalKey _childKey = GlobalKey(debugLabel: 'spoiler_child');

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => setState(() {
              toggle();
            }),
            child: Container(
              key: Key('spoiler_header'),
              child: Container(
                key: _headerKey,
                child: widget.header != null
                    ? Row(
                        children: <Widget>[
                          widget.leadingArrow
                              ? (isOpened
                                  ? Icon(Icons.keyboard_arrow_up)
                                  : Icon(Icons.keyboard_arrow_down))
                              : Container(),
                          widget.header,
                          widget.trailingArrow
                              ? (isOpened
                                  ? Icon(Icons.keyboard_arrow_up)
                                  : Icon(Icons.keyboard_arrow_down))
                              : Container()
                        ],
                      )
                    : _buildDefaultHeader(),
              ),
            ),
          ),
          StreamBuilder<bool>(
              stream: isReady,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data) {
                  return AnimatedBuilder(
                    animation: childHeightAnimation,
                    builder: (BuildContext context, Widget child) => Container(
                      key: isOpened
                          ? Key('spoiler_child_opened')
                          : Key('spoiler_child_closed'),
                      height: childHeightAnimation.value > 0
                          ? childHeightAnimation.value
                          : 0,
                      child: Wrap(
                        children: <Widget>[
                          widget.child != null ? widget.child : Container()
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    key: isOpened
                        ? Key('spoiler_child_opened')
                        : Key('spoiler_child_closed'),
                    child: Container(
                      key: _childKey,
                      child: Wrap(
                        children: <Widget>[
                          widget.child != null ? widget.child : Container()
                        ],
                      ),
                    ),
                  );
                }
              }),
        ],
      );

  Widget _buildDefaultHeader() => StreamBuilder<bool>(
      stream: isOpen,
      initialData: isOpened,
      builder: (context, snapshot) => Container(
          margin: EdgeInsets.all(10),
          height: 20,
          width: 20,
          child: Center(
              child: Center(child: snapshot.data ? Text('-') : Text('+')))));
}
