import 'package:meta/meta.dart';

class Class {
  final String id;
  final String name;
  final String acronym;
  final int credits;
  final String degree;
  final String domain;
  final String year;
  final String semester;
  final String series;

  Class({@required this.id, this.name, this.acronym, this.credits, this.degree, this.domain,
      this.year, this.semester, this.series});
}
