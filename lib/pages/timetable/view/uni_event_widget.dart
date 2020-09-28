import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/view/event_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:timetable/src/all_day.dart';
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
