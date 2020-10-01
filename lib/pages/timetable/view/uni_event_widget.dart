import 'dart:math' as math;

import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/view/event_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timetable/timetable.dart';

class UniEventWidget extends StatelessWidget {
  const UniEventWidget(this.event, {Key key})
      : assert(event != null),
        super(key: key);

  final UniEventInstance event;

  @override
  Widget build(BuildContext context) {
    final color = event.color ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute<EventView>(
        builder: (_) => EventView(event: event),
      )),
      child: Material(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 0.75,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 0),
              child: AutoSizeText(
                event.title ?? event.mainEvent?.classHeader?.acronym ?? '',
                maxLines: 2,
                minFontSize: 4,
                maxFontSize: 12,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color.highEmphasisOnColor,
                    ),
              ),
            ),
            if (event.mainEvent.type != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: AutoSizeText(
                    event.mainEvent.type.toLocalizedString(context),
                    wrapWords: false,
                    minFontSize: 8,
                    maxFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 10,
                          color: color.highEmphasisOnColor,
                        ),
                  ),
                ),
              )
            else
              Container(),
            Expanded(
              child: event.location != null || event.info != null
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: AutoSizeText(
                          event.location ?? event.info,
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 12,
                                color: color.mediumEmphasisOnColor,
                              ),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class UniAllDayEventWidget extends StatelessWidget {
  const UniAllDayEventWidget(
    this.event, {
    @required this.info,
    Key key,
    this.borderRadius = 4,
  })  : assert(event != null),
        assert(info != null),
        assert(borderRadius != null),
        super(key: key);

  /// The event to be displayed.
  final UniEventInstance event;
  final AllDayEventLayoutInfo info;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: CustomPaint(
        painter: AllDayEventBackgroundPainter(
          info: info,
          color: event.color,
          borderRadius: borderRadius,
        ),
        child: Material(
          shape: AllDayEventBorder(
            info: info,
            side: BorderSide.none,
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                Navigator.of(context).push(MaterialPageRoute<EventView>(
              builder: (_) => EventView(event: event),
            )),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 0, 2),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: DefaultTextStyle(
          style: context.textTheme.bodyText2.copyWith(
            fontSize: 14,
            color: event.color.highEmphasisOnColor,
          ),
          child: Text(
            event.title ?? event.mainEvent?.classHeader?.acronym,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class AllDayEventBackgroundPainter extends CustomPainter {
  const AllDayEventBackgroundPainter({
    @required this.info,
    @required this.color,
    this.borderRadius = 0,
  })  : assert(info != null),
        assert(color != null),
        assert(borderRadius != null);

  final AllDayEventLayoutInfo info;
  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _getPath(size, info, borderRadius),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant AllDayEventBackgroundPainter oldDelegate) {
    return info != oldDelegate.info ||
        color != oldDelegate.color ||
        borderRadius != oldDelegate.borderRadius;
  }
}

/// A modified [RoundedRectangleBorder] that morphs to triangular left and/or
/// right borders if not all of the event is currently visible.
class AllDayEventBorder extends ShapeBorder {
  const AllDayEventBorder({
    @required this.info,
    this.side = BorderSide.none,
    this.borderRadius = 0,
  })  : assert(info != null),
        assert(side != null),
        assert(borderRadius != null);

  final AllDayEventLayoutInfo info;
  final BorderSide side;
  final double borderRadius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return AllDayEventBorder(
      info: info,
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return _getPath(rect.size, info, borderRadius);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // For some reason, when we paint the background in this shape directly, it
    // lags while scrolling. Hence, we only use it to provide the outer path
    // used for clipping.
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AllDayEventBorder &&
        other.info == info &&
        other.side == side &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => hashValues(info, side, borderRadius);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'RoundedRectangleBorder')}($side, $borderRadius)';
}

Path _getPath(Size size, AllDayEventLayoutInfo info, double radius) {
  final height = size.height;
  // final radius = borderRadius.coerceAtMost(width / 2);

  final maxTipWidth = height / 4;
  final leftTipWidth = info.hiddenStartDays.coerceAtMost(1) * maxTipWidth;
  final rightTipWidth = info.hiddenEndDays.coerceAtMost(1) * maxTipWidth;

  final width = size.width;
  // final leftTipBase = math.min(leftTipWidth + radius, width - radius);
  // final rightTipBase = math.max(width - rightTipWidth - radius, radius);
  final leftTipBase = info.hiddenStartDays > 0
      ? math.min(leftTipWidth + radius, width - radius)
      : leftTipWidth + radius;
  final rightTipBase = info.hiddenEndDays > 0
      ? math.max(width - rightTipWidth - radius, radius)
      : width - rightTipWidth - radius;

  final tipSize = Size.square(radius * 2);

  // no tip:   0      ≈  0°
  // full tip: PI / 4 ≈ 45°
  final leftTipAngle = math.pi / 2 - math.atan2(height / 2, leftTipWidth);
  final rightTipAngle = math.pi / 2 - math.atan2(height / 2, rightTipWidth);

  return Path()
    ..moveTo(leftTipBase, 0)
    // Right top
    ..arcTo(
      Offset(rightTipBase - radius, 0) & tipSize,
      math.pi * 3 / 2,
      math.pi / 2 - rightTipAngle,
      false,
    )
    // Right tip
    ..arcTo(
      Offset(rightTipBase + rightTipWidth - radius, height / 2 - radius) &
          tipSize,
      -rightTipAngle,
      2 * rightTipAngle,
      false,
    )
    // Right bottom
    ..arcTo(
      Offset(rightTipBase - radius, height - radius * 2) & tipSize,
      rightTipAngle,
      math.pi / 2 - rightTipAngle,
      false,
    )
    // Left bottom
    ..arcTo(
      Offset(leftTipBase - radius, height - radius * 2) & tipSize,
      math.pi / 2,
      math.pi / 2 - leftTipAngle,
      false,
    )
    // Left tip
    ..arcTo(
      Offset(leftTipBase - leftTipWidth - radius, height / 2 - radius) &
          tipSize,
      math.pi - leftTipAngle,
      2 * leftTipAngle,
      false,
    )
    // Left top
    ..arcTo(
      Offset(leftTipBase - radius, 0) & tipSize,
      math.pi + leftTipAngle,
      math.pi / 2 - leftTipAngle,
      false,
    );
}
