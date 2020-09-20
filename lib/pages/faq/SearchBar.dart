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
  bool _animate = true;

  @override
  Widget build(BuildContext context) {
    double widthMax = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 4),
        Flexible(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: _animate ? widthMax * .8 : widthMax,
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
          child: AnimatedOpacity(
            opacity: _animate ? 1.0 : 0,
            curve: Curves.easeIn,
            duration: Duration(milliseconds: _animate ? 1000 : 0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: _animate ? MediaQuery.of(context).size.width * .2 : 0,
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Text('Cancel'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
