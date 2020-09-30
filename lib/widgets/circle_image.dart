import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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

  final double circleSize;

  /// Fade image using [overlayColor] and display [overlayIcon] on top of it
  final bool enableOverlay;

  final Icon overlayIcon;

  final Color overlayColor;

  const CircleImage(
      {Key key,
      this.image,
      this.icon,
      this.onTap,
      this.label,
      this.tooltip,
      double circleSize,
      bool enableOverlay,
      this.overlayIcon,
      this.overlayColor})
      : circleSize = circleSize ?? 80,
        enableOverlay = enableOverlay ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var circleImage = GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: circleSize,
            child: Stack(
              children: <Widget>[
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: image != null
                      ? BoxDecoration(
                          boxShadow: [
                            CustomBoxShadow(blurRadius: 12.0),
                            CustomBoxShadow(blurRadius: 10.0),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              colorFilter: enableOverlay
                                  ? ColorFilter.mode(
                                      overlayColor ?? Colors.blueGrey[200],
                                      BlendMode.lighten,
                                    )
                                  : null,
                              image: image),
                        )
                      : BoxDecoration(
                          boxShadow: [
                            CustomBoxShadow(blurRadius: 12.0),
                            CustomBoxShadow(blurRadius: 10.0),
                          ],
                          shape: BoxShape.circle,
                          color: Theme.of(context)
                              .backgroundColor
                              .withOpacity(0.6),
                        ),
                  child: icon,
                ),
                enableOverlay
                    ? Container(
                        width: circleSize,
                        height: circleSize,
                        child: Center(
                          child: overlayIcon ??
                              Icon(
                                Icons.edit,
                                color: Colors.grey[700],
                              ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          label != null
              ? Container(
                  height: 40.0,
                  width: circleSize,
                  child: Center(
                    child: AutoSizeText(
                      label,
                      textAlign: TextAlign.center,
                      minFontSize: 10,
                      maxLines: 2,
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
