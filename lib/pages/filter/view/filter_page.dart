import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
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

  void _onSelected(bool selection, FilterNode node) => setState(() {
        node.value = selection;
        if (node.children != null) {
          for (var child in node.children) {
            // Deselect all children
            _onSelected(false, child);
          }
        }
      });

  void _onSelectedExclusive(
      bool selection, FilterNode node, List<FilterNode> nodesOnLevel) {
    _onSelected(selection, node);

    // Only one node on level can be selected
    if (selection) {
      for (var otherNode in nodesOnLevel) {
        if (otherNode != node) {
          _onSelected(false, otherNode);
        }
      }

      // For some reason, it doesn't deselect the other nodes unless the entire
      // page is reloaded (curious, since `setState` should technically work).
      // As a workaround, re-push the same page, but without an animation so it
      // looks seamless.
      // TODO: Find a way to fix this properly, since it's still buggy.
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => FilterPage(),
        ),
      );
    }
  }

  void _buildTree(
      {FilterNode node, Map<int, List<Widget>> optionsByLevel, int level = 0}) {
    if (node.children == null || node.children.isEmpty) {
      return;
    }

    optionsByLevel.putIfAbsent(level, () => <Widget>[]);

    // Add list of options
    List<Widget> listItems = [SizedBox(width: 10)];
    optionsByLevel[level].add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
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
        onSelected: (selection) => level != 0
            ? _onSelected(selection, child)
            : _onSelectedExclusive(selection, child, node.children),
      ));

      // Add padding
      listItems.add(SizedBox(width: 10));

      // Display children if selected
      if (child.value == true) {
        _buildTree(
            node: child, optionsByLevel: optionsByLevel, level: level + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var filterProvider = Provider.of<FilterProvider>(context);

    List<Widget> widgets = [SizedBox(height: 10.0)];

    // Only fetch the filter once.
    // This is a tradeoff, since it makes the UI a bit buggy in some cases (for
    // instance if a row shows up before a row that has an option selected, it
    // will have that option selected as well). However, it avoids the page
    // being rebuilt completely every single time something is pressed (which
    // looks really bad and scrolls all the rows back to the beginning).
    if (filterFuture == null) {
      filterFuture = filterProvider.getRelevanceFilter(context);
    }

    return AppScaffold(
      title: S.of(context).navigationFilter,
      enableMenu: true,
      menuText: S.of(context).actionApply,
      menuAction: () {
        filterProvider.enable();
        Navigator.of(context).pop();
      },
      body: FutureBuilder(
          future: filterFuture,
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.connectionState == ConnectionState.done && snap.hasData) {
              Filter filter = snap.data;

              Map<int, List<Widget>> optionsByLevel = {};
              _buildTree(node: filter.root, optionsByLevel: optionsByLevel);
              for (var i = 0; i < filter.localizedLevelNames.length; i++) {
                if (optionsByLevel[i] == null || optionsByLevel.isEmpty) {
                  break;
                }

                // Level name
                widgets.add(Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                  child: Text(
                      filter.localizedLevelNames[i]
                          [LocaleProvider.localeString],
                      style: Theme.of(context).textTheme.headline6),
                ));

                // Level options
                widgets.addAll(optionsByLevel[i]);
              }
            } else if (snap.hasError) {
              print(snap.error);
              // TODO: Show error toast
              return Container();
            } else if (snap.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView(children: widgets);
          }),
    );
  }
}
