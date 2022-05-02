import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../resources/locale_provider.dart';
import '../model/filter.dart';
import '../service/filter_provider.dart';

class FilterDropdownController {
  _FilterDropdownState _dropdownTreeState;

  List<String> get path =>
      _dropdownTreeState.nodes.map((final e) => e.name).skip(1).toList();
}

class FilterDropdown extends StatefulWidget {
  const FilterDropdown({
    final Key key,
    this.initialPath,
    this.leftPadding,
    this.controller,
    this.textStyle,
  }) : super(key: key);

  final List<String> initialPath;
  final double leftPadding;
  final FilterDropdownController controller;
  final TextStyle textStyle;

  @override
  _FilterDropdownState createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  FilterProvider filterProvider;
  Filter filter;
  List<FilterNode> nodes;

  List<Widget> _buildDropdowns(final BuildContext context) {
    final items = <Widget>[const SizedBox(height: 10)];
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i] != null && nodes[i].children.isNotEmpty) {
        items.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, left: widget.leftPadding ?? 0),
              child: Text(
                filter.localizedLevelNames[i][LocaleProvider.localeString],
                style: widget.textStyle ??
                    Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(fontSizeFactor: 1.1),
              ),
            ),
            DropdownButtonFormField<FilterNode>(
              value: nodes.length > i + 1 ? nodes[i + 1] : null,
              items: nodes[i]
                  .children
                  .map((final node) => DropdownMenuItem(
                        value: node,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: widget.leftPadding ?? 0),
                          child: Text(node.localizedName(context)),
                        ),
                      ))
                  .toList(),
              onChanged: (final selected) => setState(
                () {
                  nodes
                    ..removeRange(i + 1, nodes.length)
                    ..add(selected);
                },
              ),
            ),
          ],
        ));
      }
    }
    return items;
  }

  @override
  Widget build(final BuildContext context) {
    widget.controller?._dropdownTreeState = this;

    return FutureBuilder(
      future: Provider.of<FilterProvider>(context).fetchFilter(),
      builder: (final context, final snap) {
        if (snap.hasData) {
          filter = snap.data;
          nodes ??= widget.initialPath == null
              ? [filter.root]
              : filter.findNodesByPath(widget.initialPath);
          return Column(
            children: _buildDropdowns(context),
          );
        }
        return const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
