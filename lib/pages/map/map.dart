import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class CampusMap3D extends StatefulWidget {
  const CampusMap3D({Key key}) : super(key: key);

  @override
  _CampusMap3DState createState() => _CampusMap3DState();
}

class _CampusMap3DState extends State<CampusMap3D>{
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            // Pop the category page if Android back button is pressed.
            return true;
          },
          child: UnityWidget(
            onUnityCreated: (controller) => _unityWidgetController = controller,
          ),
        ),
      ),
    );
  }
}