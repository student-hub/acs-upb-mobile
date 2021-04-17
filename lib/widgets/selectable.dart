import 'package:flutter/material.dart';

class SelectableController {
  SelectableState selectableState;

  bool get isSelected => selectableState?.isSelected;

  void select() {
    if (selectableState == null) return;
    if (!isSelected) selectableState.isSelected = true;
  }

  void deselect() {
    if (selectableState == null) return;
    if (isSelected) selectableState.isSelected = false;
  }
}

class Selectable extends StatefulWidget {
  const Selectable(
      {this.initiallySelected = false,
      this.label = '',
      this.onSelected,
      this.controller,
      this.disabled = false});

  final bool initiallySelected;
  final String label;
  final void Function(bool) onSelected;
  final SelectableController controller;
  final bool disabled;

  @override
  SelectableState createState() => SelectableState();
}

class SelectableState extends State<Selectable> {
  bool _isSelected;

  set isSelected(bool newValue) {
    _isSelected = newValue;
    setState(() {});
  }

  bool get isSelected => _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    widget.controller?.selectableState = this;

    return Container(
      decoration: BoxDecoration(
        color: _isSelected
            ? (widget.disabled
                ? Theme.of(context).disabledColor
                : Theme.of(context).accentColor)
            : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        border: Border.all(
            color: widget.disabled
                ? Theme.of(context).disabledColor
                : Theme.of(context).accentColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          onTap: () {
            setState(
              () {
                if (!widget.disabled) {
                  _isSelected = !_isSelected;
                }
                widget.onSelected(_isSelected);
              },
            );
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
                  color: _isSelected
                      ? Colors.white
                      : widget.disabled
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
