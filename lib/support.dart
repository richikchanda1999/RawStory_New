import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
mixin Design
{
  var appBarCol=Colors.red;
  var cardCol=Colors.black;
  var cardTxtCol=Colors.white;
  var bgCol=Colors.black;
  var buttonCol=Colors.red;
}



double leftOffset = 0.0,
    rightOffset = 0.0,
    bottomOffset = 0.0,
    topOffset = 0.0;

Function(num) get w => ScreenUtil().setWidth;
Function(num) get h => ScreenUtil().setHeight;
Function(num) get sp => ScreenUtil().setSp;

class placementWidget extends StatelessWidget {
  double start, width, top, height, end, bottom;
  Widget child;
  placementWidget(
      {this.start,
        this.width,
        this.top,
        this.height,
        this.end,
        this.bottom,
        this.child});
  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
        textDirection: TextDirection.ltr,
        start: (start != null) ? w(start - leftOffset) : null,
        width: (width != null) ? w(width + 5) : null,
        top: (top != null) ? h(top - topOffset) : null,
        height: (height != null) ? h(height + 10) : null,
        end: (end != null) ? w(end - rightOffset) : null,
        bottom: (bottom != null) ? h(bottom - bottomOffset) : null,
        child: child);
  }
}