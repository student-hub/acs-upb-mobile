import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class AppSpoiler extends StatelessWidget {
  final String title;
  final Widget content;
  final bool initialExpanded;

  AppSpoiler(
      {Key key, this.title = "", Widget content, this.initialExpanded = true})
      : this.content = content ?? Container(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ExpandableTheme(
            data: ExpandableThemeData(
                useInkWell: false,
                crossFadePoint: 0.5,
                hasIcon: true,
                iconPlacement: ExpandablePanelIconPlacement.left,
                iconColor: Theme.of(context).textTheme.headline6.color,
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                iconPadding: EdgeInsets.only()),
            child: ExpandablePanel(
              controller:
                  ExpandableController(initialExpanded: initialExpanded),
              header: Text(title, style: Theme.of(context).textTheme.headline6),
              collapsed: SizedBox(height: 12.0),
              expanded: content,
            ),
          ),
        ],
      ),
    );
  }
}
