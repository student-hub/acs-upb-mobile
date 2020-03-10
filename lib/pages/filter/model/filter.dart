/// Filter represented in the form of a tree with named levels
///
///                                 All
///                    _______________|_______________
///                  /                                \
///                BSc                               MSc       // Degree
///         ________|________                 ________|__ ...
///       /                  \              /     |
///      IS                 CTI            IA   SPRC ...       // Specialization
///   ...|...          ______|______       ⋮      ⋮
///                  /    |     |   \
///                  1    2    3    4                          // Year
///                  ⋮    ⋮   __|... ⋮
///                        /   |
///                       CA  CB ...                           // Series
///                     __|...
///                   /   |
///                 331  332 ...                               // Group
class Filter {
  /// Tree structure
  FilterNode root;

  /// Name of each level of the tree
  ///
  /// **Note:** There should be at least as many names as there are levels in the tree.
  List<String> levelNames;

  Filter({this.root, this.levelNames});
}

class FilterNode {
  /// Name of node
  String name;

  /// Whether (at least one) child should be included in the results
  bool value;

  /// Children of node
  List<FilterNode> children;

  FilterNode({this.name = '', this.value = false, this.children});
}
