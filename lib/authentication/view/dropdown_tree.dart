import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/form/form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownTree extends StatefulWidget {
  List<FormItem> formItems;
  Filter filter;
  List<FilterNode> nodes;
  FilterProvider filterProvider;
  final List<String> path;
  final EdgeInsetsGeometry paddingField;
  final EdgeInsetsGeometry paddingDropDownButton;
  final EdgeInsetsGeometry paddingIndicator;

  DropdownTree({
    Key key,
    this.path,
    this.paddingField,
    this.paddingDropDownButton,
    this.paddingIndicator,
  }) : super(key: key);

  @override
  _DropdownTreeState createState() => _DropdownTreeState();
}

class _DropdownTreeState extends State<DropdownTree> {
  void _fetchFilter() async {
    widget.filterProvider = Provider.of<FilterProvider>(context, listen: false);
    widget.filter = await widget.filterProvider.fetchFilter(context);
    if (widget.path == null) {
      widget.nodes = [widget.filter.root];
    } else {
      widget.nodes = widget.filter.findNodeByPath(widget.path);
    }
    setState(() {});
  }

  initState() {
    super.initState();
    _fetchFilter();
  }

  List<Widget> _dropdownTree(BuildContext context) {
    List<Widget> items = [SizedBox(height: 8)];

    if (widget.filter == null || widget.nodes == null) {
      items.add(Padding(
        padding: widget.paddingIndicator != null
            ? widget.paddingIndicator
            : const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      ));
    } else {
      for (var i = 0; i < widget.nodes.length; i++) {
        if (widget.nodes[i] != null && widget.nodes[i].children.isNotEmpty) {
          items.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: widget.paddingField != null
                    ? widget.paddingField
                    : const EdgeInsets.all(8.0),
                child: Text(
                  widget.filter.localizedLevelNames[i]
                      [LocaleProvider.localeString],
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .apply(color: Theme.of(context).hintColor),
                ),
              ),
              DropdownButtonFormField<FilterNode>(
                value: widget.nodes.length > i + 1 ? widget.nodes[i + 1] : null,
                items: widget.nodes[i].children
                    .map((node) => DropdownMenuItem(
                          value: node,
                          child: Padding(
                            padding: widget.paddingDropDownButton != null
                                ? widget.paddingDropDownButton
                                : const EdgeInsets.all(8.0),
                            child: Text(node.name),
                          ),
                        ))
                    .toList(),
                onChanged: (selected) => setState(
                  () {
                    widget.nodes.removeRange(i + 1, widget.nodes.length);
                    widget.nodes.add(selected);
                  },
                ),
              ),
            ],
          ));
        }
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: _dropdownTree(context),);
  }
}
