import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final Text title;
  final Color backgroundColor;
  final Future<dynamic> navigateAfterFuture;
  final double photoSize;
  final dynamic onClick;
  final Color loaderColor;
  final Image image;
  final Text loadingText;
  final ImageProvider imageBackground;
  final Gradient gradientBackground;

  LoadingScreen(
      {this.loaderColor,
      this.photoSize,
      this.onClick,
      @required this.navigateAfterFuture,
      this.title = const Text(''),
      this.backgroundColor = Colors.white,
      this.image,
      this.loadingText = const Text(""),
      this.imageBackground,
      this.gradientBackground});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    widget.navigateAfterFuture.then((navigateTo) {
      if (navigateTo is String) {
        // It's fairly safe to assume this is using the in-built material
        // named route component
        Navigator.of(context).pushReplacementNamed(navigateTo);
      } else if (navigateTo is Widget) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => navigateTo));
      } else {
        throw ArgumentError(
            'widget.navigateAfterSeconds must either be a String or Widget');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: widget.onClick,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: widget.imageBackground == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.imageBackground,
                      ),
                gradient: widget.gradientBackground,
                color: widget.backgroundColor,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Container(child: widget.image),
                            radius: widget.photoSize,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                          ),
                          widget.title
                        ],
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(widget.loaderColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      widget.loadingText
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
