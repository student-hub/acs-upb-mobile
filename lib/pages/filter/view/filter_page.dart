import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  static const String routeName = '/filter';

  @override
  State<StatefulWidget> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  Future<Filter> filterFuture;

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
    if (filterFuture == null) {
      // Only fetch filter once
      filterFuture = Provider.of<FilterProvider>(context).getRelevanceFilter();
    }

    return AppScaffold(
      title: S.of(context).navigationFilter,
      enableMenu: false,
      body: FutureBuilder(
          future: filterFuture,
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.hasData) {
              Filter filter = snap.data;

              Map<int, List<Widget>> optionsByLevel = {};
              buildTree(node: filter.root, optionsByLevel: optionsByLevel);
              List<Widget> widgets = [];
              for (var i = 0; i < filter.localizedLevelNames.length; i++) {
                if (optionsByLevel[i] == null) {
                  break;
                }

                // Level name
                widgets.add(Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      filter.localizedLevelNames[i][Utils.getLocale(context)],
                      style: Theme.of(context).textTheme.headline6),
                ));

                // Level options
                widgets.addAll(optionsByLevel[i]);
              }

              return ListView(children: widgets);
            } else if (snap.hasError) {
              print(snap.error);
              // TODO: Show error toast
              return Container();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
