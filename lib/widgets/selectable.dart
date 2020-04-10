import 'package:flutter/material.dart';

class SelectableController {
  _SelectableState _selectableState;

  bool get isSelected => _selectableState.isSelected;

  void select() {
    _selectableState.isSelected = true;
  }

  void deselect() {
    _selectableState.isSelected = false;
  }
}

class Selectable extends StatefulWidget {
  final bool initiallySelected;
  final String label;
  final Function(bool) onSelected;
  final SelectableController controller;

  Selectable(
      {this.initiallySelected = false,
      this.label = "",
      this.onSelected,
      this.controller});

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
  Widget build(BuildContext context) {
    widget.controller?._selectableState = this;

    return Container(
      decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).accentColor : Colors.transparent,
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
              widget.onSelected(isSelected);
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
            child: Center(
              child: Text(
                widget.label,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.27,
                  color:
                      isSelected ? Colors.white : Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
