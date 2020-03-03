import 'package:flutter/cupertino.dart';

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
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(fit: BoxFit.fill, image: image))),
        label != null ? Text(label, textScaleFactor: 1.5) : Container(),
      ],
    );
  }
}
