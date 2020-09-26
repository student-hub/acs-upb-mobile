import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function() cancel;
  final Function(String) onSearch;
  final textController;

  SearchBar({this.cancel, this.textController, this.onSearch});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 4),
        Flexible(
          child: Container(
            width: maxWidth * .8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(142, 142, 147, .15),
            ),
            child: TextField(
              autofocus: true,
              controller: widget.textController,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.cancel,
          child: Container(
            width: MediaQuery.of(context).size.width * .2,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Text(S.of(context).buttonCancel),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  final Widget title;
  final Function() cancelCallback;
  final searchClosed;

  SearchWidget(
      {this.onSearch, this.title, this.cancelCallback, this.searchClosed});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: widget.searchClosed
          ? Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: widget.title,
            )
          : Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: SearchBar(
                textController: _textEditingController,
                onSearch: widget.onSearch,
                cancel: () {
                  setState(() {
                    _textEditingController.clear();
                    widget.cancelCallback();
                  });
                },
              ),
            ),
    );
  }
}
