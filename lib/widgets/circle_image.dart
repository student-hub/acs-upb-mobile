import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Function() onTap;
  final String label;
  final String tooltip;

  const CircleImage({Key key, this.image, this.onTap, this.label, this.tooltip}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var circleImage = Column(
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
          padding: const EdgeInsets.only(top: 4.0),
          child: label != null
              ? Container(
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.width / 12,
                  child: AutoSizeText(
                    label,
                    textAlign: TextAlign.center,
                    minFontSize: 0,
                  ))
              : Container(),
        ),
      ],
    );

    if (tooltip != null && tooltip != '') {
      return Tooltip(message: tooltip, child: circleImage);
    }
    return circleImage;
  }
}
