import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Function() onTap;
  final String label;

  const CircleImage({Key key, this.image, this.onTap, this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 12.0),
                  BoxShadow(color: Colors.black12, blurRadius: 10.0),
                ],
                shape: BoxShape.circle,
                image: DecorationImage(fit: BoxFit.fill, image: image))),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child:
              label != null ? Text(label, textScaleFactor: 1.5) : Container(),
        ),
      ],
    );
  }
}
