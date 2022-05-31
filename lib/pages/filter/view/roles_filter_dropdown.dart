import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../resources/locale_provider.dart';
import '../model/filter.dart';
import '../service/roles_filter_provider.dart';

class RolesFilterDropdownController {
  _RolesFilterDropdownState _dropdownTreeState;
}

class RolesFilterDropdown extends StatefulWidget {
  const RolesFilterDropdown({
    final Key key,
    this.leftPadding,
    this.controller,
    this.textStyle,
  }) : super(key: key);

  final double leftPadding;
  final TextStyle textStyle;
  final RolesFilterDropdownController controller;

  @override
  _RolesFilterDropdownState createState() => _RolesFilterDropdownState();
}

class _RolesFilterDropdownState extends State<RolesFilterDropdown> {
  Filter filter;
  List<FilterNode> nodes;

  List<Widget> _buildDropdowns(final BuildContext context) {
    final items = <Widget>[const SizedBox(height: 10)];
    //return [const SizedBox(height: 10)];
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i] != null && nodes[i].children.isNotEmpty) {
        items.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: widget.leftPadding ?? 0),
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
                    nodes = nodes
                      ..removeRange(i + 1, nodes.length)
                      ..add(selected);
                  },
                ),
              ),
            ],
          ),
        );
      }
    }
    return items;
  }

  Future<dynamic> rolesFuture;

  Future<dynamic> _getRoles() async {
    final RolesFilterProvider rolesFilterProvider =
        Provider.of<RolesFilterProvider>(context, listen: false);
    return rolesFilterProvider.fetchRolesFilter();
  }

  @override
  void initState() {
    super.initState();
    rolesFuture = _getRoles();
  }

  @override
  Widget build(final BuildContext context) {
    widget.controller?._dropdownTreeState = this;

    return FutureBuilder(
      future: rolesFuture,
      builder: (final context, final snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            filter = snapshot.data;
            nodes ??= [
              filter.root,
              filter.root.children.last,
              filter.root.children.last.children.first
            ];
            return Column(
              children: _buildDropdowns(context),
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
