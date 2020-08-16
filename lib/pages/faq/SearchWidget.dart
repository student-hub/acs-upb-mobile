import 'SearchBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  final Text title;
  final Function() cancelCallback;

  SearchWidget({this.onSearch, this.title, this.cancelCallback});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  bool searchCanceled = true;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: searchCanceled
          ? Row(
        children: [
          Expanded(
            flex: 12,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: widget.title,
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searchCanceled = false;
                });
              },
            ),
          )
        ],
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchBar(
          textController: _textEditingController,
          onSearch: widget.onSearch,
          cancel: () {
            setState(() {
              searchCanceled = true;
              _textEditingController.clear();
              widget.cancelCallback();
            });
          },
        ),
      ),
    );
  }
}
