import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = Colors.black12,
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.outer,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}

class CircleImage extends StatelessWidget {
  final ImageProvider<dynamic> image;

  /// An icon can be used if no image is provided
  final Icon icon;

  final Function() onTap;

  final String label;

  final String tooltip;

  final double circleScaleFactor;

  /// Set this to true if the scaled down circle should be aligned with the
  /// default size circle
  final bool alignWhenScaling;

  const CircleImage(
      {Key key,
      this.image,
      this.icon,
      this.onTap,
      this.label,
      this.tooltip,
      this.circleScaleFactor = 1,
      this.alignWhenScaling = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var circleSize = circleScaleFactor *
        min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) /
        5;
    var circleImage = GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            // Align if [alignWhenScaling] is `true`
            width: circleSize / (alignWhenScaling ? circleScaleFactor : 1),
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: image != null
                  ? BoxDecoration(
                      boxShadow: [
                        CustomBoxShadow(blurRadius: 12.0),
                        CustomBoxShadow(blurRadius: 10.0),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(fit: BoxFit.fill, image: image),
                    )
                  : BoxDecoration(
                      boxShadow: [
                        CustomBoxShadow(blurRadius: 12.0),
                        CustomBoxShadow(blurRadius: 10.0),
                      ],
                      shape: BoxShape.circle,
                      color: Theme.of(context).backgroundColor.withOpacity(0.6),
                    ),
              child: icon,
            ),
          ),
          label != null
              ? Container(
                  height: ScreenUtil().setHeight(100),
                  width: circleSize,
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
