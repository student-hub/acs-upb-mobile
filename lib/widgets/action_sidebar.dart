import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionSideBar extends StatefulWidget {
  const ActionSideBar(this.actions);

  final List<Widget> actions;

  @override
  _ActionSideBarState createState() => _ActionSideBarState();
}

class _ActionSideBarState extends State<ActionSideBar>
    with SingleTickerProviderStateMixin {
  _ActionSideBarState();

  bool isExtended = false;

  // Max width for the action sidebar to be extendable
  final extendedMaxWidth = 1100;

  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onTap() {
    setState(() {
      isExtended = !isExtended;

      if (isExtended) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > extendedMaxWidth) {
      isExtended = true;
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      left: isExtended ? 0 : 50,
      right: isExtended ? 0 : -50,
      top: 0,
      bottom: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 50),
                child: Container(
                  child: Column(
                    children: widget.actions
                        .map(buildMaterialActionButton)
                        .toList(),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 3,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (MediaQuery.of(context).size.width < extendedMaxWidth)
              Positioned(
                right: 50,
                child: ActionBarButton(onTap, controller),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  ///
  /// Wrap simple action button to enable hover and splash effects
  ///
  AspectRatio buildMaterialActionButton(Widget action) {
    return action == null
        ? null
        : AspectRatio(
            aspectRatio: 1,
            child: Material(
              type: MaterialType.transparency,
              clipBehavior: Clip.none,
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Theme.of(context).primaryColor.withOpacity(0.12),
                  hoverColor: Theme.of(context).primaryColor.withOpacity(0.04),
                ),
                child: action,
              ),
            ),
          );
  }
}

class ActionBarButton extends StatelessWidget {
  const ActionBarButton(this.onTap, this.controller);

  final void Function() onTap;

  final AnimationController controller;

  static const double maxWidth = 50;

  static const double maxHeight = 50;

  Offset get zeroPoint => Offset(maxWidth + 1, 0);

  Set<BezierPoint> getClipPoints() {
    final BezierPoint first = BezierPoint(
        maxWidth / 2 - 5, maxHeight / 5, maxWidth / 2 - 5, maxHeight / 2);
    final BezierPoint second = BezierPoint(
        maxWidth / 2 - 5, 4 * maxHeight / 5, maxWidth + 1, maxHeight);

    return {first, second};
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: onTap,
          child: CustomPaint(
            painter: BoxShadowPainter(
              zeroPoint: zeroPoint,
              points: getClipPoints(),
            ),
            child: ClipPath(
              clipper: CustomMenuClipper(
                  zeroPoint: zeroPoint, points: getClipPoints()),
              child: Container(
                alignment: Alignment.centerRight,
                color: Theme.of(context).bottomAppBarColor,
                child: RotationTransition(
                    turns: Tween(begin: 0.5, end: 0.0).animate(controller),
                    child: const Icon(Icons.double_arrow)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BezierPoint {
  BezierPoint(this.x1, this.y1, this.x2, this.y2);

  double x1;
  double y1;
  double x2;
  double y2;
}

class CustomMenuClipper extends CustomClipper<Path> {
  CustomMenuClipper({@required this.zeroPoint, @required this.points});

  Set<BezierPoint> points;

  Offset zeroPoint;

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(zeroPoint.dx, zeroPoint.dy);

    for (final BezierPoint point in points) {
      path.quadraticBezierTo(point.x1, point.y1, point.x2, point.y2);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BoxShadowPainter extends CustomPainter {
  BoxShadowPainter(
      {@required this.zeroPoint, @required this.points, this.shadowWidth = 3});

  Set<BezierPoint> points;
  Offset zeroPoint;
  int shadowWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.moveTo(zeroPoint.dx, zeroPoint.dy - shadowWidth);

    for (final BezierPoint point in points) {
      path.quadraticBezierTo(
          point.x1 - shadowWidth, point.y1, point.x2 - shadowWidth, point.y2);
    }

    path.close();

    canvas.drawShadow(path, Colors.black45, 5.0, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
