import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleImage extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Function() onTap;
  final String label;
  final String tooltip;

  const CircleImage({Key key, this.image, this.onTap, this.label, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    var circleImage = GestureDetector(
      onTap: onTap,
      child: Column(
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
          label != null
              ? Container(
                  height: ScreenUtil().setHeight(80),
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: AutoSizeText(
                      label,
                      textAlign: TextAlign.center,
                      minFontSize: 10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      wrapWords: false,
                    ),
                  ))
              : Container(),
        ],
      ),
    );

    if (tooltip != null && tooltip != '') {
      return Tooltip(message: tooltip, child: circleImage);
    }
    return circleImage;
  }
}
