import 'package:flutter/material.dart';

class Selectable extends StatefulWidget {
  final bool initiallySelected;
  final String label;

  Selectable({this.initiallySelected = false, this.label = ""});

  @override
  _SelectableState createState() => _SelectableState();
}

class _SelectableState extends State<Selectable> {
  bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              border: Border.all(color: Theme.of(context).accentColor)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.white24,
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 18, right: 18),
                child: Center(
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
