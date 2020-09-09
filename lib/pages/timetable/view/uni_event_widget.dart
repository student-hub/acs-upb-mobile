import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:timetable/src/all_day.dart';
import 'package:timetable/timetable.dart';

class UniEventWidget extends StatelessWidget {
  final UniEventInstance event;

  const UniEventWidget(this.event, {Key key})
      : assert(event != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = event.color ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {},
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
              padding: EdgeInsets.fromLTRB(4, 2, 4, 0),
              child: AutoSizeText(
                event.title,
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
            event.mainEvent.localizedType != null
                ? Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      child: AutoSizeText(
                        event.mainEvent
                            .localizedType[LocaleProvider.localeString],
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
                : Container(),
            Expanded(
              child: event.location != null || event.info != null
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
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
    Key key,
    @required this.info,
    this.borderRadius = 4,
    this.onTap,
  })  : assert(event != null),
        assert(info != null),
        assert(borderRadius != null),
        super(key: key);

  /// The event to be displayed.
  final UniEventInstance event;
  final AllDayEventLayoutInfo info;
  final double borderRadius;

  /// An optional [VoidCallback] that will be invoked when the user taps this
  /// widget.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
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
            onTap: onTap,
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4, 2, 0, 2),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: DefaultTextStyle(
          style: context.textTheme.bodyText2.copyWith(
            fontSize: 14,
            color: event.color.highEmphasisOnColor,
          ),
          child: Text(event.title, maxLines: 1),
        ),
      ),
    );
  }
}
