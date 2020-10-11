import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';

class ClassIcon extends StatelessWidget {
  const ClassIcon({
    @required this.classHeader,
    Key key,
    this.selected = false,
  }) : super(key: key);

  final ClassHeader classHeader;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: classHeader.colorFromAcronym,
      child: Container(
        width: 30,
        child: selected
            ? Icon(
                Icons.check,
                color: classHeader.colorFromAcronym.highEmphasisOnColor,
              )
            : Align(
                alignment: Alignment.center,
                child: AutoSizeText(
                  classHeader.acronym,
                  minFontSize: 0,
                  maxLines: 1,
                  style: TextStyle(
                    color: classHeader.colorFromAcronym.highEmphasisOnColor,
                  ),
                ),
              ),
      ),
    );
  }
}
