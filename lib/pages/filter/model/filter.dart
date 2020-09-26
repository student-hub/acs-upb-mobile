import 'package:flutter/cupertino.dart';

/// Filter represented in the form of a tree with named levels
///
///                                  All
///                    _______________|_______________
///                  /                                \
///                BSc                               MSc       // Degree
///         ________|________                 ________|__ ...
///       /                  \              /     |
///      IS                 CTI            IA   SPRC ...       // Specialization
///   ...|...          ______|______       ⋮      ⋮
///                  /    |     |   \
///               CTI-1 CTI-2 CTI-3 CTI-4                      // Year
///                  ⋮    ⋮   __|... ⋮
///                        /   |
///                     3-CA 3-CB ...                          // Series
///                     __|...
///                   /   |
///               331CA 332CA ...                              // Group
class Filter {
  /// Tree structure for filter.
  ///
  /// **Note:** No two nodes should have the same name.
  FilterNode root;

  /// Name of each level of the tree.
  ///
  /// **Note:** There should be at least as many names as there are levels in the tree.
  final List<Map<String, String>> localizedLevelNames;

  Filter({this.root, this.localizedLevelNames}) {
    this.root.value = true; // root value is true by default
  }

  Filter clone() => Filter(
        root: this.root.clone(),
        localizedLevelNames: this.localizedLevelNames,
      );

  void _relevantNodesHelper(List<String> list, FilterNode node) {
    if (node.value) {
      if (node.children != null) {
        node.children
            .forEach((child) => this._relevantNodesHelper(list, child));
      }
      list.add(node.name);
    }
  }

  /// Get the names of all nodes with `value = true`.
  List<String> get relevantNodes {
    List<String> list = [];
    _relevantNodesHelper(list, root);
    return list;
  }

  List<FilterNode> findNodesByPath(List<String> path) {
    List<FilterNode> result = [root];
    if (path == null) {
      return result;
    }

    for (String element in path) {
      FilterNode aux = result.last.children
          .firstWhere((e) => e.name == element, orElse: () => null);
      if (aux == null) {
        return null;
      }
      result.add(aux);
    }

    return result;
  }

  bool _relevantLeavesHelper(List<String> list, FilterNode node) {
    if (node.value) {
      bool hasSelectedChildren = false;
      if (node.children != null) {
        node.children.forEach((child) =>
            hasSelectedChildren |= _relevantLeavesHelper(list, child));
      }
      if (!hasSelectedChildren) {
        list.add(node.name);
      }

      return true;
    }
    return false;
  }

  /// Extracts the leaves from the tree of selected nodes
  ///
  /// In other words, returns the last selected nodes (the ones that do not have
  /// any selected children).
  List<String> get relevantLeaves {
    List<String> list = [];
    _relevantLeavesHelper(list, root);
    return list;
  }

  /// Get selected node on first level, if there is any
  ///
  /// First level nodes should be mutually exclusive, so this only returns one
  /// value.
  String get baseNode {
    if (root.children != null) {
      var selected =
          root.children.where((child) => child.value == true).toList();
      assert(selected.length <= 1);
      if (selected.length == 1) {
        return selected[0].name;
      }
    }
    return null;
  }

  bool _setRelevantHelper(String nodeName, FilterNode node, bool setParents) {
    if (node.name == nodeName) {
      node.value = true;
      return true;
    }

    bool found = false;
    if (node.children != null) {
      node.children.forEach(
          (child) => found |= _setRelevantHelper(nodeName, child, setParents));
    }

    // Also set the node's parents if `setParents` is `true`
    if (setParents && found) {
      node.value = true;
    }
    return found;
  }

  /// Set the value of node with name [nodeName] and its parents to `true`, on the [baseNode] branch
  bool setRelevantUpToRoot(String nodeName, String baseNode) {
    if (nodeName == 'All') {
      return true;
    }

    bool found = false;
    if (nodeName != null) {
      for (var base in root.children) {
        if (base.name == baseNode) {
          found = _setRelevantHelper(nodeName, base, true);
          break;
        }
      }
    }

    return found;
  }

  bool setRelevantNodes(List<String> nodes) {
    if (nodes == null || nodes.isEmpty) {
      return false;
    }
    bool setAllNodes = true;
    nodes.forEach(
        (node) => setAllNodes &= _setRelevantHelper(node, root, false));
    return setAllNodes;
  }
}

class FilterNode {
  /// Name of node
  final String name;

  /// Whether (at least one) child should be included in the results
  ValueNotifier _valueNotifier;

  /// Children of node
  final List<FilterNode> children;

  FilterNode({this.name = '', bool value, this.children})
      : this._valueNotifier = ValueNotifier(value ?? false);

  get value => _valueNotifier.value;

  set value(bool value) => _valueNotifier.value = value;

  set listener(Function() listener) => _valueNotifier.addListener(listener);

  FilterNode clone() => FilterNode(
        name: name,
        value: value,
        children: children?.map((c) => c.clone())?.toList(),
      );
}
