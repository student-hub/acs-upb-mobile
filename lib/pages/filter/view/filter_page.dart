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
  Filter filter;

  @override
  void initState() {
    super.initState();
    // Test filter
    filter = Filter(
        levelNames: ['Degree', 'Specialization', 'Year', 'Series', 'Group'],
        root: FilterNode(name: 'All', value: true, children: [
          FilterNode(name: 'BSc', value: true, children: [
            FilterNode(name: 'CTI', value: true, children: [
              FilterNode(name: 'CTI-1', value: true, children: [
                FilterNode(name: '1-CA'),
                FilterNode(
                  name: '1-CB',
                  value: true,
                  children: [
                    FilterNode(name: '311CB'),
                    FilterNode(name: '312CB'),
                    FilterNode(name: '313CB'),
                    FilterNode(
                      name: '314CB',
                      value: true,
                    ),
                  ],
                ),
                FilterNode(name: '1-CC'),
                FilterNode(
                  name: '1-CD',
                  children: [
                    FilterNode(name: '311CD'),
                    FilterNode(name: '312CD'),
                    FilterNode(name: '313CD'),
                    FilterNode(name: '314CD'),
                  ],
                ),
              ]),
              FilterNode(
                name: 'CTI-2',
              ),
              FilterNode(
                name: 'CTI-3',
              ),
              FilterNode(
                name: 'CTI-4',
              ),
            ]),
            FilterNode(name: 'IS')
          ]),
          FilterNode(name: 'MSc', children: [
            FilterNode(
              name: 'IA',
            ),
            FilterNode(name: 'SPRC'),
          ])
        ]));
  }

  void buildTree(
      {FilterNode node, Map<int, List<Widget>> optionsByLevel, int level = 0}) {
    if (node.children == null) {
      return;
    }

    optionsByLevel.putIfAbsent(level, () => <Widget>[]);

    // Add list of options
    List<Widget> listItems = [];
    optionsByLevel[level].add(
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: listItems,
          ),
        ),
      ),
    );

    for (var child in node.children) {
      // Add option
      listItems.add(Selectable(
        label: child.name,
        initiallySelected: child.value,
        onSelected: (selected) => setState(() {
          child.value = selected;
          if (selected) {
            for (var grandchild in child.children) {
              grandchild.value = false;
            }
          }
        }),
      ));

      // Add padding
      listItems.add(SizedBox(width: 10));

      // Display children if selected
      if (child.value == true) {
        buildTree(
            node: child, optionsByLevel: optionsByLevel, level: level + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      widgets.addAll(optionsByLevel[i]);
    }

    return AppScaffold(
      title: S.of(context).navigationFilter,
      enableMenu: false,
      body: ListView(children: widgets),
    );
  }
}
