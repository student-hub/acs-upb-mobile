import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar(
      {this.cancel, this.textController, this.onSearch, this.onTap});

  final void Function() cancel;
  final void Function(String) onSearch;
  final void Function() onTap;
  final TextEditingController textController;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(width: 4),
        Flexible(
          child: Container(
            width: maxWidth * .8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromRGBO(142, 142, 147, .15),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                autofocus: true,
                onTap: widget.onTap,
                controller: widget.textController,
                onChanged: widget.onSearch,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search_outlined),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        if (!Platform.isWeb)
          GestureDetector(
            onTap: widget.cancel,
            key: const ValueKey('cancel_search_bar'),
            child: Container(
              width: MediaQuery.of(context).size.width * .2,
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Text(S.current.buttonCancel),
                ),
              ),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    this.onSearch,
    this.header,
    this.cancelCallback,
    this.searchClosed,
    this.onTap,
    this.padding = const EdgeInsets.only(left: 10, top: 10),
  });

  final void Function(String) onSearch;
  final void Function() onTap;
  final Widget header;
  final void Function() cancelCallback;
  final bool searchClosed;
  final EdgeInsets padding;

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.searchClosed || widget.header != null,
      child: Container(
        height: 60,
        child: widget.searchClosed
            ? widget.header
            : Padding(
                padding: widget.padding,
                child: SearchBar(
                  textController: _textEditingController,
                  onSearch: widget.onSearch,
                  onTap: widget.onTap,
                  cancel: () {
                    setState(() {
                      _textEditingController.clear();
                      widget.cancelCallback();
                    });
                  },
                ),
              ),
      ),
    );
  }
}
