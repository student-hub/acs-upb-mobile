import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  static const String routeName = '/filter';

  @override
  State<StatefulWidget> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  void buildTree(
      {FilterNode node, Map<int, List<Widget>> optionsByLevel, int level = 0}) {
    if (node.children == null) {
      return;
    }

    optionsByLevel.putIfAbsent(level, () => <Widget>[]);

    for (var child in node.children) {
      // Add option
      optionsByLevel[level].add(Selectable(
        label: child.name,
        initiallySelected: child.value,
      ));

      // Add padding
      optionsByLevel[level].add(SizedBox(width: 10));

      // Display children if selected
      if (child.value == true) {
        buildTree(
            node: child, optionsByLevel: optionsByLevel, level: level + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Test filter
    Filter filter = Filter(
        levelNames: ['Degree', 'Specialization', 'Year', 'Series', 'Group'],
        root: FilterNode(name: 'All', value: true, children: [
          FilterNode(
              name: 'BSc',
              value: true,
              children: [FilterNode(name: 'CTI', value: true, children: [
                FilterNode(
                  name: '1',
                  value: true,
                  children: [
                    FilterNode(
                      name: 'CA'
                    ),
                    FilterNode(
                        name: 'CB',
                      value: true,
                      children: [
                        FilterNode(
                          name: '311'
                        ),
                        FilterNode(
                            name: '312'
                        ),
                        FilterNode(
                            name: '313'
                        ),
                        FilterNode(
                            name: '314',
                          value: true,
                        ),
                      ],
                    ),
                    FilterNode(
                        name: 'CC'
                    ),
                    FilterNode(
                        name: 'CD'
                    ),
                  ]
                ),
                FilterNode(
                    name: '2',
                ),
                FilterNode(
                    name: '3',
                ),
                FilterNode(
                    name: '4',
                ),
              ]), FilterNode(name: 'IS')]),
          FilterNode(name: 'MSc', children: [
            FilterNode(
              name: 'IA',
            ),
            FilterNode(name: 'SPRC'),
          ])
        ]));

    Map<int, List<Widget>> optionsByLevel = {};
    buildTree(node: filter.root, optionsByLevel: optionsByLevel);
    List<Widget> widgets = [];
    for (var i = 0; i < filter.levelNames.length; i++) {
      if (optionsByLevel[i] == null) {
        break;
      }

      // Level name
      widgets.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(filter.levelNames[i],
            style: Theme.of(context).textTheme.headline6),
      ));

      // Level options
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: optionsByLevel[i],
          ),
        ),
      ));
    }

    return AppScaffold(
      title: S.of(context).navigationFilter,
      enableMenu: false,
      body: ListView(
        children: widgets
      ),
    );
  }
}
