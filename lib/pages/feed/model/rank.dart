import 'package:meta/meta.dart';

class Rank {
  Rank(
      {@required this.name,
      @required this.pointsStart,
      @required this.pointsEnd,
      @required this.requiresApproval});
  final String name;
  final int pointsStart;
  final int pointsEnd;
  final bool requiresApproval;
}
