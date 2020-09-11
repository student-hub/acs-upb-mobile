import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  static const String routeName = '/filter';

  /// By default, this is [S.of(context).navigationFilter]
  final String title;

  /// Helper text that should show at the top of the page
  final String info;

  /// Additional helper text
  final String hint;

  /// Text for the save button (by default, [S.of(context).buttonApply])
  final String buttonText;

  /// Callback after the user submits the page
  final Function() onSubmit;

  const FilterPage(
      {Key key,
      this.title,
      this.info,
      this.hint,
      this.buttonText,
      this.onSubmit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  Future<Filter> filterFuture;
  int selectedNodes = 0;
  final int maxSelectedNodes = 10;

  void _onSelected(bool selection, FilterNode node) => setState(() {
        if (node.value == selection) return;

        if (selection) {
          selectedNodes++;
        } else {
          selectedNodes--;
        }

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
          pageBuilder: (context, animation1, animation2) => FilterPage(
            title: widget.title,
            info: widget.info,
            hint: widget.hint,
            buttonText: widget.buttonText,
            onSubmit: widget.onSubmit,
          ),
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
      SelectableController controller = SelectableController();
      listItems.add(Selectable(
        label: child.name,
        initiallySelected: child.value,
        controller: controller,
        onSelected: (selection) {
          if (selection && selectedNodes >= maxSelectedNodes) {
            AppToast.show(
                S.of(context).warningOnlyNOptionsAtATime(maxSelectedNodes));
            controller.deselect();
            return;
          }

          level != 0
              ? _onSelected(selection, child)
              : _onSelectedExclusive(selection, child, node.children);
        },
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
      filterFuture = filterProvider.fetchFilter(context);
    }

    return AppScaffold(
      title: widget.title ?? S.of(context).navigationFilter,
      actions: [
        AppScaffoldAction(
          text: widget.buttonText ?? S.of(context).buttonApply,
          onPressed: () {
            if (widget.onSubmit != null) {
              widget.onSubmit();
            }
            filterProvider.enableFilter();
            Navigator.of(context).pop();
          },
        )
      ],
      body: FutureBuilder(
          future: filterFuture,
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.connectionState == ConnectionState.done && snap.hasData) {
              Filter filter = snap.data;

              selectedNodes = filter.relevantNodes.length - 1;

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

            return ListView(
                children: <Widget>[
                      if (widget.info != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10.0),
                          child: IconText(
                            icon: Icons.info,
                            text: widget.info,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      if (widget.hint != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Text(
                            widget.hint,
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                        )
                    ] +
                    widgets);
          }),
    );
  }
}
