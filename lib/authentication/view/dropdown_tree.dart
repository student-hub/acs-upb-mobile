import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/form/form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownTree extends StatefulWidget {
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

//  List<String> getNodes(){
//    List<String> result = List();
//    nodes.forEach((element) {result.add(element.name);});
//    return result;
//  }
}

class _DropdownTreeState extends State<DropdownTree> {
  List<FormItem> formItems;
  FilterProvider filterProvider;
  Filter filter;
  List<FilterNode> nodes;

  List<Widget> _dropdownTree(BuildContext context) {
    List<Widget> items = [SizedBox(height: 8)];
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i] != null && nodes[i].children.isNotEmpty) {
        items.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: widget.paddingField != null
                  ? widget.paddingField
                  : const EdgeInsets.all(8.0),
              child: Text(
                filter.localizedLevelNames[i][LocaleProvider.localeString],
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Theme.of(context).hintColor),
              ),
            ),
            DropdownButtonFormField<FilterNode>(
              value: nodes.length > i + 1 ? nodes[i + 1] : null,
              items: nodes[i]
                  .children
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
                  nodes.removeRange(i + 1, nodes.length);
                  nodes.add(selected);
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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<FilterProvider>(context, listen: false)
          .fetchFilter(context),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          filter = snap.data;
          nodes = widget.path == null
              ? [filter.root]
              : filter.findNodeByPath(widget.path);
          return Column(
            children: _dropdownTree(context),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
