import 'package:flutter/cupertino.dart';

class TrapeziumContainer extends StatelessWidget {
  TrapeziumContainer(
      {this.child, this.width, this.alignment, this.color, this.padding});
  final Widget child;
  final double width;
  final Alignment alignment;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: TrapeziumClipper(),
        child: Container(
          child: child,
          width: width,
          alignment: alignment,
          color: color,
          padding: padding,
        ));
  }
}

class TrapeziumClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.moveTo(size.width * 0.1, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.9, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
